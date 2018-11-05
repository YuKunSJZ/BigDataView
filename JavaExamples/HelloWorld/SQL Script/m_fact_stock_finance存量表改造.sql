-- 记录合同状态变化，使用插入更新的方式，避免数据增长过快（kettlelc\所有dw层数据到dw层\m_fact_contract_status大众合同状态表\大众合同状态变化2.ktr）
CREATE TABLE `m_fact_contract_status2` (
  `time` datetime NOT NULL COMMENT '时间戳',
  sysid varchar(20),
  `status_start_time` datetime DEFAULT NULL,
  `status_end_time` datetime DEFAULT NULL,
  `id` varchar(100) NOT NULL COMMENT '合同号',
  `term` int(11) DEFAULT NULL COMMENT '合同期限',
  `type` varchar(20) DEFAULT NULL COMMENT '合同种类',
  `begin_time` datetime DEFAULT NULL COMMENT '合同开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '合同到期时间',
  `amount` decimal(20,3) DEFAULT NULL COMMENT '合同金额',
  `main_status` varchar(20) NOT NULL COMMENT '合同整体状态',
  `penalty` decimal(20,3) DEFAULT NULL COMMENT '违约金额',
  `agent_key` int(11) DEFAULT NULL,
  `agent_id` varchar(100) DEFAULT NULL COMMENT '经办人ID',
  `agent_name` varchar(20) DEFAULT NULL,
  `dept_key` int(11) DEFAULT NULL,
  `dept_id` varchar(100) DEFAULT NULL,
  `dept_name` varchar(100) DEFAULT NULL,
  `customer_key` int(11) DEFAULT NULL,
  `customer_id` varchar(100) DEFAULT NULL COMMENT '客户ID',
  `customer_name` varchar(100) DEFAULT NULL,
  `idtype` varchar(20) DEFAULT NULL COMMENT '证件类型',
  `idcode` varchar(20) DEFAULT NULL COMMENT '证件号',
  `signing_time` datetime DEFAULT NULL COMMENT '签约时间',
  `pay_method` varchar(20) DEFAULT NULL COMMENT '付款方式',
  `pay_time` varchar(100) DEFAULT NULL COMMENT '付款时间',
  `before_id` varchar(1000) DEFAULT NULL COMMENT '原合同号',
  `before_id_amount` decimal(20,3) DEFAULT NULL COMMENT '原合同金额',
  `additional_amount` decimal(20,3) DEFAULT NULL COMMENT '追加金额',
  `additional_method` varchar(20) DEFAULT NULL COMMENT '追加付款方式',
  `additional_time` varchar(100) DEFAULT NULL COMMENT '追加付款时间',
  `receipt_num` varchar(20) DEFAULT NULL COMMENT '收据号',
  `if_inside_people` varchar(5) DEFAULT NULL COMMENT '是否内部人员',
  `if_inside_product` varchar(5) DEFAULT NULL COMMENT '是否内部产品',
  `gather_reason` varchar(100) DEFAULT NULL COMMENT '收款事由',
  `classify` varchar(20) DEFAULT NULL COMMENT '合同类型',
  `check_one_status` varchar(20) DEFAULT NULL COMMENT '一审状态',
  `check_two_status` varchar(20) DEFAULT NULL COMMENT '二审状态',
  `disinvest_reason` varchar(100) DEFAULT NULL COMMENT '撤资原因',
  `belong_company` varchar(100) DEFAULT NULL COMMENT '所属公司',
  `product_key` int(11) DEFAULT NULL,
  `product_id` varchar(100) DEFAULT NULL COMMENT '产品ID',
  `check_final_time` datetime DEFAULT NULL COMMENT '最终审批时间',
  `disinvest_time` datetime DEFAULT NULL COMMENT '撤资时间',
  `if_new_customer` varchar(5) DEFAULT NULL COMMENT '是否新客户',
  `turn_type` varchar(20) DEFAULT NULL COMMENT '转投类型',
  PRIMARY KEY (`id`,`main_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合同类型对照表2'
;

-- 大众财富存量视图
create view v_fact_stock_finance as 
select
a.*
,b.status_start_time
,b.status_end_time
,b.main_status as main_status_final
from (select * from m_fact_contract_finance t1 where t1.sysid = 'ryan_dz') a
inner join (select * from m_fact_contract_status2 t2 where t2.sysid = 'ryan_dz') b on a.id=b.id
where b.main_status in (1,2,3,4,5)  -- and  date(b.status_start_time) <= '2018-08-06' and date(b.status_end_time)>'2018-08-06'
;

-- 集团财务存量视图
create view v_fact_stock_jtcw as 
select
a.*
,b.status_start_time
,b.status_end_time
,b.main_status as main_status_final
,(case when left(a.begin_time,4)<= '2017' then c.finance_day_every_5_day else c.finance_day_every_Wednesday end) as end_time_final
from (select * from m_fact_contract_finance t1 where t1.sysid = 'ryan_jtcw') a
inner join (select * from m_fact_contract_status2 t2 where t2.sysid = 'ryan_jtcw') b on a.id=b.id
inner join m_dim_finance_day c on date_format(a.end_time,'%Y-%m-%d') = c.nature_day
where b.main_status =5  -- and  date(b.status_start_time) <= '2018-08-06' and date(b.status_end_time)>'2018-08-06'
;

-- 大众财富存量计算 2018-08-06
select
sum(amount)
from v_fact_stock_finance a
where date(a.status_start_time) <= '2018-08-06' and date(a.status_end_time)>'2018-08-06'
;

-- 集团财务存量计算 2018-08-06
select 
sum(amount)/10000
from v_fact_stock_jtcw a
where (date(a.status_start_time) <= '2018-08-06' and date(a.status_end_time)>'2018-08-06' )
and a.end_time_final >=date('2018-08-06')
;
