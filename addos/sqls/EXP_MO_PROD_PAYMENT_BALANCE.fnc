CREATE OR REPLACE function exp_mo_prod_payment_balance(mo number)
return char
is
  ans number;
  oq number ;
  jq number;
  bq number;
begin
   select sum(quantity) into oq from exp_cpo_detail where cpo_id = mo;
   select count(*) into jq from prod_jcd_view where cpo_id = mo;
   if (oq > 0) and (jq = 0) then
      return 'YES';
   end if;  
   
   select sum(balance) into bq from prod_csc_jcd_issue_rec_paid where cpo_id = mo;
   
   if (bq > 0) then
     return 'YES';
   END IF;  
     
   RETURN 'NO';
end;
/

select * from prod_csc_jcd_issue_rec_paid where cpo_id = 4529;
select exp_mo_prod_payment_balance(CPO_ID) from EXP_CPO;
