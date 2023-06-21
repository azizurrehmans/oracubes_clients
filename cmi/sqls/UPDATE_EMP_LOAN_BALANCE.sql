update employee set loan_balance =COA_OPENING_DT(1,21,employee_id,'30-jun-2013') 
where employee_type = 'EMPLOYEE'