create or replace view hr_salary_view
as
select s.SALARY_ID, s.STATUS_ID, sum(a.amount) amount
from hr_salary s, hr_salary_advance a
where s.salary_id = a.salary_id
and a.voucher_seq is not null
group by s.salary_id, s.status_id;
-----------------------------------------
CREATE OR REPLACE FORCE VIEW addos.hr_salary_detail_emp_view 
--------------------------------------------

ALTER TABLE ADDOS.HR_DEPARTMENT
RENAME COLUMN COA_ID TO COA_seq;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN INSERT_BY;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN INSERT_DATE;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN INSERT_TERM;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN LAST_UPDATED_BY;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN LAST_UPDATED_DATE;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN LAST_UPDATED_TERM;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN COA_MAIN_ID;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN COA_SUB_ID;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN CUR_COA_MAIN_ID;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN CUR_COA_SUB_ID;

ALTER TABLE ADDOS.HR_DEPARTMENT DROP COLUMN CUR_COA_ID;
------------

view hr_salary_detail_view      