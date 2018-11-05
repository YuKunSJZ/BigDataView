select

*
from ods_db.fz_dw_borrow_tender
where borrow_id = 2077
limit 100
;



select 
*
from dw_db.m_fact_contract_fzxsdq
where product_id  = 2077
limit 100
;

select
*
from dw_db.m_fact_outmoney_finance
where product_id = 2077
limit 100
;

select 
*
from dw_db.m_fact_stock_finance
where product_id = 2077
limit 100
;

select
*
from dw_db.m_fact_inmoney_finance
where product_id = 2077
limit 100
;

select
*
from ods_db.fz_dw_borrow 
where `id` = 2077
limit 100
;


-- 升级SQL 
set sql_safe_updates = 0;
delete from ods_db.fz_dw_borrow_tender where borrow_id = 2077
;
delete from dw_db.m_fact_contract_fzxsdq where product_id = 2077
;
delete from dw_db.m_fact_inmoney_finance
where product_id = '2077'
;

delete from dw_db.m_fact_outmoney_finance where product_id = '2077'
;

delete from dw_db.m_fact_stock_finance where product_id = '2077'
;