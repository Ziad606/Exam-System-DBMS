 -- create schemas
create schema training;

create schema exam;

create schema student;





create table training.Branch (
    branch_id int identity(1,1) primary key,
    branch_name nvarchar(100) not null,
    location nvarchar(255)
);

create table training.Instructor (
    inst_id int identity(1,1) primary key,
    inst_name nvarchar(100) not null,
    email nvarchar(100) not null unique,
    phone nvarchar(11),
    branch_id int foreign key references training.branch(branch_id)
);



create table training.Course (
    crs_id int identity(1,1) primary key,
    crs_name nvarchar(100) not null,
    description nvarchar(255),
    max_degree int not null,
    min_degree int not null,
    inst_id int foreign key references training.instructor(inst_id)
);


create table training.Track (
    track_id int identity(1,1) primary key,
    track_name nvarchar(100) not null
);

create table training.track_course (
    track_id int not null foreign key references training.track(track_id),
    crs_id int not null foreign key references training.Course(crs_id),
    primary key (track_id, crs_id)
);

create table training.branch_track (
    track_id int not null foreign key references training.track(track_id),
    branch_id int not null foreign key references training.branch(branch_id),
    primary key (track_id, branch_id)
);

create table training.Intake (
    intake_id int identity(1,1) primary key,
    date date not null,
	track_id int not null foreign key references training.track(track_id)
);


create table training.Student (
    std_id int identity(1,1) primary key,
    fname nvarchar(50) not null,
    lname nvarchar(50) not null,
    email nvarchar(100) not null unique,
    phone nvarchar(20),
    age int not null,
    address nvarchar(255),
    intake_id int foreign key references training.intake(intake_id),
    branch_id int foreign key references training.branch(branch_id),
    track_id int foreign key references training.track(track_id)
);

create table training.student_course (
    std_id int not null foreign key references training.student(std_id),
    crs_id int not null foreign key references training.course(crs_id),
    primary key (std_id, crs_id)
);

--  Question Management
create table exam.question_types (
    type_id int identity(1,1) primary key,
    type_name nvarchar(50) not null
);

create table exam.Question (
    question_id int identity(1,1) primary key,
    question_text nvarchar(max) not null,
    correct_answer nvarchar(max),
    crs_id int not null foreign key references training.course(crs_id) on delete cascade,
    question_type int not null foreign key references exam.question_types(type_id) on delete cascade
);

create table exam.mcq_choices (
    choice_id int identity(1,1) primary key,
    choice_text nvarchar(255) not null,
    is_correct bit not null,
    question_id int not null foreign key references exam.question(question_id) on delete cascade
);


-- Exam and Results Management
create table exam.Exam (
    exam_id int identity(1,1) primary key,
    no_mcq_ques int not null,
    no_text_ques int not null,
    no_tf_ques int not null,
    degree_mcq_ques int not null,
    degree_text_ques int not null,
    degree_tf_ques int not null,
    exam_type nvarchar(50) not null,
    start_time datetime not null,
    end_time datetime not null,
    total_time int not null,
    crs_id int not null foreign key references training.course(crs_id),
    inst_id int foreign key references training.instructor(inst_id),
    intake_id int foreign key references training.intake(intake_id),
    branch_id int foreign key references training.branch(branch_id),
    track_id int foreign key references training.track(track_id)
);

create table exam.exam_questions (
    exam_question_id int identity(1,1) primary key,
    degree int not null,
    exam_id int not null foreign key references exam.exam(exam_id) on delete cascade,
    question_id int not null foreign key references exam.question(question_id) on delete cascade
);

create table student.student_answers (
    answer_id int identity(1,1) primary key,
    text_answer nvarchar(max),
    is_correct bit,
    exam_id int not null foreign key references exam.exam(exam_id) on delete cascade,
    std_id int not null foreign key references training.student(std_id) on delete cascade,
    question_id int not null foreign key references exam.question(question_id) on delete cascade,
    mcq_answer int foreign key references exam.mcq_choices(choice_id)
);

create table exam.exam_results (
    result_id int identity(1,1) primary key,
    total_degree int null,
    exam_id int not null foreign key references exam.exam(exam_id) on delete cascade,
    std_id int not null foreign key references training.student(std_id) on delete cascade
);


