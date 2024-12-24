

exec SP_AddBranch @branch_name = 'Main Branch', @location = 'Cairo';
exec SP_AddBranch @branch_name = 'Secondary Branch', @location = 'Alexandria';

-- test your self
exec SP_AddBranch @branch_name = 'Third Branch', @location = 'Zagazig';

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

exec SP_AddTrack @track_name = 'Software Development';
exec SP_AddTrack @track_name = 'Data Science';
exec SP_AddTrack @track_name = 'Cybersecurity';

-- test your self
exec SP_AddTrack @track_name = 'Embedded Systems';

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

exec SP_AddTrackToBranch @track_id = 1, @branch_id = 1; -- Software Development to Main Branch
exec SP_AddTrackToBranch @track_id = 2, @branch_id = 1; -- Data Science to Main Branch
exec SP_AddTrackToBranch @track_id = 3, @branch_id = 2; -- Cybersecurity to Secondary Branch

-- test your self
exec SP_AddTrackToBranch @track_id = 4, @branch_id = 3; -- Embedded to Secondary Branch


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

exec SP_AddCourse @crs_name = 'SQL Database', @description = 'Learn SQL database.', @max_degree = 100, @min_degree = 50, @inst_id = null;
exec SP_AddCourse @crs_name = 'Machine Learning Basics', @description = 'Introduction to machine learning concepts.', @max_degree = 100, @min_degree = 50, @inst_id = null;
exec SP_AddCourse @crs_name = 'Network Security', @description = 'Learn how to secure networks.', @max_degree = 100, @min_degree = 50, @inst_id = null;

-- test your self
exec SP_AddCourse @crs_name = 'Embedded C Language', @description = 'Learn advanced C Language.', @max_degree = 100, @min_degree = 50, @inst_id = null;



------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

exec SP_AddCourseToTrack @crs_id = 1, @track_id = 1; -- SQL to Software Development
exec SP_AddCourseToTrack @crs_id = 2, @track_id = 2; -- Machine Learning to Data Science
exec SP_AddCourseToTrack @crs_id = 3, @track_id = 3; -- Network Security to Cybersecurity

-- test your self
exec SP_AddCourseToTrack @crs_id = 4, @track_id = 4; -- Embedded C Language to Embedded Systems


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

exec SP_AddIntake @date = '2024-01-01', @track_id = 1; -- Software Development Intake
exec SP_AddIntake @date = '2024-01-01', @track_id = 2; -- Data Science Intake
exec SP_AddIntake @date = '2024-01-01', @track_id = 3; -- Cybersecurity Intake

-- test your self
exec SP_AddIntake @date = '2024-10-01', @track_id = 4; -- Embedded Systems Intake



------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

-- Students for Software Development
exec SP_AddStudent @fname = 'John', @lname = 'Doe', @email = 'john.doe@example.com', @phone = '1234567890', @age = 22, @address = '123 Main St', @intake_id = 1, @branch_id = 1, @track_id = 1;
exec SP_AddStudent @fname = 'Jane', @lname = 'Smith', @email = 'jane.smith@example.com', @phone = '0987654321', @age = 23, @address = '456 Elm St', @intake_id = 1, @branch_id = 1, @track_id = 1;

-- Students for Data Science
exec SP_AddStudent @fname = 'Alice', @lname = 'Johnson', @email = 'alice.johnson@example.com', @phone = '1122334455', @age = 24, @address = '789 Oak St', @intake_id = 2, @branch_id = 1, @track_id = 2;
exec SP_AddStudent @fname = 'Bob', @lname = 'Brown', @email = 'bob.brown@example.com', @phone = '5544332211', @age = 25, @address = '321 Pine St', @intake_id = 2, @branch_id = 1, @track_id = 2;

-- Students for Cybersecurity
exec SP_AddStudent @fname = 'Charlie', @lname = 'Davis', @email = 'charlie.davis@example.com', @phone = '6677889900', @age = 26, @address = '654 Maple St', @intake_id = 3, @branch_id = 2, @track_id = 3;
exec SP_AddStudent @fname = 'Diana', @lname = 'Evans', @email = 'diana.evans@example.com', @phone = '7788990011', @age = 27, @address = '987 Birch St', @intake_id = 3, @branch_id = 2, @track_id = 3;



-- test your self
-- Students for Embedded Systems
exec SP_AddStudent 
    @fname = 'Edward',  @lname = 'Green', @email = 'edward.green@example.com', @phone = '9988776655',  @age = 28, @address = '12 Elm St', @intake_id = 4, @branch_id = 3,   @track_id = 4;

exec SP_AddStudent 
    @fname = 'Fiona',  @lname = 'Harris',  @email = 'fiona.harris@example.com', @phone = '4455667788',  @age = 24, @address = '34 Pine St', @intake_id = 4, @branch_id = 3, @track_id = 4;



------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

exec SP_AddInstructor 
    @inst_name = 'John Doe', 
    @email = 'john.doe@example.com', 
    @phone = '1234567890', 
    @branch_id = 1;

exec SP_AddInstructor 
    @inst_name = 'Alice Johnson', 
    @email = 'alice.johnson@example.com', 
    @phone = '0987654321', 
    @branch_id = 1;

exec SP_AddInstructor 
    @inst_name = 'Bob Smith', 
    @email = 'bob.smith@example.com',
    @phone = '1122334455', 
    @branch_id = 2;

-- test your self


exec SP_AddInstructor 
    @inst_name = 'Larry Robinson', 
    @email = 'larry.robinson@example.com',
    @phone = '1122334455', 
    @branch_id = 3;

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

-- Assign Instructor to Introduction to Programming
exec SP_AssignInstructorToCourse @course_id = 1, @instructor_id = 1;

-- Assign Instructor to Machine Learning Basics
exec SP_AssignInstructorToCourse @course_id = 2, @instructor_id = 2;

-- Assign Instructor to Network Security
exec SP_AssignInstructorToCourse @course_id = 3, @instructor_id = 3;


-- test your self
exec SP_AssignInstructorToCourse @course_id = 4, @instructor_id = 4;





