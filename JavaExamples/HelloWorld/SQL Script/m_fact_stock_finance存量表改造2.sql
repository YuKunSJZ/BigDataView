CREATE TABLE `m_fact_stock_finance_new` (
  `sysid` varchar(20) NOT NULL COMMENT '所属公司',
  `contract_id` varchar(100) NOT NULL COMMENT '合同ID',
  stock_start_date date default null  comment '存量开始时间',
  stock_end_date date default null comment '存量结束时间',
  `contract_amount` decimal(20,3) DEFAULT NULL COMMENT '合同金额',
  `agent_key` int(11) DEFAULT NULL,
  `agent_id` varchar(100) DEFAULT NULL COMMENT '经办人ID',
  `agent_name` varchar(100) DEFAULT NULL COMMENT '经办人姓名',
  `dept_key` int(11) DEFAULT NULL,
  `dept_id` varchar(100) DEFAULT NULL COMMENT '经办人部门id',
  `dept_name` varchar(100) DEFAULT NULL COMMENT '经办人部门',
  `customer_key` int(11) DEFAULT NULL,
  `customer_id` varchar(100) DEFAULT NULL COMMENT '客户ID',
  `idcode` varchar(20) DEFAULT NULL COMMENT '证件号',
  `customer_name` varchar(100) DEFAULT NULL COMMENT '客户姓名',
  `product_key` int(11) DEFAULT NULL,
  `product_id` varchar(100) DEFAULT NULL COMMENT '产品ID',
  PRIMARY KEY (`sysid`,`contract_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
truncate table m_fact_stock_finance_new;
select count(1) from m_fact_stock_finance_new a
;
select * from m_fact_stock_finance_new 
limit 100
;



drop temporary table tmp_stock_former_data;
create temporary table tmp_stock_former_data
as
select 
`sysid` ,
`contract_id`  
,date(min(time))  stock_start_date
,date(max(time))  stock_end_date
from m_fact_stock_finance a
group by `sysid` ,
`contract_id`
;


alter table tmp_stock_former_data add index IX_1(sysid,contract_id);


insert into m_fact_stock_finance_new
select 
 a.sysid                
,a.contract_id         
,a.stock_start_date
,a.stock_end_date       
,b.amount as contract_amount     
,agent_key           
,agent_id            
,agent_name          
,dept_key            
,dept_id             
,dept_name           
,customer_key        
,customer_id         
,idcode              
,customer_name       
,product_key         
,product_id  
from tmp_stock_former_data a
left join m_fact_contract_finance b
on a.sysid=b.sysid and a.contract_id = b.id
where  a.sysid in( 'ryan_dz' ,'ryan_jtcw','ryan_fzlc_xx_dq')and b.id is not null 
;

delete from m_fact_stock_finance_new where sysid = 'ryan_fzlc_xx_dq';
insert into m_fact_stock_finance_new
select 
 a.sysid                
,a.contract_id         
,a.stock_start_date
,a.stock_end_date       
,b.account as contract_amount     
,agent_key           
,null as agent_id             
,null as agent_name          
,null as dept_key            
,null as dept_id             
,null as dept_name           
,customer_key        
,null customer_id         
,idcode              
,null customer_name       
,product_key         
,product_id  
from tmp_stock_former_data a
left join (SELECT * FROM dw_db.m_fact_contract_fzxx where sysid = 'ryan_fzlc_xx_dq') b
on a.sysid=b.sysid and a.contract_id = b.codenumb
where  a.sysid in( 'ryan_fzlc_xx_dq')and b.codenumb is not null 
;


-- 121701.5000000

select 
sum(contract_amount)/10000
from m_fact_stock_finance_new a
where a.sysid = 'ryan_dz'
and a.stock_start_date <= date('2018-08-01') and a.stock_end_date >= date('2018-08-01') 
;

select * from m_fact_stock_finance_new a where a.sysid = 'ryan_fzlc_xx_dq' limit 100
;

-- 4725.0000000
-- 121212.5000000
select
sum(contract_amount)/10000
from m_fact_stock_finance a
where a.sysid = 'ryan_dz'
and date(a.time) = date('2018-08-01')
;


-- start 20180810
create temporary table tmp_contract_end_date
select 
contract_id
,stock_end_date
 from m_fact_stock_finance_new a where a.sysid = 'ryan_fzlc_xx_dq'
 and a.agent_id is null
 ;

create temporary table tmp_contract_agent_info

select 
a.*
from m_fact_stock_finance a
inner join tmp_contract_end_date b on a.sysid = 'ryan_fzlc_xx_dq' and a.contract_id = b.contract_id and date(a.time) = b.stock_end_date
;

set sql_safe_updates = 0;
update m_fact_stock_finance_new a 
inner join tmp_contract_agent_info b on a.sysid='ryan_fzlc_xx_dq' and a.contract_id = b.contract_id
set 
 a.agent_key    = b.agent_key
,a.agent_id     = b.agent_id
,a.agent_name   = b.agent_name
,a.dept_id      = b.dept_id
,a.dept_name    = b.dept_name
,a.customer_name= b.customer_name
;