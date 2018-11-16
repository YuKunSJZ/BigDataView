alter table m_fact_stock_finance_new drop primary key;
alter table m_fact_stock_finance_new add primary key (sysid,contract_id,stock_start_date);

-- 补录导致数据不一致
insert into m_fact_stock_finance
SELECT `a`.`sysid`,
    `a`.`contract_id`,
    '2018-09-30',
    `a`.`entertime`,
    `a`.`contract_amount`,
    `a`.`main_status`,
    `a`.`agent_key`,
    `a`.`agent_id`,
    `a`.`agent_name`,
    `a`.`dept_key`,
    `a`.`dept_id`,
    `a`.`dept_name`,
    `a`.`customer_key`,
    `a`.`customer_id`,
    `a`.`idcode`,
    `a`.`customer_name`,
    `a`.`product_key`,
    `a`.`product_id`
from (SELECT * from m_fact_stock_finance where sysid = 'ryan_rongzi' and date(time) = '2018-10-21' ) a
left join (SELECT * from m_fact_stock_finance where sysid = 'ryan_rongzi' and date(time) = '2018-09-30') b
on a.contract_id = b.contract_id
where b.contract_id is null and a.entertime<='2018-09-30'
;

-- 增加字段
alter table ods_db.ods_rongzi_crm_hetong add column `edit_flag` int(1) DEFAULT '1' COMMENT '编辑标志1可编辑0不可编辑' after has_chezi_flag
;

-- 备份和加速存量表20181109

drop table test_db.m_fact_stock_finance20181108
;
create table test_db.m_fact_stock_finance20181108 as
select
*
from  dw_db.m_fact_stock_finance 
;

create table test_db.m_fact_stock_finance_end_month
as
SELECT
*
from dw_db.m_fact_stock_finance
where date(time)>= (curdate() - INTERVAL (dayofyear(now()) - 1) DAY)
and date(time)<= '2018-11-01'
and date(time) in (
last_day(date_add(now(),interval -1 month))
,last_day(date_add(now(),interval -2 month))
,last_day(date_add(now(),interval -3 month))
,last_day(date_add(now(),interval -4 month))
,last_day(date_add(now(),interval -5 month))
,last_day(date_add(now(),interval -6 month))
,last_day(date_add(now(),interval -7 month))
,last_day(date_add(now(),interval -8 month))
,last_day(date_add(now(),interval -9 month))
,last_day(date_add(now(),interval -10 month))
,last_day(date_add(now(),interval -11 month))
,last_day(date_add(now(),interval -12 month))
)
;

insert into test_db.m_fact_stock_finance_end_month
select
*
from dw_db.m_fact_stock_finance 
where date(time)='2018-11-08'
;

select distinct date(time)
from  test_db.m_fact_stock_finance_end_month
;
truncate table dw_db.m_fact_stock_finance 
;

insert into dw_db.m_fact_stock_finance 
select
*
from test_db.m_fact_stock_finance_end_month
;
select distinct date(time)
from  dw_db.m_fact_stock_finance 
;

alter table dw_db.m_fact_stock_finance add index ix_1(time,sysid)
;


ALTER TABLE `ods_db`.`ra_fxinfo` 
ADD COLUMN `static_date` DATETIME NOT NULL DEFAULT current_timestamp FIRST,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`id`, `static_date`);


alter table ra_fxinfo add index IX_static_date(static_date)
;

ALTER TABLE `dm_db`.`dm_stock_in_agent_product` 
ADD COLUMN `stock_type` VARCHAR(45) NULL DEFAULT NULL AFTER `stock_date`;


ALTER TABLE `ods_db`.`ra_ht` 
ADD COLUMN `stock_date` DATETIME NULL DEFAULT NULL FIRST;

ALTER TABLE `ods_db`.`ra_ht` 
CHANGE COLUMN `stock_date` `stock_date` DATETIME NOT NULL DEFAULT current_timestamp ,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`stock_date`, `id`);


alter table dm_stock_in_agent_product add index IX_1(sysid,stock_date,stock_type);
alter table dm_stock_in_agent_product add index IX_agent_id(agent_id);
alter table dm_stock_in_agent_product add index IX_product_id(product_id);