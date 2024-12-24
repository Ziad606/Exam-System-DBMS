-----------------------------------------------------------------------
------------------------- Test Student Schema -------------------------
-----------------------------------------------------------------------


------------------------- SP_ViewExams -------------------------



--1. Valid Input:

exec SP_ViewExams @std_id = 1;


--2. Student with No Exams:

exec SP_ViewExams @std_id = 999;


--3. Invalid Input:

exec SP_ViewExams @std_id = NULL;



------------------------- SP_GetExamQuestions -------------------------

--1. Valid Input:
exec SP_GetExamQuestions @std_id = 1, @exam_id = 1;


--2. Exam Outside Time:
exec SP_GetExamQuestions @std_id = 2, @exam_id = 2;


--3. Student Not Assigned:
exec SP_GetExamQuestions @std_id = 2, @exam_id = 1;




------------------------- SP_SolveQuestion -------------------------

--1. Submit MCQ Answer:
exec SP_SolveQuestion @std_id = 1, @exam_id = 1, @question_id = 1, @answer = 1;

--2. Duplicate Answer
exec SP_SolveQuestion @std_id = 1, @exam_id = 1, @question_id = 1, @answer = 2;

--3. Submit True/False Answer:
exec SP_SolveQuestion @std_id = 1, @exam_id = 1, @question_id = 35, @answer = 1;







