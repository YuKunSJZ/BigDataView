-- 上月客户总数

SELECT
  agent_name,
  dept_name,
  count(DISTINCT idcode) as cnum
  from
	m_fact_stock_finance a
  where 
  a.sysid ='ryan_dz'
  and date(time)=DATE_FORMAT(DATE_ADD('2018-07-31',INTERVAL -0 month),'%Y-%m-%d')
  and a.agent_name = '张瑞苗'
  group by agent_name,dept_name
  order by dept_name
;
-- 新客户数
SELECT
	a.agent_name,dept_name,
	count(DISTINCT a.idcode) AS cnum
FROM
	(select distinct agent_name,dept_name,idcode from m_fact_stock_finance
	where date(time)='2018-08-22' and sysid='ryan_dz') a 
  right join 
  (select idcode from dm_new_customer where y_month=date_format('2018-08-22','%Y-%m'))b
  on a.idcode = b.idcode
  where a.agent_name ='张瑞苗'
group by agent_name,dept_name;


select 
 agent_stock_cnt.agent_name
,agent_dept.dept_name
,agent_dept.superior_dept
,agent_stock_cnt.cur_cnt
,agent_stock_cnt.last_cnt
,agent_stock_cnt.cur_new_cnt
from 
(
select
agent_name
,count(distinct case when '2018-08-22' between a.stock_start_date and a.stock_end_date then a.idcode else null end) as cur_cnt
,count(distinct case when '2018-07-31' between a.stock_start_date and a.stock_end_date then a.idcode else null end) as last_cnt
,count(distinct case when ('2018-08-22' between a.stock_start_date and a.stock_end_date) and b.idcode is not null then b.idcode else null end) cur_new_cnt
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


