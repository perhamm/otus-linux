CREATE DATABASE test;
CREATE USER 'test'@'%' IDENTIFIED BY 'test';
GRANT ALL PRIVILEGES ON test.* TO 'test'@'%';
use test;
create table test (id int primary key, name varchar(100));
insert into test values(1, 'test');
insert into test values(2, 'test');
insert into test values(3, 'test');