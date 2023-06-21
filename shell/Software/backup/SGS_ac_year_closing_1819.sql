drop table ac_coa_closing_1819;

CREATE TABLE AC_COA_CLOSING_1819
AS
select coa_seq, '19-20' YEAR, 
case 
  when ac_coa_closing_dt(coa_seq, '30-jun-2019') > 0 then ac_coa_closing_dt(coa_seq, '30-jun-2019')
  else 0
end dr,
case 
  when ac_coa_closing_dt(coa_seq, '30-jun-2019') < 0 then abs(ac_coa_closing_dt(coa_seq, '30-jun-2019'))
  else 0
end cr, 
sysdate FDATETIME, 'aziz' USER_ID,'RELEASE' STATUS 

 from ac_coa where parent_id in (1,2,3,4,5);
 
delete from ac_coa_opening where year_id = '19-20'; 



---SELECT * FROM AC_COA_CLOSING_1718;
 
insert into ac_coa_opening (coa_seq, year_id,dr_amount, cr_amount, fdatetime, user_id, status)
SELECT * FROM AC_COA_CLOSING_1819 where coa_seq in (select coa_seq from ac_coa where parent_id in (1,2,3,4,5));