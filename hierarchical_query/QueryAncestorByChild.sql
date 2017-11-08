
/* 1. create db */
create database if not exists test default character set utf8;

/* 2. */
-- use test;

/* 3. create table */
drop table if exists test.treenodes;
create table test.treenodes
(
    id int primary key,
    nodename varchar(20),
    pid int
);  

/* 4. insert... */
insert ignore into test.treenodes values 
(1,'a',0),(2,'b',1),(3,'c',1),(4,'d',2),(5,'e',2),(6,'f',2),  
(7,'g',3),(8,'h',6),(9,'i',0),(10,'j',8),(11,'k',8),(12,'l',8),  
(13,'m',9),(14,'n',12),(15,'o',12),(16,'p',15),(17,'q',15); 


/* 5. create function */
drop function if exists test.get_ancestor;
delimiter // 
create function test.get_ancestor(id int)
returns int
begin
    declare done int default 0;
    declare cid bigint;
    declare pid bigint;
    declare continue handler for not found set done = 1;             

    set cid = id;

    repeat
        select p.id into pid from test.treenodes c inner join test.treenodes p on p.id = c.pid where c.id = cid;
        if not done then
            set cid = pid;
        else 
            select c.pid into pid from test.treenodes c where c.id = cid;
        end if;
    until done end repeat;
    
    return pid; 
end
//

/* 6. query */
select id, nodename, pid, test.get_ancestor(id) from test.treenodes;

-- select id, nodename, pid, test.get_ancestor(id) from test.treenodes where id = 1;


