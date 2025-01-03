/****** Object:  Database [exam_system]    Script Date: 12/19/2024 4:30:28 PM ******/
CREATE DATABASE [exam_system]  (EDITION = 'GeneralPurpose', SERVICE_OBJECTIVE = 'GP_S_Gen5_1', MAXSIZE = 32 GB) WITH CATALOG_COLLATION = SQL_Latin1_General_CP1_CI_AS, LEDGER = OFF;
GO
ALTER DATABASE [exam_system] SET COMPATIBILITY_LEVEL = 160
GO
ALTER DATABASE [exam_system] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [exam_system] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [exam_system] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [exam_system] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [exam_system] SET ARITHABORT OFF 
GO
ALTER DATABASE [exam_system] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [exam_system] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [exam_system] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [exam_system] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [exam_system] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [exam_system] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [exam_system] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [exam_system] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [exam_system] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [exam_system] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [exam_system] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [exam_system] SET  MULTI_USER 
GO
ALTER DATABASE [exam_system] SET ENCRYPTION ON
GO
ALTER DATABASE [exam_system] SET QUERY_STORE = ON
GO
ALTER DATABASE [exam_system] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
/*** The scripts of database scoped configurations in Azure should be executed inside the target database connection. ***/
GO
-- ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8;
GO
/****** Object:  User [tm_1]    Script Date: 12/19/2024 4:30:29 PM ******/
CREATE USER [tm_1] FOR LOGIN [tm_1] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [std_1]    Script Date: 12/19/2024 4:30:29 PM ******/
CREATE USER [std_1] FOR LOGIN [std_1] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [inst_1]    Script Date: 12/19/2024 4:30:29 PM ******/
CREATE USER [inst_1] FOR LOGIN [inst_1] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [training_manager]    Script Date: 12/19/2024 4:30:29 PM ******/
CREATE ROLE [training_manager]
GO
/****** Object:  DatabaseRole [student]    Script Date: 12/19/2024 4:30:29 PM ******/
CREATE ROLE [student]
GO
/****** Object:  DatabaseRole [instructor]    Script Date: 12/19/2024 4:30:30 PM ******/
CREATE ROLE [instructor]
GO
/****** Object:  DatabaseRole [admin]    Script Date: 12/19/2024 4:30:30 PM ******/
CREATE ROLE [admin]
GO
sys.sp_addrolemember @rolename = N'training_manager', @membername = N'tm_1'
GO
sys.sp_addrolemember @rolename = N'student', @membername = N'std_1'
GO
sys.sp_addrolemember @rolename = N'instructor', @membername = N'inst_1'
GO
/****** Object:  Schema [exam]    Script Date: 12/19/2024 4:30:33 PM ******/
CREATE SCHEMA [exam]
GO
/****** Object:  Schema [student]    Script Date: 12/19/2024 4:30:33 PM ******/
CREATE SCHEMA [student]
GO
/****** Object:  Schema [training]    Script Date: 12/19/2024 4:30:33 PM ******/
CREATE SCHEMA [training]
GO
/****** Object:  UserDefinedFunction [dbo].[get_course_count_for_instructor]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[get_course_count_for_instructor] (@instructor_id int)
returns int
as
begin
    declare @course_count int;
    select @course_count = count(*) 
    from training.Course 
    where inst_id = @instructor_id;
    return @course_count;
end;
GO
/****** Object:  UserDefinedFunction [dbo].[get_instructor_name]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[get_instructor_name] (@instructor_id int)
returns nvarchar(100)
as
begin
    declare @name nvarchar(100);
    select @name = inst_name 
    from training.Instructor 
    where inst_id = @instructor_id;
    return @name;
end;
GO
/****** Object:  UserDefinedFunction [dbo].[get_no_available_question]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[get_no_available_question](@question_type int)
returns int
as
begin
    declare @no_question int;

    select @no_question = count(q.question_id)
    from exam.Question q
    where q.question_type = @question_type;

    return @no_question;
end;
GO
/****** Object:  Table [exam].[Exam]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [exam].[Exam](
	[exam_id] [int] IDENTITY(1,1) NOT NULL,
	[no_mcq_ques] [int] NOT NULL,
	[no_text_ques] [int] NOT NULL,
	[no_tf_ques] [int] NOT NULL,
	[degree_mcq_ques] [int] NOT NULL,
	[degree_text_ques] [int] NOT NULL,
	[degree_tf_ques] [int] NOT NULL,
	[exam_type] [nvarchar](50) NOT NULL,
	[start_time] [datetime] NOT NULL,
	[end_time] [datetime] NOT NULL,
	[total_time] [int] NOT NULL,
	[crs_id] [int] NOT NULL,
	[inst_id] [int] NULL,
	[intake_id] [int] NULL,
	[branch_id] [int] NULL,
	[track_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[exam_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [exam].[exam_questions]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [exam].[exam_questions](
	[exam_question_id] [int] IDENTITY(1,1) NOT NULL,
	[degree] [int] NOT NULL,
	[exam_id] [int] NOT NULL,
	[question_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[exam_question_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [exam].[exam_results]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [exam].[exam_results](
	[result_id] [int] IDENTITY(1,1) NOT NULL,
	[total_degree] [int] NULL,
	[exam_id] [int] NOT NULL,
	[std_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[result_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [exam].[mcq_choices]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [exam].[mcq_choices](
	[choice_id] [int] IDENTITY(1,1) NOT NULL,
	[choice_text] [nvarchar](255) NOT NULL,
	[is_correct] [bit] NOT NULL,
	[question_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[choice_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [exam].[Question]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [exam].[Question](
	[question_id] [int] IDENTITY(1,1) NOT NULL,
	[question_text] [nvarchar](max) NOT NULL,
	[correct_answer] [nvarchar](max) NULL,
	[crs_id] [int] NOT NULL,
	[question_type] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[question_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [exam].[question_types]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [exam].[question_types](
	[type_id] [int] IDENTITY(1,1) NOT NULL,
	[type_name] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[type_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [student].[student_answers]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [student].[student_answers](
	[answer_id] [int] IDENTITY(1,1) NOT NULL,
	[text_answer] [nvarchar](max) NULL,
	[is_correct] [bit] NULL,
	[exam_id] [int] NOT NULL,
	[std_id] [int] NOT NULL,
	[question_id] [int] NOT NULL,
	[mcq_answer] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[answer_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [training].[Branch]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [training].[Branch](
	[branch_id] [int] IDENTITY(1,1) NOT NULL,
	[branch_name] [nvarchar](100) NOT NULL,
	[location] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[branch_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [training].[branch_track]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [training].[branch_track](
	[track_id] [int] NOT NULL,
	[branch_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[track_id] ASC,
	[branch_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [training].[Course]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [training].[Course](
	[crs_id] [int] IDENTITY(1,1) NOT NULL,
	[crs_name] [nvarchar](100) NOT NULL,
	[description] [nvarchar](255) NULL,
	[max_degree] [int] NOT NULL,
	[min_degree] [int] NOT NULL,
	[inst_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[crs_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [training].[Instructor]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [training].[Instructor](
	[inst_id] [int] IDENTITY(1,1) NOT NULL,
	[inst_name] [nvarchar](100) NOT NULL,
	[email] [nvarchar](100) NOT NULL,
	[phone] [nvarchar](11) NULL,
	[branch_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[inst_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [training].[Intake]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [training].[Intake](
	[intake_id] [int] IDENTITY(1,1) NOT NULL,
	[date] [date] NOT NULL,
	[track_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[intake_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [training].[Student]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [training].[Student](
	[std_id] [int] IDENTITY(1,1) NOT NULL,
	[fname] [nvarchar](50) NOT NULL,
	[lname] [nvarchar](50) NOT NULL,
	[email] [nvarchar](100) NOT NULL,
	[phone] [nvarchar](20) NULL,
	[age] [int] NOT NULL,
	[address] [nvarchar](255) NULL,
	[intake_id] [int] NULL,
	[branch_id] [int] NULL,
	[track_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[std_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [training].[student_course]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [training].[student_course](
	[std_id] [int] NOT NULL,
	[crs_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[std_id] ASC,
	[crs_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [training].[Track]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [training].[Track](
	[track_id] [int] IDENTITY(1,1) NOT NULL,
	[track_name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[track_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [training].[track_course]    Script Date: 12/19/2024 4:30:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [training].[track_course](
	[track_id] [int] NOT NULL,
	[crs_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[track_id] ASC,
	[crs_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [exam].[mcq_choices] ON 

INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (1, N'Structured Query Language', 1, 1)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (2, N'Simple Query Language', 0, 1)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (3, N'Standard Query Library', 0, 1)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (4, N'SQL Query Language', 0, 1)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (5, N'Data Manipulation Language', 1, 2)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (6, N'Data Management Language', 0, 2)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (7, N'Data Model Language', 0, 2)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (8, N'Database Manual Language', 0, 2)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (9, N'Data Definition Language', 1, 3)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (10, N'Data Description Logic', 0, 3)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (11, N'Database Development Language', 0, 3)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (12, N'Data Deployment Logic', 0, 3)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (13, N'Unique Record Identifier', 1, 4)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (14, N'Primary Key Identifier', 0, 4)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (15, N'Unique Column Identifier', 0, 4)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (16, N'None of the above', 0, 4)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (17, N'Combine Multiple Tables', 1, 5)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (18, N'Separate Table Columns', 0, 5)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (19, N'Update Table Rows', 0, 5)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (20, N'Delete Table Rows', 0, 5)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (21, N'Query Optimization Tool', 1, 6)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (22, N'Data Management Tool', 0, 6)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (23, N'Storage Compression Tool', 0, 6)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (24, N'Error Checking Tool', 0, 6)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (25, N'Automatic Event Handler', 1, 7)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (26, N'Manual Event Tracker', 0, 7)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (27, N'Predefined Query Execution', 0, 7)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (28, N'Dynamic Code Executor', 0, 7)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (29, N'Saved SQL Query', 1, 8)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (30, N'Dynamic Data Filter', 0, 8)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (31, N'Aggregate Data Function', 0, 8)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (32, N'Transaction Validator', 0, 8)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (33, N'Transaction Consistency Rules', 1, 9)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (34, N'Data Recovery Rules', 0, 9)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (35, N'System Security Principles', 0, 9)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (36, N'Query Execution Plan', 0, 9)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (37, N'Save Transaction Permanently', 1, 10)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (38, N'Rollback Changes', 0, 10)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (39, N'Backup Data Temporarily', 0, 10)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (40, N'None of the above', 0, 10)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (41, N'Relational Database System', 1, 11)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (42, N'Object-Oriented Database', 0, 11)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (43, N'Hierarchical Database Model', 0, 11)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (44, N'NoSQL Database Type', 0, 11)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (45, N'Missing or Unknown Value', 1, 12)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (46, N'Default Table Value', 0, 12)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (47, N'Primary Key Placeholder', 0, 12)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (48, N'Undefined Query Result', 0, 12)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (49, N'Improve Query Performance', 1, 13)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (50, N'Create User Permissions', 0, 13)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (51, N'Store Data Definitions', 0, 13)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (52, N'Manage Table Backups', 0, 13)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (53, N'Modify Table Structure', 1, 14)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (54, N'Update Table Records', 0, 14)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (55, N'Remove Table Rows', 0, 14)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (56, N'Query Database Metadata', 0, 14)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (57, N'Combine Multiple Queries', 1, 15)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (58, N'Split Query Results', 0, 15)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (59, N'Filter Duplicate Records', 0, 15)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (60, N'Group Data Results', 0, 15)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (61, N'Delete Table Permanently', 1, 16)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (62, N'Update Table Values', 0, 16)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (63, N'Add New Columns', 0, 16)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (64, N'Drop Query Results', 0, 16)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (65, N'Retrieve Table Data', 1, 17)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (66, N'Define Table Schema', 0, 17)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (67, N'Delete Database Records', 0, 17)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (68, N'Manage Database Transactions', 0, 17)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (69, N'Add New Records', 1, 18)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (70, N'Update Existing Records', 0, 18)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (71, N'Delete Table Columns', 0, 18)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (72, N'Filter Query Results', 0, 18)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (73, N'Modify Existing Data', 1, 19)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (74, N'Create New Tables', 0, 19)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (75, N'Delete Table Structures', 0, 19)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (76, N'Query Database Logs', 0, 19)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (77, N'Remove Table Records', 1, 20)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (78, N'Update Table Metadata', 0, 20)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (79, N'Create Table Indices', 0, 20)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (80, N'Rollback Data Changes', 0, 20)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (81, N'Retrieve Unique Values', 1, 21)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (82, N'Filter Query Results', 0, 21)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (83, N'Group Duplicate Records', 0, 21)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (84, N'Calculate Data Sums', 0, 21)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (85, N'Aggregate Data Groups', 1, 22)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (86, N'Filter Data Records', 0, 22)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (87, N'Sort Query Results', 0, 22)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (88, N'Create Database Triggers', 0, 22)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (89, N'Filter Aggregated Data', 1, 23)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (90, N'Update Data Rows', 0, 23)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (91, N'Define Foreign Keys', 0, 23)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (92, N'Delete Data Columns', 0, 23)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (93, N'Filter Query Results', 1, 24)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (94, N'Sort Data Columns', 0, 24)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (95, N'Retrieve Unique Values', 0, 24)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (96, N'Define Primary Keys', 0, 24)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (97, N'Link Between Tables', 1, 25)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (98, N'Index Table Columns', 0, 25)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (99, N'Backup Table Data', 0, 25)
GO
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (100, N'Filter Query Data', 0, 25)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (101, N'Sort Query Results', 1, 26)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (102, N'Define Table Keys', 0, 26)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (103, N'Aggregate Data Rows', 0, 26)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (104, N'Query Database Logs', 0, 26)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (105, N'Count Table Rows', 1, 27)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (106, N'Retrieve Max Values', 0, 27)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (107, N'Filter Duplicate Records', 0, 27)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (108, N'Group Query Results', 0, 27)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (109, N'Calculate Column Average', 1, 28)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (110, N'Sort Data Rows', 0, 28)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (111, N'Retrieve Unique Values', 0, 28)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (112, N'Update Query Data', 0, 28)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (113, N'Retrieve Maximum Value', 1, 29)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (114, N'Count Duplicate Records', 0, 29)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (115, N'Filter Data Results', 0, 29)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (116, N'Define Table Keys', 0, 29)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (117, N'Retrieve Minimum Value', 1, 30)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (118, N'Sort Query Results', 0, 30)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (119, N'Update Table Columns', 0, 30)
INSERT [exam].[mcq_choices] ([choice_id], [choice_text], [is_correct], [question_id]) VALUES (120, N'Delete Data Rows', 0, 30)
SET IDENTITY_INSERT [exam].[mcq_choices] OFF
GO
SET IDENTITY_INSERT [exam].[Question] ON 

INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (1, N'What is SQL?', N'Structured Query Language', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (2, N'Define DML?', N'Data Manipulation Language', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (3, N'Define DDL?', N'Data Definition Language', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (4, N'Purpose of PK?', N'Unique Record Identifier', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (5, N'What is JOIN?', N'Combine Multiple Tables', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (6, N'What is Index?', N'Query Optimization Tool', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (7, N'Define Trigger?', N'Automatic Event Handler', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (8, N'Purpose of View?', N'Saved SQL Query', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (9, N'Define ACID?', N'Transaction Consistency Rules', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (10, N'Purpose of COMMIT?', N'Save Transaction Permanently', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (11, N'What is RDBMS?', N'Relational Database System', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (12, N'Define NULL?', N'Missing or Unknown Value', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (13, N'What is INDEX?', N'Improve Query Performance', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (14, N'Purpose of ALTER?', N'Modify Table Structure', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (15, N'Define UNION?', N'Combine Multiple Queries', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (16, N'What is DROP?', N'Delete Table Permanently', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (17, N'Purpose of SELECT?', N'Retrieve Table Data', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (18, N'What is INSERT?', N'Add New Records', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (19, N'Define UPDATE?', N'Modify Existing Data', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (20, N'What is DELETE?', N'Remove Table Records', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (21, N'Purpose of DISTINCT?', N'Retrieve Unique Values', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (22, N'What is GROUP BY?', N'Aggregate Data Groups', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (23, N'Define HAVING?', N'Filter Aggregated Data', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (24, N'What is WHERE?', N'Filter Query Results', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (25, N'Define FOREIGN KEY?', N'Link Between Tables', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (26, N'Purpose of ORDER BY?', N'Sort Query Results', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (27, N'What is COUNT?', N'Count Table Rows', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (28, N'Purpose of AVG?', N'Calculate Column Average', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (29, N'Define MAX?', N'Retrieve Maximum Value', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (30, N'What is MIN?', N'Retrieve Minimum Value', 1, 1)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (31, N'SQL is a relational database language.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (32, N'Primary keys can have duplicate values.', N'0', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (33, N'Foreign keys link two tables together.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (34, N'Indexes improve query performance.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (35, N'A view is a stored query.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (36, N'Transactions ensure data integrity.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (37, N'Null values represent missing information.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (38, N'DELETE and TRUNCATE are the same.', N'0', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (39, N'JOIN is used to combine data from multiple tables.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (40, N'Constraints enforce rules at the table level.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (41, N'Stored procedures are compiled SQL statements.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (42, N'The WHERE clause is used to filter records.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (43, N'HAVING filters grouped data.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (44, N'COUNT(*) returns the total number of rows.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (45, N'ROLLBACK undoes a transaction.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (46, N'A composite key consists of two or more columns.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (47, N'DDL stands for Data Definition Language.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (48, N'TRIGGERS execute automatically in response to events.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (49, N'UNION combines results of two queries.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (50, N'Indexes slow down INSERT operations.', N'1', 1, 2)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (51, N'What is the purpose of a primary key in a database?', N'Unique identifier for a record', 1, 3)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (52, N'Explain the concept of normalization in databases.', N'Organizing data to reduce redundancy', 1, 3)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (53, N'What is the difference between DELETE and TRUNCATE commands?', N'DELETE removes rows with a WHERE clause; TRUNCATE clears the table', 1, 3)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (54, N'Describe the ACID properties in database transactions.', N'Atomicity, Consistency, Isolation, Durability', 1, 3)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (55, N'What are the advantages of using indexes in a database?', N'Improves query performance by reducing search time', 1, 3)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (56, N'Define a foreign key and explain its purpose.', N'Links two tables; ensures referential integrity', 1, 3)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (57, N'What are the differences between clustered and non-clustered indexes?', N'Clustered: sorts data physically; Non-clustered: points to data', 1, 3)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (58, N'Explain the purpose of a stored procedure in SQL.', N'Reusable SQL code to simplify complex operations', 1, 3)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (59, N'What is the difference between INNER JOIN and LEFT JOIN?', N'INNER JOIN: common rows; LEFT JOIN: all from left table', 1, 3)
INSERT [exam].[Question] ([question_id], [question_text], [correct_answer], [crs_id], [question_type]) VALUES (60, N'Describe the process of creating a database backup in SQL Server.', N'Use BACKUP DATABASE command or GUI tools', 1, 3)
SET IDENTITY_INSERT [exam].[Question] OFF
GO
SET IDENTITY_INSERT [exam].[question_types] ON 

INSERT [exam].[question_types] ([type_id], [type_name]) VALUES (1, N'MCQ')
INSERT [exam].[question_types] ([type_id], [type_name]) VALUES (2, N'True/False')
INSERT [exam].[question_types] ([type_id], [type_name]) VALUES (3, N'Text')
SET IDENTITY_INSERT [exam].[question_types] OFF
GO
SET IDENTITY_INSERT [training].[Branch] ON 

INSERT [training].[Branch] ([branch_id], [branch_name], [location]) VALUES (1, N'Main Branch', N'Cairo')
INSERT [training].[Branch] ([branch_id], [branch_name], [location]) VALUES (2, N'Secondary Branch', N'Alexandria')
SET IDENTITY_INSERT [training].[Branch] OFF
GO
INSERT [training].[branch_track] ([track_id], [branch_id]) VALUES (1, 1)
INSERT [training].[branch_track] ([track_id], [branch_id]) VALUES (2, 1)
INSERT [training].[branch_track] ([track_id], [branch_id]) VALUES (3, 2)
GO
SET IDENTITY_INSERT [training].[Course] ON 

INSERT [training].[Course] ([crs_id], [crs_name], [description], [max_degree], [min_degree], [inst_id]) VALUES (1, N'SQL Database', N'Learn basic programming concepts.', 100, 50, 1)
INSERT [training].[Course] ([crs_id], [crs_name], [description], [max_degree], [min_degree], [inst_id]) VALUES (2, N'Machine Learning Basics', N'Introduction to machine learning concepts.', 100, 50, 2)
INSERT [training].[Course] ([crs_id], [crs_name], [description], [max_degree], [min_degree], [inst_id]) VALUES (3, N'Network Security', N'Learn how to secure networks.', 100, 50, 3)
SET IDENTITY_INSERT [training].[Course] OFF
GO
SET IDENTITY_INSERT [training].[Instructor] ON 

INSERT [training].[Instructor] ([inst_id], [inst_name], [email], [phone], [branch_id]) VALUES (1, N'John Doe', N'john.doe@example.com', N'1234567890', 1)
INSERT [training].[Instructor] ([inst_id], [inst_name], [email], [phone], [branch_id]) VALUES (2, N'Alice Johnson', N'alice.johnson@example.com', N'0987654321', 1)
INSERT [training].[Instructor] ([inst_id], [inst_name], [email], [phone], [branch_id]) VALUES (3, N'Bob Smith', N'bob.smith@example.com', N'1122334455', 2)
SET IDENTITY_INSERT [training].[Instructor] OFF
GO
SET IDENTITY_INSERT [training].[Intake] ON 

INSERT [training].[Intake] ([intake_id], [date], [track_id]) VALUES (1, CAST(N'2024-01-01' AS Date), 1)
INSERT [training].[Intake] ([intake_id], [date], [track_id]) VALUES (2, CAST(N'2024-01-01' AS Date), 2)
INSERT [training].[Intake] ([intake_id], [date], [track_id]) VALUES (3, CAST(N'2024-01-01' AS Date), 3)
SET IDENTITY_INSERT [training].[Intake] OFF
GO
SET IDENTITY_INSERT [training].[Student] ON 

INSERT [training].[Student] ([std_id], [fname], [lname], [email], [phone], [age], [address], [intake_id], [branch_id], [track_id]) VALUES (1, N'John', N'Doe', N'john.doe@example.com', N'1234567890', 22, N'123 Main St', 1, 1, 1)
INSERT [training].[Student] ([std_id], [fname], [lname], [email], [phone], [age], [address], [intake_id], [branch_id], [track_id]) VALUES (2, N'Jane', N'Smith', N'jane.smith@example.com', N'0987654321', 23, N'456 Elm St', 1, 1, 1)
INSERT [training].[Student] ([std_id], [fname], [lname], [email], [phone], [age], [address], [intake_id], [branch_id], [track_id]) VALUES (3, N'Alice', N'Johnson', N'alice.johnson@example.com', N'1122334455', 24, N'789 Oak St', 2, 1, 2)
INSERT [training].[Student] ([std_id], [fname], [lname], [email], [phone], [age], [address], [intake_id], [branch_id], [track_id]) VALUES (4, N'Bob', N'Brown', N'bob.brown@example.com', N'5544332211', 25, N'321 Pine St', 2, 1, 2)
INSERT [training].[Student] ([std_id], [fname], [lname], [email], [phone], [age], [address], [intake_id], [branch_id], [track_id]) VALUES (5, N'Charlie', N'Davis', N'charlie.davis@example.com', N'6677889900', 26, N'654 Maple St', 3, 2, 3)
INSERT [training].[Student] ([std_id], [fname], [lname], [email], [phone], [age], [address], [intake_id], [branch_id], [track_id]) VALUES (6, N'Diana', N'Evans', N'diana.evans@example.com', N'7788990011', 27, N'987 Birch St', 3, 2, 3)
SET IDENTITY_INSERT [training].[Student] OFF
GO
INSERT [training].[student_course] ([std_id], [crs_id]) VALUES (1, 1)
INSERT [training].[student_course] ([std_id], [crs_id]) VALUES (2, 1)
INSERT [training].[student_course] ([std_id], [crs_id]) VALUES (3, 2)
INSERT [training].[student_course] ([std_id], [crs_id]) VALUES (4, 2)
INSERT [training].[student_course] ([std_id], [crs_id]) VALUES (5, 3)
INSERT [training].[student_course] ([std_id], [crs_id]) VALUES (6, 3)
GO
SET IDENTITY_INSERT [training].[Track] ON 

INSERT [training].[Track] ([track_id], [track_name]) VALUES (1, N'Software Development')
INSERT [training].[Track] ([track_id], [track_name]) VALUES (2, N'Data Science')
INSERT [training].[Track] ([track_id], [track_name]) VALUES (3, N'Cybersecurity')
SET IDENTITY_INSERT [training].[Track] OFF
GO
INSERT [training].[track_course] ([track_id], [crs_id]) VALUES (1, 1)
INSERT [training].[track_course] ([track_id], [crs_id]) VALUES (2, 2)
INSERT [training].[track_course] ([track_id], [crs_id]) VALUES (3, 3)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Instruct__AB6E61646C9B490A]    Script Date: 12/19/2024 4:30:53 PM ******/
ALTER TABLE [training].[Instructor] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Student__AB6E6164FACAD27D]    Script Date: 12/19/2024 4:30:53 PM ******/
ALTER TABLE [training].[Student] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [exam].[Exam]  WITH CHECK ADD FOREIGN KEY([branch_id])
REFERENCES [training].[Branch] ([branch_id])
GO
ALTER TABLE [exam].[Exam]  WITH CHECK ADD FOREIGN KEY([crs_id])
REFERENCES [training].[Course] ([crs_id])
GO
ALTER TABLE [exam].[Exam]  WITH CHECK ADD FOREIGN KEY([inst_id])
REFERENCES [training].[Instructor] ([inst_id])
GO
ALTER TABLE [exam].[Exam]  WITH CHECK ADD FOREIGN KEY([intake_id])
REFERENCES [training].[Intake] ([intake_id])
GO
ALTER TABLE [exam].[Exam]  WITH CHECK ADD FOREIGN KEY([track_id])
REFERENCES [training].[Track] ([track_id])
GO
ALTER TABLE [exam].[exam_questions]  WITH CHECK ADD FOREIGN KEY([exam_id])
REFERENCES [exam].[Exam] ([exam_id])
ON DELETE CASCADE
GO
ALTER TABLE [exam].[exam_questions]  WITH CHECK ADD FOREIGN KEY([question_id])
REFERENCES [exam].[Question] ([question_id])
ON DELETE CASCADE
GO
ALTER TABLE [exam].[exam_results]  WITH CHECK ADD FOREIGN KEY([exam_id])
REFERENCES [exam].[Exam] ([exam_id])
ON DELETE CASCADE
GO
ALTER TABLE [exam].[exam_results]  WITH CHECK ADD FOREIGN KEY([std_id])
REFERENCES [training].[Student] ([std_id])
ON DELETE CASCADE
GO
ALTER TABLE [exam].[mcq_choices]  WITH CHECK ADD FOREIGN KEY([question_id])
REFERENCES [exam].[Question] ([question_id])
ON DELETE CASCADE
GO
ALTER TABLE [exam].[Question]  WITH CHECK ADD FOREIGN KEY([crs_id])
REFERENCES [training].[Course] ([crs_id])
ON DELETE CASCADE
GO
ALTER TABLE [exam].[Question]  WITH CHECK ADD FOREIGN KEY([question_type])
REFERENCES [exam].[question_types] ([type_id])
ON DELETE CASCADE
GO
ALTER TABLE [student].[student_answers]  WITH CHECK ADD FOREIGN KEY([exam_id])
REFERENCES [exam].[Exam] ([exam_id])
ON DELETE CASCADE
GO
ALTER TABLE [student].[student_answers]  WITH CHECK ADD FOREIGN KEY([mcq_answer])
REFERENCES [exam].[mcq_choices] ([choice_id])
GO
ALTER TABLE [student].[student_answers]  WITH CHECK ADD FOREIGN KEY([question_id])
REFERENCES [exam].[Question] ([question_id])
ON DELETE CASCADE
GO
ALTER TABLE [student].[student_answers]  WITH CHECK ADD FOREIGN KEY([std_id])
REFERENCES [training].[Student] ([std_id])
ON DELETE CASCADE
GO
ALTER TABLE [training].[branch_track]  WITH CHECK ADD FOREIGN KEY([branch_id])
REFERENCES [training].[Branch] ([branch_id])
GO
ALTER TABLE [training].[branch_track]  WITH CHECK ADD FOREIGN KEY([track_id])
REFERENCES [training].[Track] ([track_id])
GO
ALTER TABLE [training].[Course]  WITH CHECK ADD FOREIGN KEY([inst_id])
REFERENCES [training].[Instructor] ([inst_id])
GO
ALTER TABLE [training].[Instructor]  WITH CHECK ADD FOREIGN KEY([branch_id])
REFERENCES [training].[Branch] ([branch_id])
GO
ALTER TABLE [training].[Intake]  WITH CHECK ADD FOREIGN KEY([track_id])
REFERENCES [training].[Track] ([track_id])
GO
ALTER TABLE [training].[Student]  WITH CHECK ADD FOREIGN KEY([branch_id])
REFERENCES [training].[Branch] ([branch_id])
GO
ALTER TABLE [training].[Student]  WITH CHECK ADD FOREIGN KEY([intake_id])
REFERENCES [training].[Intake] ([intake_id])
GO
ALTER TABLE [training].[Student]  WITH CHECK ADD FOREIGN KEY([track_id])
REFERENCES [training].[Track] ([track_id])
GO
ALTER TABLE [training].[student_course]  WITH CHECK ADD FOREIGN KEY([crs_id])
REFERENCES [training].[Course] ([crs_id])
GO
ALTER TABLE [training].[student_course]  WITH CHECK ADD FOREIGN KEY([std_id])
REFERENCES [training].[Student] ([std_id])
GO
ALTER TABLE [training].[track_course]  WITH CHECK ADD FOREIGN KEY([crs_id])
REFERENCES [training].[Course] ([crs_id])
GO
ALTER TABLE [training].[track_course]  WITH CHECK ADD FOREIGN KEY([track_id])
REFERENCES [training].[Track] ([track_id])
GO
/****** Object:  StoredProcedure [dbo].[SP_AddBranch]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[SP_AddBranch]
    @branch_name nvarchar(100),
    @location nvarchar(255)
as
begin
    insert into training.Branch (branch_name, location)
    values (@branch_name, @location);
end;
GO
/****** Object:  StoredProcedure [dbo].[SP_AddCourse]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[SP_AddCourse]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_AddCourseToTrack]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AddCourseToTrack]
    @crs_id int,
	@track_id int
as
begin
    insert into training.track_course(crs_id, track_id)
    values (@crs_id, @track_id);
end;
GO
/****** Object:  StoredProcedure [dbo].[SP_AddExamQuestions]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AddExamQuestions]
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

GO
/****** Object:  StoredProcedure [dbo].[SP_AddInstructor]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AddInstructor]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_AddIntake]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[SP_AddIntake]
    @date date,
	@track_id int
as
begin
    insert into training.Intake (date, track_id)
    values (@date, @track_id);
end;
GO
/****** Object:  StoredProcedure [dbo].[SP_AddMcqChoice]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[SP_AddMcqChoice] 
	@choice_text nvarchar(max), 
	@is_correct bit, 
	@question_id int
as 
begin
	insert into exam.mcq_choices (choice_text, is_correct, question_id)
	values (@choice_text, @is_correct, @question_id);
end;
GO
/****** Object:  StoredProcedure [dbo].[SP_AddQuestion]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[SP_AddQuestion]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_AddStudent]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[SP_AddStudent]
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

GO
/****** Object:  StoredProcedure [dbo].[SP_AddTrack]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[SP_AddTrack]
    @track_name nvarchar(100)
as
begin
    insert into training.Track (track_name)
    values (@track_name);
end;
GO
/****** Object:  StoredProcedure [dbo].[SP_AddTrackToBranch]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[SP_AddTrackToBranch]
    @track_id int,
    @branch_id int
as
begin
    insert into training.branch_track(track_id, branch_id)
    values (@track_id, @branch_id);
end;

GO
/****** Object:  StoredProcedure [dbo].[SP_AssignInstructorToCourse]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[SP_AssignInstructorToCourse]
    @course_id int,
    @instructor_id int
as
begin
    update training.Course
    set inst_id = @instructor_id
    where crs_id = @course_id;
end;
GO
/****** Object:  StoredProcedure [dbo].[SP_AssignStudentsToExam]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AssignStudentsToExam]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_CalculateExamResults]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_CalculateExamResults]
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

GO
/****** Object:  StoredProcedure [dbo].[SP_CorrectAnswers]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create    procedure [dbo].[SP_CorrectAnswers]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_CreateRandomExam]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[SP_CreateRandomExam]
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



GO
/****** Object:  StoredProcedure [dbo].[SP_GetExamQuestions]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[SP_GetExamQuestions]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_GetExamResults]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_GetExamResults]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_GetQuestionsByCourse]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_GetQuestionsByCourse]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_ShowStudentInfo]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_ShowStudentInfo]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_SolveQuestion]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[SP_SolveQuestion]
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

GO
/****** Object:  StoredProcedure [dbo].[SP_ViewExams]    Script Date: 12/19/2024 4:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_ViewExams]
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
end
GO
ALTER DATABASE [exam_system] SET  READ_WRITE 
GO
