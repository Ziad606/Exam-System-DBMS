create procedure SP_AddQuestion
    @question_text nvarchar(max),
    @correct_answer nvarchar(max),
    @crs_id int,
    @question_type int
as
begin
	if @question_text is null 
	begin
		raiserror('Please Enter The Question Text', 16, 1);
	end
	else
	begin
		insert into exam.Question (question_text, correct_answer, crs_id, question_type)
		values (@question_text, @correct_answer, @crs_id, @question_type)
	end;
end;

------------------------------

create procedure SP_AddMcqChoices 
	@choice_text nvarchar(max), 
	@is_correct bit, 
	@question_id int
as 
begin
	insert into exam.mcq_choices (choice_text, is_correct, question_id)
	values (@choice_text, @is_correct, @question_id);
end;


------------------------------

create procedure SP_CreateRandomExam
    @crs_id int,
    @no_mcq int,
	@degree_mcq_ques int,
    @no_tf int,
	@degree_tf_ques int,
    @no_text int,
	@degree_text_ques int,
    @exam_type nvarchar(50),
    @start_time datetime,
    @end_time datetime,
    @total_time int
as
begin                                                                        

	if @no_mcq > dbo.get_no_available_question(1) 
	or @no_tf > dbo.get_no_available_question(2) 
	or @no_text > dbo.get_no_available_question(3)
	begin
		raiserror('Please enter number of questions that is available in the database', 16, 1);
		return;
	end;

	declare @exam_id int;

	insert into exam.exam (no_mcq_ques,degree_mcq_ques, no_text_ques, degree_text_ques, no_tf_ques, degree_tf_ques, exam_type, start_time, end_time, total_time, crs_id)
	values (@no_mcq, @degree_mcq_ques, @no_text, @degree_text_ques, @no_tf, @degree_tf_ques, @exam_type, @start_time, @end_time, @total_time, @crs_id);

	set @exam_id = scope_identity(); 

	-- Add mcq questions to the exam
	insert into exam.exam_questions (degree, exam_id, question_id)
	select top (@no_mcq) @degree_mcq_ques as degree, @exam_id, question_id
	from exam.question
	where crs_id = @crs_id and question_type = 1 
	order by newid();

	-- Add true/false questions to the exam
	insert into exam.exam_questions (degree, exam_id, question_id)
	select top (@no_tf) @degree_tf_ques as degree, @exam_id, question_id
	from exam.question
	where crs_id = @crs_id and question_type = 2 -- True/False type
	order by newid();

	-- Add Text questions to the exam
	insert into exam.exam_questions (degree, exam_id, question_id)
	select top (@no_text) @degree_text_ques as degree, @exam_id, question_id
	from exam.question
	where crs_id = @crs_id and question_type = 3 -- Text type
	order by newid();
	print 'Exam created successfully';
end;                                                                        




-------------------------


create procedure SP_GetExamResults
    @exam_id int
as
begin
    select s.std_id, 
           concat(s.fname, ' ', s.lname) as StudentName,
		   r.total_degree
    from exam.exam_results r
    join training.Student s on r.std_id = s.std_id
    where r.exam_id = @exam_id;
end;


-----------------------


create procedure SP_GetQuestionsByCourse
    @crs_id int
as
begin
    select q.question_id, 
           q.question_text, 
           qt.type_name as QuestionType
    from exam.Question q
    join exam.question_types qt on q.question_type = qt.type_id
    where q.crs_id = @crs_id;
end;

-----------------------


create procedure SP_AssignStudentsToExam
    @exam_id int,
    @student_ids nvarchar(max) -- List of student IDs, e.g., '1,2,3'
as
begin
    declare @id_table table (std_id int);
 
    insert into @id_table (std_id)
    select value
    from string_split(@student_ids, ',');

    insert into exam.exam_results (exam_id, std_id)
    select @exam_id, std_id
    from @id_table;
end;


-------------------------------------------

create procedure SP_AddExamQuestions
    @exam_id int,
    @question_id int,
    @degree int
as
begin
    begin try
        insert into exam.exam_questions (exam_id, question_id, degree)
        values (@exam_id, @question_id, @degree);
        print 'Question added successfully to the exam.';
    end try
    begin catch
        print 'Error: ' + ERROR_MESSAGE();
    end catch
end;

-------------------------------------------

create or alter  procedure SP_CorrectAnswers
    @exam_id int
as
begin

	if not exists (
		select 1 from exam.Exam e
		where e.exam_id = @exam_id
	)
	begin
		raiserror('There is no such exam.', 16, 1);
	end;
    begin try
       
        update student.student_answers
        set is_correct = 
            case
                -- 1. mcq question
                when mcq_answer is not null then 
                    case 
                        when mcq_answer in (
                            select choice_id 
                            from exam.mcq_choices 
                            where question_id = student_answers.question_id 
                              and is_correct = 1
                        ) then 1 
                        else 0 
                    end

                -- 2. true/false question
                when text_answer is not null and question_id in (
                    select question_id 
                    from exam.question 
                    where question_type = 2 
                ) then 
                    case
                        when cast(text_answer as int) = (
                            select cast(correct_answer as int)
                            from exam.question 
                            where question_id = student_answers.question_id
                        ) then 1
                        else 0
                    end

                -- 3. text question
                when text_answer is not null and question_id in (
                    select question_id 
                    from exam.question 
                    where question_type = 3 
                ) then null 

                else 0
            end
        where exam_id = @exam_id;

        print 'answers corrected successfully.';
    end try
    begin catch
        print 'ERROR: ' + ERROR_MESSAGE();
    end catch
end;

-------------------------------------------------

create procedure SP_CalculateExamResults
    @exam_id int
as
begin
    set nocount on;

    begin try
        -- Update the total degree for each student assigned to the exam
        update er
        set total_degree = 
        (
            select sum(
                case 
                    when sa.is_correct = 1 then eq.degree -- If the answer is correct, add the degree
                    else 0 -- Otherwise, add 0
                end
            )
            from student.student_answers sa
            join exam.exam_questions eq 
                on sa.question_id = eq.question_id 
                and sa.exam_id = eq.exam_id
            where sa.exam_id = @exam_id
              and sa.std_id = er.std_id
        )
        from exam.exam_results er
        where er.exam_id = @exam_id;

        print 'Exam results calculated and updated successfully.';
    end try
    begin catch
        -- Error handling
        print 'Error: ' + ERROR_MESSAGE();
    end catch
end;

-------------------------------------------------


create procedure SP_ShowStudentInfo
	@std_id int
as
begin
	select 
		s.std_id as student_id,
		concat(s.fname, ' ', s.lname) as student_name,
		s.email,
		s.phone,
		s.age,
		s.address,
		i.date as intake,
		b.branch_name,
		t.track_name
	from training.Student s
	join training.Intake i
		on s.intake_id = i.intake_id
	join training.Branch b
		on s.branch_id = b.branch_id
	join training.Track t
		on s.track_id = t.track_id
	where s.std_id = @std_id;
end;

---------------------------------------------


create function get_no_available_question(@question_type int)
returns int
as
begin
    declare @no_question int;

    select @no_question = count(q.question_id)
    from exam.Question q
    where q.question_type = @question_type;

    return @no_question;
end;


