-- editor:zhaoyukun
-- plan to: ����m_dim_finance_day�����ղ���ȷ��
-- how to use:�Ƚ�ĳһ��Ĺ����ոĶԣ�Ȼ����ĳһ���update
drop procedure if exists update_finance_day;
delimiter $$
create procedure update_finance_day(in year_to_update varchar(20))
BEGIN
   declare my_nature_day varchar(20);
   declare done int;

   declare my_recordset cursor for 
     select nature_day from m_dim_finance_day a where a.nature_year = year_to_update;

   declare continue HANDLER for not found set done = 1;
   
   open my_recordset;

   loop_label:LOOP
      if done = 1 then 
					leave loop_label;
      end if; 
      fetch my_recordset into my_nature_day;

						set @cur_day := my_nature_day;
            set @CurDayOfMonth :=  DAYOFMONTH(@cur_day);
            set @DayOfWeek := DAYOFWEEK(@cur_day);
            set @FinanaceDayA :=  @cur_day;
            set @FinanaceDayB :=  @cur_day;

           -- @FinanaceDayA ������A�ھ�����5�մ�������˳��
           if @CurDayOfMonth % 5 = 0 and @DayOfWeek in (2,3,4,5,6) then 
               set @FinanaceDayA :=  @cur_day;
           elseif @CurDayOfMonth = 31  then
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

           select min(a.nature_day) into @FinanaceDayA from m_dim_finance_day a where a.nature_day>= @FinanaceDayA and is_work_day = 1;
         
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
               
            select min(a.nature_day) into @FinanaceDayB from m_dim_finance_day a where a.nature_day>= @FinanaceDayB and is_work_day = 1;

           end if;

           update m_dim_finance_day a set a.finance_day_every_5_day = @FinanaceDayA, a.finance_day_every_Wednesday = @FinanaceDayB where a.nature_day = @cur_day;
          end loop loop_label;

end $$
delimiter ;


-- 1 ������������
update m_dim_finance_day a
set a.is_work_day = 0
where a.nature_day in
(
'2018-02-15'
,'2018-02-16'
,'2018-02-19'
,'2018-02-20'
,'2018-02-21'
,'2018-04-05'
,'2018-04-06'
,'2018-04-30'
,'2018-05-01'
,'2018-06-18'
,'2018-09-24'
,'2018-10-01'
,'2018-10-02'
,'2018-10-03'
,'2018-10-04'
,'2018-10-05'
)
;

update m_dim_finance_day a
set a.is_work_day = 1
where a.nature_day in
(
 '2018-02-11'
,'2018-02-24'
,'2018-04-08'
,'2018-04-28'
,'2018-09-29'
,'2018-09-30'
)
;

-- 2 ���洢������������
call update_finance_day('2018');

select * from m_dim_finance_day where nature_year = 2018
;