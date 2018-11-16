SELECT
	parent_name,
	limit_time,
	profit_rate / 100 AS profit_rate,
	sum(ltotalc) / 10000 AS ltotalc,
	sum(ntotalin) / 10000 AS ntotalin,
	sum(ntotalout) / 10000 AS ntotalout,
	sum(ntotalc) / 10000 AS ntotalc,
    if(sum(ltotalc) / 10000 + sum(ntotalin) / 10000  - sum(ntotalout) / 10000 = sum(ntotalc) / 10000,1,0)
FROM
(
select case when b.parent_name is null then '其他理财' 
            when c.contract_id is not null then '活期'
            when  b.parent_name = '安享计划' AND b.undefine1 = '开放期产品' THEN '安享开放'
            else b.parent_name end parent_name,
     b.limit_time,
           case when c.contract_id is not null then c.htfxlv1 else b.profit_rate end as profit_rate,
	sum(a.amount) as ltotalc
    ,0 ntotalin
    ,0 as ntotalout
    ,0 as ntotalc
  from (select contract_amount as amount,product_id,contract_id from m_fact_stock_finance_new a where sysid ='ryan_dz' and last_day(date_sub('2018-08-13', INTERVAL 1 MONTH)) between stock_start_date and  stock_end_date ) a
  left join (select id, if_current, parent_name,limit_time,profit_rate,undefine1 from m_dim_product_finance  where sysid = 'ryan_dz') b on a.product_id = b.id
  left join (select contract_id,htfxlv htfxlv1 from hq_lv where flag=1)  c on a.contract_id = c.contract_id 
 group by parent_name,limit_time,case when c.contract_id is not null then c.htfxlv1 else b.profit_rate end
 
 union all
 
 select case when b.parent_name is null then '其他理财' 
			when c.contract_id is not null then '活期'
            when  b.parent_name = '安享计划' AND b.undefine1 = '开放期产品' THEN '安享开放'
            else b.parent_name end parent_name,
     b.limit_time,
           case when c.contract_id is not null then c.htfxlv1 else b.profit_rate end as profit_rate,
     0 as ltotalc
    ,0 ntotalin
    ,0 as ntotalout
    ,sum(a.amount) as ntotalc
  from (select contract_amount as amount,product_id,contract_id from m_fact_stock_finance_new a where sysid ='ryan_dz' and  date('2018-08-13') between stock_start_date and  stock_end_date ) a
  left join (select id, if_current, parent_name,limit_time,profit_rate,undefine1 from m_dim_product_finance  where sysid = 'ryan_dz') b on a.product_id = b.id
  left join (select contract_id,htfxlv htfxlv1 from hq_lv where flag=1)  c on a.contract_id = c.contract_id 
 group by parent_name,limit_time,case when c.contract_id is not null then c.htfxlv1 else b.profit_rate end
 
 union all
 select case when b.parent_name is null then '其他理财' 
 			when c.contract_id is not null then '活期'
            when  b.parent_name = '安享计划' AND b.undefine1 = '开放期产品' THEN '安享开放'
            else b.parent_name end parent_name,
     b.limit_time,
           case when c.contract_id is not null then c.htfxlv1 else b.profit_rate end as profit_rate,
     0 as ltotalc
    ,0 ntotalin
    ,sum(a.amount) as ntotalout
    ,0 as ntotalc
  from (select contract_amount as amount,product_id,contract_id from m_fact_outmoney_finance where sysid ='ryan_dz' and  main_status = '8' and DATE_FORMAT(pay_time, '%Y-%m') = DATE_FORMAT('2018-08-13', '%Y-%m')
        union all select ht_je_xx as amount,cp_id as product_id,ht_code as contract_id  from m_fact_ra_lc where DATE_FORMAT(input_time, '%Y-%m') = DATE_FORMAT('2018-08-13', '%Y-%m')) a
  left join (select id, if_current, parent_name,limit_time,profit_rate,undefine1 from m_dim_product_finance  where sysid = 'ryan_dz') b on a.product_id = b.id
  left join (select contract_id,htfxlv htfxlv1 from hq_lv where flag=1)  c on a.contract_id = c.contract_id 
 group by parent_name,limit_time,case when c.contract_id is not null then c.htfxlv1 else b.profit_rate end
 
 union all
 select case when b.parent_name is null then '其他理财' 
 			when c.contract_id is not null then '活期'
            when  b.parent_name = '安享计划' AND b.undefine1 = '开放期产品' THEN '安享开放'
            else b.parent_name end parent_name,
     b.limit_time,
           case when c.contract_id is not null then c.htfxlv1 else b.profit_rate end as profit_rate,
     0 as ltotalc
    ,sum(a.amount) as ntotalin
    ,0 as ntotalout
    ,0 as ntotalc
  from (select contract_amount as amount,product_id,contract_id from m_fact_inmoney_finance where sysid ='ryan_dz' and DATE_FORMAT(entertime, '%Y-%m') = DATE_FORMAT('2018-08-13', '%Y-%m')) a
  left join (select id, if_current, parent_name,limit_time,profit_rate,undefine1 from m_dim_product_finance  where sysid = 'ryan_dz') b on a.product_id = b.id
  left join (select contract_id,htfxlv htfxlv1 from hq_lv where flag=1)  c on a.contract_id = c.contract_id 
 group by parent_name,limit_time,case when c.contract_id is not null then c.htfxlv1 else b.profit_rate end
) final

GROUP BY
	parent_name,
	limit_time,
	profit_rate
ORDER BY
	locate(
		parent_name,
		'受托管理资产-控股,世纪安赢,五二零,幸福壹号,创赢,安盈家园,安享计划,安享开放,瑞安基金,科慧计划,渤海一号,岁岁生金,岁岁满金,薪火创盈,启鑫基金,共赢1号'
	),
	limit_time + 0,
	profit_rate
;

-- 2018.11.15优化
select 
 case when b.undefine1 = '开放期产品'  THEN '安享开放' else b.parent_name end parent_name
,case when b.if_current = 1 then '活期' else b.limit_time end as limit_time
-- ,ifnull(hq_lv,b.profit_rate) as profit_rate
,case when hq_lv is null and b.if_current=0 then profit_rate else null end
,sum(case when a.stock_type='stock' and stock_date = last_day(date_add('2018-11-14',interval -1 month)) then contract_amount else 0 end) last_stock
,sum(case when a.stock_type='flow_in' and stock_date = '2018-11-14' then contract_amount else 0 end) cur_flow_in
,sum(case when a.stock_type='flow_out' and stock_date = '2018-11-14' then contract_amount else 0 end) cur_flow_out
,sum(case when a.stock_type='stock' and stock_date = '2018-11-14' then contract_amount else 0 end) cur_stock
from (select * from dm_db.dm_stock_in_agent_product where stock_date in ('2018-11-14',last_day(date_add('2018-11-14',interval -1 month))) and sysid='ryan_dz') a
left join (select * from dw_db.m_dim_product_finance where sysid = 'ryan_dz') b on a.product_id=b.id
group by 
 case when b.undefine1 = '开放期产品'  THEN '安享开放' else b.parent_name end
,case when b.if_current = 1 then '活期' else b.limit_time end 
,case when hq_lv is null and b.if_current=0 then profit_rate else null end
ORDER BY
	locate(
		parent_name,
		'受托管理资产-控股,世纪安赢,五二零,幸福壹号,创赢,安盈家园,安享计划,安享开放,瑞安基金,科慧计划,渤海一号,岁岁生金,岁岁满金,薪火创盈,启鑫基金,共赢1号'
	),
	limit_time + 0,
	profit_rate
;

-- 新投流入
SELECT
	agent_name,
	sum(amount)/10000 as newaddtotal
FROM
 m_fact_contract_finance 
where classify = '1'
and begin_time >= '${begin}' AND begin_time <= '${end}'
and sysid = 'ryan_dz'
GROUP BY
	agent_name

-- 转投加钱
SELECT
	a.agent_name,
	sum(ifnull(a.additional_amount, 0))/10000 as newaddtotal
FROM
	m_fact_contract_finance a
WHERE a.classify = '4'
and a.begin_time >= '${begin}' AND a.begin_time <= '${end}'
and a.sysid = 'ryan_dz'
GROUP BY
	a.agent_name

-- 结息
select agent_name,sum(return_money)/10000 as totalout from m_fact_rates_finance
WHERE return_time >= '${begin}' AND return_time <= '${end}'
GROUP BY agent_name

-- 结算
SELECT jbr_name,
	  sum(ht_je_xx)/10000 as totalout
  FROM m_fact_ra_lc
 where date(input_time) >= '${begin}'
   AND date(input_time) <= '${end}'
   and cp_name not in (SELECT name FROM m_dim_product_finance where undefine1 = '梯度收益')
   and cp_name not in (SELECT name FROM m_dim_product_finance where if_current = 1)
 group by jbr_name