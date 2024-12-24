
create procedure SP_AddCourse
    @crs_name nvarchar(100),
    @description nvarchar(255),
    @max_degree int,
    @min_degree int,
    @inst_id int
as
begin
    insert into training.Course (crs_name, description, max_degree, min_degree, inst_id)
    values (@crs_name, @description, @max_degree, @min_degree, @inst_id);
end;
-------------------------------------------

create procedure SP_AddInstructor
    @inst_name nvarchar(100),
    @email nvarchar(100),
    @phone nvarchar(20),
    @branch_id int
as
begin
    set nocount on;

    -- Insert the new instructor into the Instructor table
    insert into training.Instructor (inst_name, email, phone, branch_id)
    values (@inst_name, @email, @phone, @branch_id);

    print 'Instructor added successfully.';
end;

-----------------------------------------
create procedure SP_AssignInstructorToCourse
    @course_id int,
    @instructor_id int
as
begin
    update training.Course
    set inst_id = @instructor_id
    where crs_id = @course_id;
end;

--------------------------------------

create procedure SP_AddBranch
    @branch_name nvarchar(100),
    @location nvarchar(255)
as
begin
    insert into training.Branch (branch_name, location)
    values (@branch_name, @location);
end;

exec SP_AddBranch 'Main Branch', 'Cairo'

--------------------------------------

create procedure SP_AddTrackToBranch
    @track_id int,
    @branch_id int
as
begin
    insert into training.branch_track(track_id, branch_id)
    values (@track_id, @branch_id);
end;


--------------------------------------

create procedure SP_AddTrack
    @track_name nvarchar(100)
as
begin
    insert into training.Track (track_name)
    values (@track_name);
end;

--------------------------------------


create procedure SP_AddCourseToTrack
    @crs_id int,
	@track_id int
as
begin
    insert into training.track_course(crs_id, track_id)
    values (@crs_id, @track_id);
end;

--------------------------------------

create procedure SP_AddIntake
    @date date,
	@track_id int
as
begin
    insert into training.Intake (date, track_id)
    values (@date, @track_id);
end;


--------------------------------------

create procedure SP_AddStudent
    @fname nvarchar(50),
    @lname nvarchar(50),
    @email nvarchar(100),
    @phone nvarchar(20),
    @age int,
    @address nvarchar(255),
    @intake_id int,
    @branch_id int,
    @track_id int
as
begin
	declare @std_id int;

    insert into training.Student (fname, lname, email, phone, age, address, intake_id, branch_id, track_id)
    values (@fname, @lname, @email, @phone, @age, @address, @intake_id, @branch_id, @track_id);
		
	set @std_id = scope_identity();

	insert into training.student_course(std_id, crs_id)
	select @std_id,  crs_id
	from training.track_course tc
	where tc.track_id = @track_id;
end;



--------------------------------------



create function get_course_count_for_instructor (@instructor_id int)
returns int
as
begin
    declare @course_count int;
    select @course_count = count(*) 
    from training.Course 
    where inst_id = @instructor_id;
    return @course_count;
end;

--------------------------------------



create function get_instructor_name (@instructor_id int)
returns nvarchar(100)
as
begin
    declare @name nvarchar(100);
    select @name = inst_name 
    from training.Instructor 
    where inst_id = @instructor_id;
    return @name;
end;