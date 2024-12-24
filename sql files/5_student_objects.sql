create procedure SP_ViewExams
	@std_id int
as
begin
	select crs.crs_name, e.start_time, e.end_time 
	from exam.exam_results er
	join exam.Exam e
	on er.exam_id = e.exam_id
	join training.Course crs
	on e.crs_id = crs.crs_id
	where er.std_id = @std_id
end;


----------------------------------------------------------


create or alter procedure SP_GetExamQuestions
    @std_id int,
    @exam_id int
as
begin
    set nocount on;

    -- check if the current time is within the exam start and end time
    if not exists (
        select 1
        from exam.exam e
        where e.exam_id = @exam_id
          and getdate() between e.start_time and e.end_time
    )
    begin
        raiserror('The exam is not accessible at this time.', 16, 1);
        return;
    end;

    -- check if the student is assigned to the exam
    if not exists (
        select 1
        from exam.exam_results sa
        where sa.exam_id = @exam_id
          and sa.std_id = @std_id
    )
    begin
        raiserror('The student is not assigned to this exam.', 16, 1);
        return;
    end;

    -- show mcq questions and answers
     select 
        q.question_id,
        q.question_text as mcq_question,
        mc.choice_id,
        mc.choice_text as choice
    from exam.exam_questions eq
    join exam.question q
        on eq.question_id = q.question_id
    left join exam.mcq_choices mc
        on q.question_id = mc.question_id
    where eq.exam_id = @exam_id
      and q.question_type = 1 -- MCQ
    order by q.question_id, mc.choice_id;

	-- show true/false questions
	 select 
        q.question_id,
        q.question_text as tf_question
    from exam.exam_questions eq
    join exam.question q
        on eq.question_id = q.question_id
    where eq.exam_id = @exam_id
      and q.question_type = 2 -- True/False
    order by q.question_id;

	--show text questions
	select 
        q.question_id,
        q.question_text as text_question
    from exam.exam_questions eq
    join exam.question q
        on eq.question_id = q.question_id
    where eq.exam_id = @exam_id
      and q.question_type = 3 -- Text
    order by q.question_id;
end;


----------------------------------------------------------


create procedure SP_SolveQuestion
	@std_id int,
	@exam_id int,
	@question_id int,
	@answer nvarchar(max)
as 
begin
	set nocount on;
	-- check if he already answered this question
	if exists (
		select 1
		from student.student_answers
		where exam_id = @exam_id and std_id = @std_id and question_id = @question_id
	)
	begin
		raiserror('You have already answered this question.', 16, 1);
		return;
	end;

	-- find the question type
	declare @question_type int;
	select @question_type = question_type from exam.Question q
	where q.question_id = @question_id;
	
	-- set the answer based on the question type
	if @question_type = 1 -- mcq
    begin
        insert into student.student_answers (exam_id, std_id, question_id, mcq_answer)
        values (@exam_id, @std_id, @question_id, cast(@answer as int));
    end
    else if @question_type = 2 -- true/false
    begin
        insert into student.student_answers (exam_id, std_id, question_id, is_correct)
        values (@exam_id, @std_id, @question_id, cast(@answer as bit));
    end
    else if @question_type = 3 -- text
    begin
        insert into student.student_answers (exam_id, std_id, question_id, text_answer)
        values (@exam_id, @std_id, @question_id, @answer);
    end
    else
    begin
        raiserror('Invalid question type.', 16, 1);
    end;
end;

