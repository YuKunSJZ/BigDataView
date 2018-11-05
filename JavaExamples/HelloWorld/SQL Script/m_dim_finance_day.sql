
drop table if exists m_dim_finance_day;
create table m_dim_finance_day
(
nature_day date ,
nature_year char(4) ,
nature_month varchar(2) ,
nature_day_of_month varchar(2) ,
is_work_day integer default null,
finance_day_every_5_day date ,
finance_day_every_Wednesday date,
PRIMARY key (nature_day)
) charset = utf8 
;
alter table m_dim_finance_day comment '自然日对应财务日转换表';

alter table m_dim_finance_day modify column nature_day date comment '自然日日期'
;
alter table m_dim_finance_day modify column nature_year char(4) comment '自然日年份'
;
alter table m_dim_finance_day modify column nature_month varchar(2) comment '自然日月份'
;
alter table m_dim_finance_day modify column nature_day_of_month varchar(2) comment '自然日月天'
;
alter table m_dim_finance_day modify column finance_day_every_5_day date comment '财务日A口径：逢5日打款，31号按30号，周六日顺延'
;
alter table m_dim_finance_day modify column finance_day_every_Wednesday date comment '财务日B口径：逢周三打款'
;
alter table m_dim_finance_day modify column is_work_day integer comment '是否工作日'
;



drop procedure if exists match_date_finance_day;
delimiter $$
create procedure match_date_finance_day(in start_date varchar(20),in insert_days integer)
BEGIN
 set @cur_day := start_date ;
		set @i = 0;
		while @i < insert_days do 
            set @CurDayOfMonth :=  DAYOFMONTH(@cur_day);
            set @DayOfWeek := DAYOFWEEK(@cur_day);
            set @FinanaceDayA :=  @cur_day;
            set @FinanaceDayB :=  @cur_day;

           -- @FinanaceDayA 财务日A口径：逢5日打款，周六日顺延
           if @CurDayOfMonth % 5 = 0 and @DayOfWeek in (2,3,4,5,6) then 
               set @FinanaceDayA :=  @cur_day;
           elseif @CurDayOfMonth = 31 then
               set @FinanaceDayA = cast(date_add(@cur_day, INTERVAL -1 day) as char);
           else 
             outer_label: begin 
               set @j = 0;
                   
               while @j <=5  do
                    set @FinanaceDayA = cast(date_add(@cur_day,INTERVAL @j day) as char);
                    if DAYOFMONTH(@FinanaceDayA) % 5 = 0 THEN
                       leave outer_label;
                    end if;
                   set @j = @j +1;
               end while ;
              end outer_label ;
           end if;
            -- select @FinanaceDay;

					 if DAYOFWEEK(@FinanaceDayA) = 7  then
              -- 7 周六  1 周日
							set @FinanaceDayA := cast(date_add(@FinanaceDayA, INTERVAL 2 day) as char);

           elseif DAYOFWEEK(@FinanaceDayA) = 1 then 
              set @FinanaceDayA := cast(date_add(@FinanaceDayA, INTERVAL 1 day) as char);
              -- select @FinanaceDay;

           end if ;
           
           if @DayOfWeek = 4 then 
              set @FinanaceDayB = @cur_day;
           ELSE
               outer_labelB: begin
               set @j = 1;
               while @j <= 7 do 
                  set @FinanaceDayB = cast(date_add(@cur_day,INTERVAL @j day) as char);
                  if DAYOFWEEK(@FinanaceDayB) = 4 THEN
                       leave outer_labelB;
                  end if;
                  set @j = @j + 1;
               end while;
               end outer_labelB ;
           end if;

          insert into  m_dim_finance_day (
						nature_day  ,
						nature_year ,
						nature_month ,
						nature_day_of_month ,
						is_work_day,
						finance_day_every_5_day ,
						finance_day_every_Wednesday )
					values(@cur_day ,year(@cur_day),month(@cur_day),DAYOFMONTH(@cur_day),null,@FinanaceDayA,@FinanaceDayB);
          
          set @cur_day = cast(date_add(@cur_day,INTERVAL 1 day) as char);
          set @i = @i +1;
    end while ; 
    update m_dim_finance_day a
				set a.is_work_day = (case when DAYOFWEEK(nature_day) in (7,1) then 0 else 1 end )
				where a.nature_day>=start_date
				;
end $$
delimiter ;
call match_date_finance_day('2016-07-01',2000);
-- m_fact_stock_finance

SELECT
  sysid
, id
, DATE(SUBDATE(NOW(),INTERVAL 1 DAY)) as time
, amount
, begin_time
, main_status
, agent_id
, agent_name
,  dept_id
, dept_name
, customer_id
, customer_name
, idcode
, product_id
, customer_key,
  agent_key,
  product_Key,
  dept_key
FROM m_fact_contract_finance a
inner join m_dim_finance_day b on date_format(a.end_time,'%Y-%m-%d') = b.nature_day
where 
sysid = 'ryan_jtcw'
and main_status = '5'
and (case when left(a.begin_time,4)<= '2017' then b.finance_day_every_5_day else b.finance_day_every_Wednesday end) >=date(now())
-- and date(end_time)>=date(now())


-- m_fact_outmoney_finance
SELECT
	sysid,
	id,
 (case when left(a.begin_time,4) <= 2017 then b.finance_day_every_5_day else b.finance_day_every_Wednesday end) as end_time,
 amount,
 main_status,
 agent_id,
 agent_name,
 dept_id,
 dept_name,
 customer_id,
 idcode,
 customer_name,
 product_id,
 customer_key,
 agent_key,
 product_Key,
 dept_key
FROM
	m_fact_contract_finance a
inner join m_dim_finance_day b on date_format(a.end_time,'%Y-%m-%d') = b.nature_day
WHERE
	sysid = 'ryan_jtcw'
and main_status = '5'
and (case when left(a.begin_time,4) <= 2017 then b.finance_day_every_5_day else b.finance_day_every_Wednesday end)<date(current_date)
