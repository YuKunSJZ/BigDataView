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


CREATE TABLE `customers` (
  `CustomersID` INT NOT NULL AUTO_INCREMENT COMMENT '客户ID',
  `CustomerName` VARCHAR(45) NOT NULL COMMENT '客户姓名',
  `Age` INT NOT NULL COMMENT '年龄',
  `Sex` VARCHAR(2) NOT NULL COMMENT '性别',
  `PoneNumber` INT NOT NULL COMMENT '手机号',
  `IDCode` VARCHAR(45) NOT NULL COMMENT '身份证号',
  `InvestAmount` INT NOT NULL DEFAULT 0 COMMENT '已投资金额(元)',
  `PotentionInvestAmount` INT NULL DEFAULT 0 COMMENT '潜在投资额（元）',
  `TimeUpdated` DATETIME NULL DEFAULT current_timestamp COMMENT '更新时间',
  `TimeCreated` DATETIME NULL DEFAULT current_timestamp COMMENT '创建时间',
  PRIMARY KEY (`CustomersID`),
  UNIQUE INDEX `IDCode_UNIQUE` (`IDCode` ASC))
COMMENT = '签约客户表';

CREATE TABLE `customerhistoryinvest` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `CustomerID` INT NOT NULL COMMENT '客户ID',
  `InvestAmount` INT NULL DEFAULT 0 COMMENT '投资金额',
  `StartDate` DATETIME NOT NULL DEFAULT current_timestamp COMMENT '开始日期',
  `EndDate` DATETIME NULL DEFAULT current_timestamp COMMENT '结束日期',
  `Interest` INT NULL DEFAULT 0 COMMENT '利息',
  `ContractID` VARCHAR(50) NULL COMMENT '合同号',
  `InvestFrom` VARCHAR(50) NULL COMMENT '客户投资公司',
  `TimeUpdated` DATETIME NULL DEFAULT current_timestamp COMMENT '更新时间',
  `TimeCreated` DATETIME NULL DEFAULT current_timestamp COMMENT '创建时间',
  PRIMARY KEY (`ID`),
  INDEX `CustomerHistoryInvest_Customers_idx` (`CustomerID` ASC),
  CONSTRAINT `CustomerHistoryInvest_Customers`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `big_data_view`.`customers` (`CustomersID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = '客户投资记录';

