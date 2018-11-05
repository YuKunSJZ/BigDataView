drop temporary table if exists a;
create temporary table a as
select 
 agent_stock_cnt.agent_name
,agent_dept.dept_name
,agent_dept.superior_dept
,agent_stock_cnt.cur_cnt
-- ,agent_stock_cnt.last_cnt
-- ,agent_stock_cnt.cur_new_cnt
from 
(
select
agent_name
,count(distinct case when '2018-07-31' between a.stock_start_date and a.stock_end_date then a.idcode else null end) as cur_cnt
-- ,count(distinct case when '2018-07-31' between a.stock_start_date and a.stock_end_date then a.idcode else null end) as last_cnt
-- ,count(distinct case when ('2018-07-31' between a.stock_start_date and a.stock_end_date) and b.idcode is not null then b.idcode else null end) cur_new_cnt
from m_fact_stock_finance_new a 
left join (select idcode from dm_new_customer where y_month=date_format('2018-08-22','%Y-%m')) b on a.idcode = b.idcode
where a.sysid = 'ryan_dz'
group by agent_name
) agent_stock_cnt
left join 
(
select distinct a.name agent_name,
				b.name dept_name,
                case when b.level = '三级' then b.name else b.superior_dept end superior_dept
                from m_dim_agent a
                left join m_dim_dept b on a.dept_name = b.name
                where a.sysid = 'ryan_dz'
) agent_dept
on agent_stock_cnt.agent_name = agent_dept.agent_name
;

drop temporary table if exists a
;
create temporary table a as
select
agent_name
,count(distinct case when '2018-07-31' between a.stock_start_date and a.stock_end_date then a.idcode else null end) as cur_cnt
-- ,count(distinct case when '2018-07-31' between a.stock_start_date and a.stock_end_date then a.idcode else null end) as last_cnt
-- ,count(distinct case when ('2018-07-31' between a.stock_start_date and a.stock_end_date) and b.idcode is not null then b.idcode else null end) cur_new_cnt
from m_fact_stock_finance_new20180824 a 
left join (select idcode from dm_new_customer where y_month=date_format('2018-08-22','%Y-%m')) b on a.idcode = b.idcode
where a.sysid = 'ryan_dz'
group by agent_name
;

select
*
from a 
right join
(
select 
b.agent_name
,count(distinct idcode) as cur_cnt
from m_fact_stock_finance b
where date(b.time) = '2018-07-31'
and b.sysid = 'ryan_dz'
group by b.agent_name
) c on a.agent_name = c.agent_name
where a.cur_cnt<> c.cur_cnt
;

select
*
from m_fact_stock_finance_new20180824 a
where '2018-07-31' between a.stock_start_date and a.stock_end_date and agent_name = '李广' and a.sysid = 'ryan_dz'
;


select
*
from m_fact_stock_finance_new20180824 a
where '2018-07-31' between a.stock_start_date and a.stock_end_date and agent_name = '李广' and a.sysid = 'ryan_dz'
;
select 
*
from m_fact_stock_finance b
where date(b.time) = '2018-07-31'
and b.sysid = 'ryan_dz'
and b.agent_name = '李广'
;


AXJH-3518
AXJH-3762
AXJH-3766
2715	6c9087855fb85b5401600c22dc30jd01
2639	4c9087855fb85b5401600c205318jd01

LC-22918

select * from m_dim_product_finance a where a.product_key in (2715,
2639)

李广	4	李广	3

select 
*
from m_fact_stock_finance_new20180824 a
where a.contract_id = 'LC-22918'
;


create table m_fact_stock_finance_new_20180824bak as
select
*
from m_fact_stock_finance_new
;

select 