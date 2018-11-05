/*
ods_db.fz_dw_xianxialist
dw_db.m_fact_contract_fzxx
dw_db.m_fact_inmoney_finance
dw_db.m_fact_outmoney_finance
dw_db.m_dim_product_finance
dw_db.m_fact_stock_finance
*/
-- ods层 合同表
-- 36月：22%  30月：24%
update ods_db.fz_dw_xianxialist a
set a.apr = (case when a.time_limit = 36 then 0.22 when a.time_limit = 30 then 0.24 end)
where a.post_name = '基金创赢1号'
;

update ods_db.fz_dw_xianxialist a
set a.interest = a.account*a.apr*a.time_limit/12
where a.post_name = '基金创赢1号'
;

-- dw层合同表
update dw_db.m_fact_contract_fzxx a
set a.apr = (case when a.time_deal = 36 then 0.22 when a.time_deal = 30 then 0.24 end)
where a.post_name = '基金创赢1号'
;

update dw_db.m_fact_contract_fzxx a
set a.interest = a.account*a.apr*a.time_deal/12
where a.post_name = '基金创赢1号'
;

-- 流入表
update dw_db.m_fact_inmoney_finance a
set a.product_id = '基金创赢1号_36_0.260'
where a.sysid='ryan_fzlc_xx_dq'
 and a.product_id like '%基金创赢1号_36%'
;
update dw_db.m_fact_inmoney_finance a
set a.product_id = '基金创赢1号_30_0.240'
where a.sysid='ryan_fzlc_xx_dq'
 and a.product_id like '%基金创赢1号_30%'
;

-- 流出表 m_fact_outmoney_finance流出表无利率字段
update  dw_db.m_fact_outmoney_finance a
inner join dw_db.m_dim_product_finance b
on a.sysid = b.sysid and a.product_key = b.product_key
set a.product_id =b.id
where a.product_id like '%创赢%'
and a.product_key in (2653,2652)
;

-- 产品表
update dw_db.m_dim_product_finance a
set a.id = '基金创赢1号_30_0.240'
   ,a.profit_rate = 24
where a.product_key = '2652'
;

update dw_db.m_dim_product_finance a
set a.id = '基金创赢1号_36_0.220'
   ,a.profit_rate = 22
where a.product_key = '2653'
;

-- 存量表
update dw_db.m_fact_stock_finance a
inner join dw_db.m_dim_product_finance b
on a.sysid = b.sysid and a.product_key = b.product_key
set a.product_id = b.id
where a.product_id like '%创赢%'
and a.product_key in (2653,2652)
;

select
*
from dw_db.m_fact_outing_finance
limit 100
;

-- 第二个产品
set sql_safe_updates = 0;
update ods_db.fz_dw_xianxialist a
set a.apr = 0.138
where a.post_name like '%稳增%'
and a.apr =0.134
and a.time_limit = 12
;

update ods_db.fz_dw_xianxialist a
set a.interest = a.account*a.apr*a.time_limit/12
where a.post_name like '%稳增%'
and a.apr =0.138
and a.time_limit = 12
and a.interest<>a.account*a.apr*a.time_limit/12
;

-- m_fact_contract_fzxx
update dw_db.m_fact_contract_fzxx a 
set a.apr = 0.138
where a.post_name like '%稳增%'
and a.time_deal = 12 
and a.apr = 0.134
;

update dw_db.m_fact_contract_fzxx a 
set a.interest = a.account*a.apr*a.time_deal/12
where a.post_name like '%稳增%'
and a.time_deal = 12 
and a.apr = 0.138
and a.interest <> a.account*a.apr*a.time_deal/12
;

update dw_db.m_fact_inmoney_finance a
set a.product_id = '稳增1号_12_0.138'
WHERE a.product_id = '稳增1号_12_0.134'
;

-- 产品表无需修改
-- 流出表 2525 -> 2515


update dw_db.m_fact_stock_finance a
set a.product_id = '稳增1号_12_0.138'
where a. product_key = 2525
;

update dw_db.m_fact_stock_finance a
set a.product_key = 2515
where a. product_key = 2525
;

