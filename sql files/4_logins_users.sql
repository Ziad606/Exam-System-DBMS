-- create the logins on the master db

create login tm_1 with password = 'tm1@123456';

create login inst_1 with password = 'user1@123456';

create login std_1 with password = 'user2@123456';


-- create users for logins on the exam_system db

create user tm_1 for login tm_1;

create user inst_1 for login inst_1;

create user std_1 for login std_1;


-- assign roles for the users

alter role training_manager add member tm_1;

alter role instructor add member inst_1;

alter role student add member std_1;


-- a query to show the users and there roles

select dp.name as database_role,
       dp2.name as database_user
from sys.database_role_members drm
join sys.database_principals dp
    on dp.principal_id = drm.role_principal_id
join sys.database_principals dp2
    on dp2.principal_id = drm.member_principal_id
where dp2.type in ('S', 'E', 'X')
order by dp.name, dp2.name;