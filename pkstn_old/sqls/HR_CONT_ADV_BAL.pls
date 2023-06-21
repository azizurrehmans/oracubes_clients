create or replace function       hr_cont_adv_bal(emp number, sal date)
return number
is
 ans number := 0;
 b number := 0;
 t number := 0;
 d number := 0;
begin
   select nvl(sal_adv_balance,0) into b from hr_employee where employee_id = emp;
   select nvl(sum(amount),0) into t from hr_sal_adv_cont where employee_id = emp and voucher_seq is not null;
   select nvl(sum(salary_advance),0) 
   into d 
   from hr_sal_cont_detail
   where employee_id = emp and sal_cont_id < sal;   
   --return d;      
   ans := b + t - d;      
   return ans;
end;