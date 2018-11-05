use dw_db;
create table tmp_deptid_tree
(DeptID integer
 , dept_tree varchar(50)
 )
 ;
SELECT 
*

 FROM 
tmp_rtx;

delimiter //
drop PROCEDURE IF EXISTS FindTreeNodes//
CREATE PROCEDURE FindTreeNodes (IN rootid INT)
BEGIN
 DECLARE Level int ;
 drop TABLE IF EXISTS tmpLst;
 CREATE TABLE tmpLst (
 id int,
 nLevel int,
 sCort varchar(8000)
 );
 
 Set Level=0 ;
 
 INSERT into tmpLst SELECT DeptID,Level,DeptName FROM tmp_rtx WHERE PDeptID=rootid;
 
 WHILE ROW_COUNT()>0 DO
 SET Level=Level+1 ;
 INSERT into tmpLst
  SELECT A.DeptID,Level,concat(B.sCort,A.DeptName) FROM tmp_rtx A inner join tmpLst B on a.PdeptID = b.id and B.nLevel=Level-1 ;
 END WHILE;
END;

delimiter ;

call FindTreeNodes(0)
;


SELECT concat(SPACE(B.nLevel*3),'+--',A.DeptName),b.sCort
FROM tmp_rtx A inner join tmpLst B on A.DeptID=B.id
ORDER BY B.sCort;