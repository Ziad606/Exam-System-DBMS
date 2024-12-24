-------------------------------------------------------
------------------------Testing------------------------
-------------------------------------------------------



--------------------- SP_AddQuestion ---------------------

--1.Add valid question:
exec SP_AddQuestion 
    @question_text = 'What is normalization?', 
    @correct_answer = 'Organizing data to reduce redundancy', 
    @crs_id = 1, 
    @question_type = 3;

--2. Test with missing parameters:
exec SP_AddQuestion 
    @question_text = null, 
    @correct_answer = 'Organizing data to reduce redundancy', 
    @crs_id = 1, 
    @question_type = 3;





--------------------- SP_AddMcqChoices ---------------------

--1. Add valid choices:
exec SP_AddMcqChoices 
    @choice_text = 'Relational Database', 
    @is_correct = 1, 
    @question_id = 1;
exec SP_AddMcqChoices 
    @choice_text = 'Document Database', 
    @is_correct = 0, 
    @question_id = 1;

--2. Test with invalid question_id:
exec SP_AddMcqChoices 
    @choice_text = 'Relational Database', 
    @is_correct = 1, 
    @question_id = 9999; -- Non-existent question_id



--------------------- SP_CreateRandomExam ---------------------

--1. Create an exam with valid inputs:
exec SP_CreateRandomExam 
    @crs_id = 1, 
    @no_mcq = 5, 
    @degree_mcq_ques = 10, 
    @no_tf = 2, 
    @degree_tf_ques = 5, 
    @no_text = 3, 
    @degree_text_ques = 15, 
    @exam_type = 'Exam', 
    @start_time = '2024-12-18 11:00:00', 
    @end_time = '2024-12-18 13:00:00', 
    @total_time = 120;

	
--2. Test with insufficient questions in the database:
exec SP_CreateRandomExam 
    @crs_id = 1, 
    @no_mcq = 50, -- More than available questions
    @degree_mcq_ques = 10, 
    @no_tf = 2, 
    @degree_tf_ques = 5, 
    @no_text = 3, 
    @degree_text_ques = 15, 
    @exam_type = 'Exam', 
    @start_time = '2024-12-13 09:00:00', 
    @end_time = '2024-12-13 12:00:00', 
    @total_time = 180;



--------------------- SP_AddExamQuestions ---------------------

--1. Add valid questions to an exam:
exec SP_AddExamQuestions 
    @exam_id = 1, 
    @question_id = 1, 
    @degree = 10;

--2. Test with invalid question_id:
exec SP_AddExamQuestions 
    @exam_id = 1, 
    @question_id = 9999, -- Non-existent question_id
    @degree = 10;


--------------------- SP_AssignStudentsToExam ---------------------


--1. Assign multiple students to an exam:
exec SP_AssignStudentsToExam 
    @exam_id = 1, 
    @student_ids = '1,2,3';

--1. Test with invalid exam_id:
exec SP_AssignStudentsToExam 
    @exam_id = 9999, -- Non-existent exam_id
    @student_ids = '1,2,3';


--------------------- SP_CorrectAnswers ---------------------

--1. Correct answers for a valid exam:
exec SP_CorrectAnswers @exam_id = 1;

--2. Test with invalid exam_id:
exec SP_CorrectAnswers @exam_id = 9999; -- Non-existent exam_id


--------------------- SP_CalculateExamResults ---------------------
--1. Retrieve results for a valid exam:
exec SP_CalculateExamResults @exam_id = 1;


--2. Test with invalid exam_id:
exec SP_CalculateExamResults @exam_id = 9999; -- Non-existent exam_id


--------------------- SP_GetExamResults ---------------------

--1. Retrieve results for a valid exam:
exec SP_GetExamResults @exam_id = 1;


--2. Test with invalid exam_id:
exec SP_GetExamResults @exam_id = 9999; -- Non-existent exam_id



--------------------- SP_GetQuestionsByCourse ---------------------

--1. Retrieve questions for a valid course:
exec SP_GetQuestionsByCourse @crs_id = 1;

--2. Test with invalid crs_id:
exec SP_GetQuestionsByCourse @crs_id = 9999; -- Non-existent course





-----------------------Lots of Questions ----------------------------


DECLARE @crs_id INT = 1; 

exec SP_AddQuestion 'What is SQL?', 'Structured Query Language', @crs_id, 1;
exec SP_AddQuestion 'Define DML?', 'Data Manipulation Language', @crs_id, 1;
exec SP_AddQuestion 'Define DDL?', 'Data Definition Language', @crs_id, 1;
exec SP_AddQuestion 'Purpose of PK?', 'Unique Record Identifier', @crs_id, 1;
exec SP_AddQuestion 'What is JOIN?', 'Combine Multiple Tables', @crs_id, 1;
exec SP_AddQuestion 'What is Index?', 'Query Optimization Tool', @crs_id, 1;
exec SP_AddQuestion 'Define Trigger?', 'Automatic Event Handler', @crs_id, 1;
exec SP_AddQuestion 'Purpose of View?', 'Saved SQL Query', @crs_id, 1;
exec SP_AddQuestion 'Define ACID?', 'Transaction Consistency Rules', @crs_id, 1;
exec SP_AddQuestion 'Purpose of COMMIT?', 'Save Transaction Permanently', @crs_id, 1;
exec SP_AddQuestion 'What is RDBMS?', 'Relational Database System', @crs_id, 1;
exec SP_AddQuestion 'Define NULL?', 'Missing or Unknown Value', @crs_id, 1;
exec SP_AddQuestion 'What is INDEX?', 'Improve Query Performance', @crs_id, 1;
exec SP_AddQuestion 'Purpose of ALTER?', 'Modify Table Structure', @crs_id, 1;
exec SP_AddQuestion 'Define UNION?', 'Combine Multiple Queries', @crs_id, 1;
exec SP_AddQuestion 'What is DROP?', 'Delete Table Permanently', @crs_id, 1;
exec SP_AddQuestion 'Purpose of SELECT?', 'Retrieve Table Data', @crs_id, 1;
exec SP_AddQuestion 'What is INSERT?', 'Add New Records', @crs_id, 1;
exec SP_AddQuestion 'Define UPDATE?', 'Modify Existing Data', @crs_id, 1;
exec SP_AddQuestion 'What is DELETE?', 'Remove Table Records', @crs_id, 1;
exec SP_AddQuestion 'Purpose of DISTINCT?', 'Retrieve Unique Values', @crs_id, 1;
exec SP_AddQuestion 'What is GROUP BY?', 'Aggregate Data Groups', @crs_id, 1;
exec SP_AddQuestion 'Define HAVING?', 'Filter Aggregated Data', @crs_id, 1;
exec SP_AddQuestion 'What is WHERE?', 'Filter Query Results', @crs_id, 1;
exec SP_AddQuestion 'Define FOREIGN KEY?', 'Link Between Tables', @crs_id,1 ;
exec SP_AddQuestion 'Purpose of ORDER BY?', 'Sort Query Results', @crs_id, 1;
exec SP_AddQuestion 'What is COUNT?', 'Count Table Rows', @crs_id, 1;
exec SP_AddQuestion 'Purpose of AVG?', 'Calculate Column Average', @crs_id, 1;
exec SP_AddQuestion 'Define MAX?', 'Retrieve Maximum Value', @crs_id, 1;
exec SP_AddQuestion 'What is MIN?', 'Retrieve Minimum Value', @crs_id, 1;

-- إضافة الخيارات لكل سؤال

-- Question 1
exec SP_AddMcqChoice 'Structured Query Language', 1, 1;
exec SP_AddMcqChoice 'Simple Query Language', 0, 1;
exec SP_AddMcqChoice 'Standard Query Library', 0, 1;
exec SP_AddMcqChoice 'SQL Query Language', 0, 1;

-- Question 2
exec SP_AddMcqChoice 'Data Manipulation Language', 1, 2;
exec SP_AddMcqChoice 'Data Management Language', 0, 2;
exec SP_AddMcqChoice 'Data Model Language', 0, 2;
exec SP_AddMcqChoice 'Database Manual Language', 0, 2;

-- Question 3
exec SP_AddMcqChoice 'Data Definition Language', 1, 3;
exec SP_AddMcqChoice 'Data Description Logic', 0, 3;
exec SP_AddMcqChoice 'Database Development Language', 0, 3;
exec SP_AddMcqChoice 'Data Deployment Logic', 0, 3;

-- Question 4
exec SP_AddMcqChoice 'Unique Record Identifier', 1, 4;
exec SP_AddMcqChoice 'Primary Key Identifier', 0, 4;
exec SP_AddMcqChoice 'Unique Column Identifier', 0, 4;
exec SP_AddMcqChoice 'None of the above', 0, 4;

-- Question 5
exec SP_AddMcqChoice 'Combine Multiple Tables', 1, 5;
exec SP_AddMcqChoice 'Separate Table Columns', 0, 5;
exec SP_AddMcqChoice 'Update Table Rows', 0, 5;
exec SP_AddMcqChoice 'Delete Table Rows', 0, 5;

-- Question 6
exec SP_AddMcqChoice 'Query Optimization Tool', 1, 6;
exec SP_AddMcqChoice 'Data Management Tool', 0, 6;
exec SP_AddMcqChoice 'Storage Compression Tool', 0, 6;
exec SP_AddMcqChoice 'Error Checking Tool', 0, 6;

-- Question 7
exec SP_AddMcqChoice 'Automatic Event Handler', 1, 7;
exec SP_AddMcqChoice 'Manual Event Tracker', 0, 7;
exec SP_AddMcqChoice 'Predefined Query Execution', 0, 7;
exec SP_AddMcqChoice 'Dynamic Code Executor', 0, 7;

-- Question 8
exec SP_AddMcqChoice 'Saved SQL Query', 1, 8;
exec SP_AddMcqChoice 'Dynamic Data Filter', 0, 8;
exec SP_AddMcqChoice 'Aggregate Data Function', 0, 8;
exec SP_AddMcqChoice 'Transaction Validator', 0, 8;

-- Question 9
exec SP_AddMcqChoice 'Transaction Consistency Rules', 1, 9;
exec SP_AddMcqChoice 'Data Recovery Rules', 0, 9;
exec SP_AddMcqChoice 'System Security Principles', 0, 9;
exec SP_AddMcqChoice 'Query Execution Plan', 0, 9;


-- Question 10
exec SP_AddMcqChoice 'Save Transaction Permanently', 1, 10;
exec SP_AddMcqChoice 'Rollback Changes', 0, 10;
exec SP_AddMcqChoice 'Backup Data Temporarily', 0, 10;
exec SP_AddMcqChoice 'None of the above', 0, 10;

-- Question 11
exec SP_AddMcqChoice 'Relational Database System', 1, 11;
exec SP_AddMcqChoice 'Object-Oriented Database', 0, 11;
exec SP_AddMcqChoice 'Hierarchical Database Model', 0, 11;
exec SP_AddMcqChoice 'NoSQL Database Type', 0, 11;

-- Question 12
exec SP_AddMcqChoice 'Missing or Unknown Value', 1, 12;
exec SP_AddMcqChoice 'Default Table Value', 0, 12;
exec SP_AddMcqChoice 'Primary Key Placeholder', 0, 12;
exec SP_AddMcqChoice 'Undefined Query Result', 0, 12;

-- Question 13
exec SP_AddMcqChoice 'Improve Query Performance', 1, 13;
exec SP_AddMcqChoice 'Create User Permissions', 0, 13;
exec SP_AddMcqChoice 'Store Data Definitions', 0, 13;
exec SP_AddMcqChoice 'Manage Table Backups', 0, 13;

-- Question 14
exec SP_AddMcqChoice 'Modify Table Structure', 1, 14;
exec SP_AddMcqChoice 'Update Table Records', 0, 14;
exec SP_AddMcqChoice 'Remove Table Rows', 0, 14;
exec SP_AddMcqChoice 'Query Database Metadata', 0, 14;

-- Question 15
exec SP_AddMcqChoice 'Combine Multiple Queries', 1, 15;
exec SP_AddMcqChoice 'Split Query Results', 0, 15;
exec SP_AddMcqChoice 'Filter Duplicate Records', 0, 15;
exec SP_AddMcqChoice 'Group Data Results', 0, 15;

-- Question 16
exec SP_AddMcqChoice 'Delete Table Permanently', 1, 16;
exec SP_AddMcqChoice 'Update Table Values', 0, 16;
exec SP_AddMcqChoice 'Add New Columns', 0, 16;
exec SP_AddMcqChoice 'Drop Query Results', 0, 16;

-- Question 17
exec SP_AddMcqChoice 'Retrieve Table Data', 1, 17;
exec SP_AddMcqChoice 'Define Table Schema', 0, 17;
exec SP_AddMcqChoice 'Delete Database Records', 0, 17;
exec SP_AddMcqChoice 'Manage Database Transactions', 0, 17;

-- Question 18
exec SP_AddMcqChoice 'Add New Records', 1, 18;
exec SP_AddMcqChoice 'Update Existing Records', 0, 18;
exec SP_AddMcqChoice 'Delete Table Columns', 0, 18;
exec SP_AddMcqChoice 'Filter Query Results', 0, 18;

-- Question 19
exec SP_AddMcqChoice 'Modify Existing Data', 1, 19;
exec SP_AddMcqChoice 'Create New Tables', 0, 19;
exec SP_AddMcqChoice 'Delete Table Structures', 0, 19;
exec SP_AddMcqChoice 'Query Database Logs', 0, 19;

-- Question 20
exec SP_AddMcqChoice 'Remove Table Records', 1, 20;
exec SP_AddMcqChoice 'Update Table Metadata', 0, 20;
exec SP_AddMcqChoice 'Create Table Indices', 0, 20;
exec SP_AddMcqChoice 'Rollback Data Changes', 0, 20;

-- Question 21
exec SP_AddMcqChoice 'Retrieve Unique Values', 1, 21;
exec SP_AddMcqChoice 'Filter Query Results', 0, 21;
exec SP_AddMcqChoice 'Group Duplicate Records', 0, 21;
exec SP_AddMcqChoice 'Calculate Data Sums', 0, 21;

-- Question 22
exec SP_AddMcqChoice 'Aggregate Data Groups', 1, 22;
exec SP_AddMcqChoice 'Filter Data Records', 0, 22;
exec SP_AddMcqChoice 'Sort Query Results', 0, 22;
exec SP_AddMcqChoice 'Create Database Triggers', 0, 22;
-- Question 23
exec SP_AddMcqChoice 'Filter Aggregated Data', 1, 23;
exec SP_AddMcqChoice 'Update Data Rows', 0, 23;
exec SP_AddMcqChoice 'Define Foreign Keys', 0, 23;
exec SP_AddMcqChoice 'Delete Data Columns', 0, 23;

-- Question 24
exec SP_AddMcqChoice 'Filter Query Results', 1, 24;
exec SP_AddMcqChoice 'Sort Data Columns', 0, 24;
exec SP_AddMcqChoice 'Retrieve Unique Values', 0, 24;
exec SP_AddMcqChoice 'Define Primary Keys', 0, 24;

-- Question 25
exec SP_AddMcqChoice 'Link Between Tables', 1, 25;
exec SP_AddMcqChoice 'Index Table Columns', 0, 25;
exec SP_AddMcqChoice 'Backup Table Data', 0, 25;
exec SP_AddMcqChoice 'Filter Query Data', 0, 25;

-- Question 26
exec SP_AddMcqChoice 'Sort Query Results', 1, 26;
exec SP_AddMcqChoice 'Define Table Keys', 0, 26;
exec SP_AddMcqChoice 'Aggregate Data Rows', 0, 26;
exec SP_AddMcqChoice 'Query Database Logs', 0, 26;

-- Question 27
exec SP_AddMcqChoice 'Count Table Rows', 1, 27;
exec SP_AddMcqChoice 'Retrieve Max Values', 0, 27;
exec SP_AddMcqChoice 'Filter Duplicate Records', 0, 27;
exec SP_AddMcqChoice 'Group Query Results', 0, 27;

-- Question 28
exec SP_AddMcqChoice 'Calculate Column Average', 1, 28;
exec SP_AddMcqChoice 'Sort Data Rows', 0, 28;
exec SP_AddMcqChoice 'Retrieve Unique Values', 0, 28;
exec SP_AddMcqChoice 'Update Query Data', 0, 28;

-- Question 29
exec SP_AddMcqChoice 'Retrieve Maximum Value', 1, 29;
exec SP_AddMcqChoice 'Count Duplicate Records', 0, 29;
exec SP_AddMcqChoice 'Filter Data Results', 0, 29;
exec SP_AddMcqChoice 'Define Table Keys', 0, 29;

-- Question 30
exec SP_AddMcqChoice 'Retrieve Minimum Value', 1, 30;
exec SP_AddMcqChoice 'Sort Query Results', 0, 30;
exec SP_AddMcqChoice 'Update Table Columns', 0, 30;
exec SP_AddMcqChoice 'Delete Data Rows', 0, 30;




exec SP_AddQuestion 'SQL is a relational database language.', 1, 1, 2;
exec SP_AddQuestion 'Primary keys can have duplicate values.',0 , 1, 2;
exec SP_AddQuestion 'Foreign keys link two tables together.', 1, 1, 2;
exec SP_AddQuestion 'Indexes improve query performance.', 1, 1, 2;
exec SP_AddQuestion 'A view is a stored query.', 1, 1, 2;
exec SP_AddQuestion 'Transactions ensure data integrity.', 1, 1, 2;
exec SP_AddQuestion 'Null values represent missing information.', 1, 1, 2;
exec SP_AddQuestion 'DELETE and TRUNCATE are the same.', 0, 1, 2;
exec SP_AddQuestion 'JOIN is used to combine data from multiple tables.', 1, 1, 2;
exec SP_AddQuestion 'Constraints enforce rules at the table level.', 1, 1, 2;
exec SP_AddQuestion 'Stored procedures are compiled SQL statements.', 1, 1, 2;
exec SP_AddQuestion 'The WHERE clause is used to filter records.', 1, 1, 2;
exec SP_AddQuestion 'HAVING filters grouped data.', 1, 1, 2;
exec SP_AddQuestion 'COUNT(*) returns the total number of rows.', 1, 1, 2;
exec SP_AddQuestion 'ROLLBACK undoes a transaction.', 1, 1, 2;
exec SP_AddQuestion 'A composite key consists of two or more columns.', 1, 1, 2;
exec SP_AddQuestion 'DDL stands for Data Definition Language.', 1, 1, 2;
exec SP_AddQuestion 'TRIGGERS execute automatically in response to events.', 1, 1, 2;
exec SP_AddQuestion 'UNION combines results of two queries.', 1, 1, 2;
exec SP_AddQuestion 'Indexes slow down INSERT operations.', 1, 1, 2;




exec SP_AddQuestion 'What is the purpose of a primary key in a database?','Unique identifier for a record', 1, 3;
exec SP_AddQuestion 'Explain the concept of normalization in databases.', 'Organizing data to reduce redundancy', 1, 3;
exec SP_AddQuestion 'What is the difference between DELETE and TRUNCATE commands?', 'DELETE removes rows with a WHERE clause; TRUNCATE clears the table', 1, 3;
exec SP_AddQuestion 'Describe the ACID properties in database transactions.', 'Atomicity, Consistency, Isolation, Durability', 1, 3;
exec SP_AddQuestion 'What are the advantages of using indexes in a database?', 'Improves query performance by reducing search time', 1, 3;
exec SP_AddQuestion 'Define a foreign key and explain its purpose.', 'Links two tables; ensures referential integrity', 1, 3;
exec SP_AddQuestion 'What are the differences between clustered and non-clustered indexes?', 'Clustered: sorts data physically; Non-clustered: points to data', 1, 3;
exec SP_AddQuestion 'Explain the purpose of a stored procedure in SQL.', 'Reusable SQL code to simplify complex operations', 1, 3;
exec SP_AddQuestion 'What is the difference between INNER JOIN and LEFT JOIN?', 'INNER JOIN: common rows; LEFT JOIN: all from left table', 1, 3;
exec SP_AddQuestion 'Describe the process of creating a database backup in SQL Server.', 'Use BACKUP DATABASE command or GUI tools', 1, 3;


