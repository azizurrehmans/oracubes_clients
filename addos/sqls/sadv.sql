create or replace view
hr_salary_view
as
select s.BANK_LETTER_DATE, s.DAYS, s.EMPLOYEE_ID, s.FDATETIME, s.GROUP_INSURANCE, s.REST, s.SALARY_ID, s.STATUS_ID, s.USER_ID, A.AMOUNT ADVANCE
from hr_salary s,
(select a.salary_id, SUM(amount) AMOUNT
from hr_salary_advance a
where voucher_seq is not null and status_id = 'RELEASE'
GROUP BY A.SALARY_ID) A
WHERE S.SALARY_ID = A.SALARY_ID (+)

