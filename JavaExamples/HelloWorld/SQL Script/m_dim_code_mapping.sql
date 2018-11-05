SELECT * FROM dw_db.m_dim_stype;

drop table m_dim_code_mapping
;
CREATE TABLE `m_dim_code_mapping` (
  `code_map_id` integer NOT NULL auto_increment comment '码值转换id',
  `source_code` varchar(50) DEFAULT NULL comment '源码值',
  `dw_code` varchar(50) DEFAULT NULL comment '数据仓库对应值',
  `code_type` varchar(32) DEFAULT NULL comment '码值类型',
  `from_sysid` varchar(32) DEFAULT NULL comment '码值来源系统id',
  code_order integer comment '码值排序',
  add_date date comment '码值添加日期',
  PRIMARY KEY (`code_map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据仓库码表'
;

alter table m_dim_code_mapping change column from_sysid data_source varchar(128) comment '数据来源'
;


insert into m_dim_code_mapping
(
source_code
,dw_code
,code_type
,data_source
,code_order
,add_date
)
 values 
 ('0','未提交','main_status','dw_db.m_fact_contract_finance.main_status',1,curdate())
,('1','一审审批中','main_status','dw_db.m_fact_contract_finance.main_status',1,curdate())
,('2','一审驳回','main_status','dw_db.m_fact_contract_finance.main_status',1,curdate())
,('3','二审审批中','main_status','dw_db.m_fact_contract_finance.main_status',1,curdate())
,('4','二审驳回','main_status','dw_db.m_fact_contract_finance.main_status',1,curdate())
,('5','归档','main_status','dw_db.m_fact_contract_finance.main_status',1,curdate())
,('7','正常撤资','main_status','dw_db.m_fact_contract_finance.main_status',1,curdate())
,('8','转投撤资','main_status','dw_db.m_fact_contract_finance.main_status',1,curdate())
,('9','违约撤资','main_status','dw_db.m_fact_contract_finance.main_status',1,curdate())
,('10','活期撤资','main_status','dw_db.m_fact_contract_finance.main_status',1,curdate())
;

update m_dim_code_mapping a
set a.data_source = 'm_dim_contract_allstatus'
where a.data_source in( 'dw_db.m_fact_contract_finance.main_status')
;

update m_dim_code_mapping a
set a.data_source = 'm_dim_contract_ejtype'
where a.data_source in( 'Kettle_财富基金合同.ktr','ods_db.ra_ht.ht_type')
;
select * from m_dim_code_mapping limit 100;

ALTER TABLE `dw_db`.`m_dim_contract_allstatus` 
RENAME TO  `dw_db`.`m_dim_contract_allstatus_20180813bak` 
;

ALTER TABLE `dw_db`.`m_dim_contract_ejtype` 
RENAME TO  `dw_db`.`m_dim_contract_ejtype_20180813bak` ;

ALTER TABLE `dw_db`.`m_dim_contract_type` 
RENAME TO  `dw_db`.`m_dim_contract_type_20180813bak` ;

insert into m_dim_code_mapping
(
source_code
,dw_code
,code_type
,data_source
,code_order
,add_date
)
 values 
 ('1','新投','ht_type','ods_db.ra_ht.ht_type',1,curdate())
,('2','转投','ht_type','ods_db.ra_ht.ht_type',1,curdate())
,('4','转投加钱','ht_type','ods_db.ra_ht.ht_type',1,curdate())
,('3','基金合同','ht_type','Kettle_财富基金合同.ktr',1,curdate())
;

insert into m_dim_code_mapping
(
source_code
,dw_code
,code_type
,data_source
,code_order
,add_date
)

select
code as source_code
,name as dw_code
,'contract_type' as code_type
,'m_dim_contract_type' as data_source
,1
,curdate()
from  m_dim_contract_type
;