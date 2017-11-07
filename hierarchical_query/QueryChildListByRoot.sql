
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
(1,'A',0),(2,'B',1),(3,'C',1),(4,'D',2),(5,'E',2),(6,'F',3),  
(7,'G',6),(8,'H',0),(9,'I',8),(10,'J',8),(11,'K',8),(12,'L',9),  
(13,'M',9),(14,'N',12),(15,'O',12),(16,'P',15),(17,'Q',15); 


/* 5. create function */
DROP FUNCTION IF EXISTS `getChildList`;
delimiter // 
CREATE FUNCTION `getChildList`(id INT)
RETURNS VARCHAR(512)
BEGIN
    DECLARE cur VARCHAR(512);
    DECLARE res VARCHAR(512);
    
    SET res = '';
    SET cur = CAST(id as CHAR);
    
    WHILE cur IS NOT NULL DO
        -- SET parent = CONCAT(parent, ',', child);
        -- SET res = IF(res != '', CONCAT(res, ',', cur), cur);
        SELECT GROUP_CONCAT(id) INTO cur FROM test.treenodes WHERE FIND_IN_SET(pid, cur) > 0;
    END WHILE;
    
    RETURN res; 
END
//

/* 6. query */
-- SELECT getChildList(2);

