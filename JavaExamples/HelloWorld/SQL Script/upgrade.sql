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