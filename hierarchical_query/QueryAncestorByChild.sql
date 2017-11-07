
/* 1. create db */
CREATE DATABASE IF NOT EXISTS test DEFAULT CHARACTER SET utf8;

/* 2. */
USE test;

/* 3. create table */
CREATE TABLE IF NOT EXISTS test.treenodes
(  
    id INT PRIMARY KEY,  
    nodename VARCHAR(20),  
    pid INT  
);  

/* 4. insert... */
INSERT IGNORE INTO test.treenodes VALUES 
(1,'A',0),(2,'B',1),(3,'C',1),(4,'D',2),(5,'E',2),(6,'F',2),  
(7,'G',3),(8,'H',6),(9,'I',0),(10,'J',8),(11,'K',8),(12,'L',8),  
(13,'M',9),(14,'N',12),(15,'O',12),(16,'P',15),(17,'Q',15); 


/* 5. create function */
DROP FUNCTION IF EXISTS `getAncestor`;
delimiter // 
CREATE FUNCTION `getAncestor`(id INT)
RETURNS INT
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE cid BIGINT;
    DECLARE pid BIGINT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;             

    set cid = id;

    REPEAT
        SELECT p.id INTO pid FROM test.treenodes c INNER JOIN test.treenodes p ON p.id = c.pid WHERE c.id = cid;
        IF NOT done THEN
            SET cid = pid;
        ELSE 
            SELECT c.pid INTO pid FROM test.treenodes c WHERE c.id = cid;
        END IF;
    UNTIL done END REPEAT;
    
    RETURN pid; 
END
//

/* 6. query */
SELECT id, nodename, pid, getAncestor(id) FROM test.treenodes;

-- SELECT id, nodename, pid, getAncestor(id) FROM test.treenodes where id = 1;


