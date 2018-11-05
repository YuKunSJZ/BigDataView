use test_db;
create table Tables 
(
TableName varchar(64),
TableAlias varchar(64),
TableSchema varchar(32),
primary key (TableName)
) ;

insert into tables values 
('dm_new_customer','dm_new_customer','test_db')
;

drop table if exists TableFields
;
create table TableFields
(
TableName varchar(64),
FieldName varchar(64),
FieldAlias varchar(64),
FieldSequence integer,
DataType varchar(32),
DataLength integer,
DefaultValue varchar(64),
primary key (TableName,FieldName)
)
;

insert into TableFields
select Table_name,COLUMN_NAME,COLUMN_NAME,ordinal_position,DATA_TYPE,64,null from information_schema.COLUMNS where table_name = 'dm_new_customer' and table_schema = 'test_db'
;


insert into `Tables`
values('Tables','Tables','test_db')
;

insert into `Tables`
values('TableFields','TableFields','test_db')
;

insert into `TableFields`
select Table_name,COLUMN_NAME,COLUMN_NAME,ordinal_position,DATA_TYPE,64,null from information_schema.COLUMNS where table_name = 'TableFields' and table_schema = 'test_db'
;

insert into `TableFields`
select Table_name,COLUMN_NAME,COLUMN_NAME,ordinal_position,DATA_TYPE,64,null from information_schema.COLUMNS where table_name = 'Tables' and table_schema = 'test_db'
;

CREATE TABLE links (
  LinkID int(11) NOT NULL,
  LinkName varchar(45) DEFAULT NULL,
  LinkURL varchar(1024) DEFAULT NULL,
  PRIMARY KEY (LinkID)
);

insert into `Tables`
values ('Links2','Links2','test_db')
;


insert into `TableFields`
select Table_name,COLUMN_NAME,COLUMN_NAME,ordinal_position,DATA_TYPE,64,null from information_schema.COLUMNS where table_name = 'links' and table_schema = 'test_db'
;

ALTER TABLE `tables` 
ADD COLUMN `TableKey` VARCHAR(512) NULL AFTER `TableSchema`;

insert into `TableFields`
select Table_name,COLUMN_NAME,COLUMN_NAME,ordinal_position,DATA_TYPE,64,null from information_schema.COLUMNS where table_name = 'Tables' and table_schema = 'test_db' and column_name='TableKey'
;

set sql_safe_updates=0;
update  tableFields 
set FieldAlias = '链接号'
where FieldName = 'LinkID'
;

update  tableFields 
set FieldAlias = '链接名'
where FieldName = 'LinkName'
;

update  tableFields 
set FieldAlias = '链接URL'
where FieldName = 'LinkURL'
;


