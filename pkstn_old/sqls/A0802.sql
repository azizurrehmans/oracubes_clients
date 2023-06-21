ALTER TABLE ADDOS.HR_DEPARTMENT
RENAME COLUMN CUR_COA_ID TO COA_SEQ;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN INSERT_BY;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN INSERT_DATE;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN INSERT_TERM;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN LAST_UPDATED_BY;
ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN LAST_UPDATED_DATE;
ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN LAST_UPDATED_TERM;
ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN COA_MAIN_ID;
ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN COA_SUB_ID;
ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN COA_ID;
ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN CUR_COA_MAIN_ID;
ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN CUR_COA_SUB_ID;

create or replace view hr_loan_view
as
select loan.loan_id, amount, loan.fdatetime, loan.status_id, loan.employee_id, e.name, loan.voucher_seq, loan.reason
from hr_loan loan, hr_employee e
where loan.employee_id = e.employee_id