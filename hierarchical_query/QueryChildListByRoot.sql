
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
(1,'a',0),(2,'b',1),(3,'c',1),(4,'d',2),(5,'e',2),(6,'f',3),  
(7,'g',6),(8,'h',0),(9,'i',8),(10,'j',8),(11,'k',8),(12,'l',9),  
(13,'m',9),(14,'n',12),(15,'o',12),(16,'p',15),(17,'q',15); 

/* 5. create function */
drop function if exists test.get_child_list;
delimiter // 
create function test.get_child_list(root int)
returns varchar(512)
begin
    declare cur varchar(512);
    declare res varchar(512);
    
    set res = null;
    set cur = cast(root as char);
    
    while (cur is not null) do
        if res is null then
            set res = '';
        elseif res = '' then
            set res = cur;
        else
            set res = concat(res, ',', cur);
        end if;
        
        -- 形参名与字段名重复容易导致死循环
        select group_concat(id) into cur from test.treenodes where find_in_set(pid, cur) > 0;
    end while;
    
    return res; 
end
//

/* 6. query */
select test.get_child_list(1);
-- select * from test.treenodes where find_in_set(id, test.getchildlist(1));

