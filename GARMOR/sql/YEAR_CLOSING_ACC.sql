CREATE TABLE COA_CLOSING_2021
AS
select acc_id, '21' YEAR, 
case 
  when coa_closing_dt(acc_id, '30-jun-2020') > 0 then coa_closing_dt(acc_id, '30-jun-2020')
  else 0
end dr,
case 
  when coa_closing_dt(acc_id, '30-jun-2020') < 0 then abs(coa_closing_dt(acc_id, '30-jun-2020'))
  else 0
end cr, 
sysdate FDATETIME, 'aziz' USER_ID,'RELEASE' STATUS 
 from coa;
 
 insert into coa_opening_ (ACC_id, year_id,dr_amount, cr_amount, fdatetime, user_id, status)
SELECT * FROM COA_CLOSING_2021
WHERE DR>0 OR CR>0;