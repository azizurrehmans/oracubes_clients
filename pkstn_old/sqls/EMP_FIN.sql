insert into emp_fin (
ABSENT_RATE, 
ADDTION_ALLOW, 
ADVANCE_20TH, 
BASIC_SALARY, 
EMPLOYEE_ID, 
FDATETIME, 
FIXED_OT, 
HOUSE_RENT, 
INCOME_TAX_AMOUNT, 
OT_ALLOWED, 
OT_RATE, 
SALARY_GROUP, 
STATUS_ID, 
USER_ID, 
UTILTIY
)
select 
F.ABSENT_RATE, 
F.ADDTION_ALLOW, 
F.ADVANCE_20TH, 
F.BASIC_SALARY, 
F.EMPLOYEE_ID, 
sysdate,
F.FIXED_OT, 
F.HOUSE_RENT, 
F.INCOME_TAX_AMOUNT, 
F.OT_ALLOWED, 
F.OT_RATE, 
F.SALARY_GROUP, 
'RELEASE', 
'aziz', 
F.UTILTiY
from 
employee f