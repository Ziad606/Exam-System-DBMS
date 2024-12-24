
-- graniting access for roles

-- admin
grant control on database::exam_system to admin;

-- training manager
grant select, insert, update, delete on schema::training to training_manager;
grant select on schema::exam to training_manager;
grant select on schema::student to training_manager;

-- instructor
grant select, insert, update, delete on schema::exam to instructor;
grant select on schema::training to instructor;
grant select on schema::student to instructor;

-- student
grant insert on schema::student to student;
grant select on schema::exam to student






