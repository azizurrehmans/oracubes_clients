create or replace view hr_raw_attendance_view
as
select line, substr(    line,  instr(line,'"',1,5)+1,  ( instr(line,'"',1,6) - instr(line,'"',1,5)-1 )  )   emp_id,           
               to_date( substr(    line,  instr(line,'"',1,7)+1,  ( instr(line,'"',1,8) - instr(line,'"',1,7)-1 )  ) ,'mm/dd/yyyy hh12:mi AM')  ATT_DATETIME ,           
                 TO_DATE(TO_CHAR(to_date(substr(    line,  instr(line,'"',1,7)+1,  ( instr(line,'"',1,8) - instr(line,'"',1,7)-1 )  ) ,'mm/dd/yyyy hh12:mi AM'),'DD-MON-YYYY')) ATT_DATE,
                 STATUS, FDATETIME
from hr_raw_attendance;

---------------------------------------------------------------------------------------------------------------------

ALTER TABLE GILLANI.HR_BARCODE_ATTENDANCE  ADD (shift_id  NUMBER);
ALTER TABLE GILLANI.HR_BARCODE_ATTENDANCE  ADD (late_in  NUMBER);

-------------------------------------------------

ALTER TABLE HR_SUNDAY_WORKING_DAY
 DROP PRIMARY KEY CASCADE;
DROP TABLE HR_SUNDAY_WORKING_DAY CASCADE CONSTRAINTS;

CREATE TABLE HR_SUNDAY_WORKING_DAY
(
  DATE_ID  DATE
)
TABLESPACE ORACUBES
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX HR_SUNDAY_WOKING_DAY_PK ON HR_SUNDAY_WORKING_DAY
(DATE_ID)
LOGGING
TABLESPACE ORACUBES
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE HR_SUNDAY_WORKING_DAY ADD (
  CONSTRAINT SUNDAY_WOKING_DAY_PK
 PRIMARY KEY
 (DATE_ID)
    USING INDEX 
    TABLESPACE ORACUBES
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));
-----------------------------------------------------------

ALTER TABLE hr_OT
 DROP PRIMARY KEY CASCADE;
DROP TABLE HR_OT CASCADE CONSTRAINTS;

CREATE TABLE HR_OT
(
  EMPLOYEE_ID        NUMBER(6),
  ATTEN_DATE         DATE,
  OT_ID              NUMBER,
  OT                 NUMBER(6,2),
  OT1                DATE,
  OT2                DATE 
)
TABLESPACE ORACUBES
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          14M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX HR_OT_PK ON HR_OT
(EMPLOYEE_ID, ATTEN_DATE, OT_ID)
LOGGING
TABLESPACE ORACUBES
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          15M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE HR_OT ADD (
  CONSTRAINT OT_PK
 PRIMARY KEY
 (EMPLOYEE_ID, ATTEN_DATE, OT_ID)
    USING INDEX 
    TABLESPACE ORACUBES
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          15M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));     
-----------------------------------------------------
ALTER TABLE GILLANI.HR_SETUP DROP COLUMN INSERT_BY;
ALTER TABLE GILLANI.HR_SETUP DROP COLUMN INSERT_DATE;
ALTER TABLE GILLANI.HR_SETUP DROP COLUMN INSERT_TERM;
ALTER TABLE GILLANI.HR_SETUP DROP COLUMN LAST_UPDATED_BY;
ALTER TABLE GILLANI.HR_SETUP DROP COLUMN LAST_UPDATED_DATE;
ALTER TABLE GILLANI.HR_SETUP DROP COLUMN LAST_UPDATED_TERM;
------------------------------------------------------
ALTER TABLE GILLANI.HR_SETUP RENAME COLUMN IN_TIIME TO IN_TIME;
------------------------------------------------------
ALTER TABLE GILLANI.HR_ATTENDANCE MODIFY(STATUS_ID VARCHAR2(10));
ALTER TABLE GILLANI.HR_ATTENDANCE MODIFY(STATUS_ID  DEFAULT 'HOLD');
ALTER TABLE GILLANI.HR_ATTENDANCE DROP COLUMN INSERT_BY;
ALTER TABLE GILLANI.HR_ATTENDANCE DROP COLUMN INSERT_DATE;
ALTER TABLE GILLANI.HR_ATTENDANCE DROP COLUMN INSERT_TERM;
ALTER TABLE GILLANI.HR_ATTENDANCE DROP COLUMN LAST_UPDATED_BY;
ALTER TABLE GILLANI.HR_ATTENDANCE DROP COLUMN LAST_UPDATED_DATE;
ALTER TABLE GILLANI.HR_ATTENDANCE DROP COLUMN LAST_UPDATED_TERM;
------------------------------------------------------

CREATE OR REPLACE FORCE VIEW hr_barcode_attendance_view 
AS
   SELECT ba.SOURCE, ba.employee_id, ba.counter,
          TO_DATE (TO_CHAR (ba.fdatetime, 'dd-mon-yyyy')) attendance_date,
          ba.fdatetime, ba.inout, e.NAME, e.designation_id, e.department_id,
          ba.employee_id || '-' || e.NAME emp_id_name,
          e.designation_id || '-' || e.department_id desig_dept,
          ep.employee_photo, ba.late_in
     FROM hr_barcode_attendance ba, hr_employee e, hr_employee_photo ep
    WHERE ba.employee_id = e.employee_id AND ba.employee_id = ep.employee_id(+);
 ----------------------------------------
 CREATE OR REPLACE FORCE VIEW hr_employee_view
AS
   SELECT 0 monthly_max_late, 'NO' SERVICE_PROVIDER,  0 absent_rate, ef2.earning, ef2.deduction, ef2.net_salary,
          q.qualification_id, hr_service_age2 (doj) service_age2,
          hr_service_age2 (dob) age2, e.ntn,
          DECODE (religion, 'MUSLIM', 1, 0) muslim,
          DECODE (religion, 'CHRISTIAN', 1, 0) christian,
          DECODE (religion, 'HINDU', 1, 0) hindu,
          DECODE (gender, 'MALE', 1, 0) male,
          DECODE (gender, 'FEMALE', 1, 0) female,
          DECODE (marital_status, 'MARRIED', 1, 0) married,
          DECODE (marital_status, 'SINGLE', 1, 0) SINGLE,
          DECODE (marital_status, 'WIDOW', 1, 'WIDOWED', 1, 0) widow,
          DECODE (marital_status, 'SEPERATED', 1, 0) seperated,
          DECODE (dd.designation_id,
                  'TEACHER', 1,
                  'MUSIC TEACHER', 1,
                  'ART TEACHER', 0,
                  'COMPUTER TEACHER', 1,
                  0
                 ) teacher,
          DECODE (dd.designation_id,
                  'TEACHER', 0,
                  'MUSIC TEACHER', 0,
                  'ART TEACHER', 0,
                  'COMPUTER TEACHER', 0,
                  1
                 ) non_teacher,
          hr_service_age (doj) service_age, hr_service_age (dob) age,
          e.cur_coa_main_id, e.cur_coa_sub_id, e.cur_coa_id, e.employee_type,
          e.advance_20th, e.page_no, e.coa_main_id, e.provident_bank_ac,
          e.coa_sub_id, e.coa_id, e.bank_id, e.bank_account, e.bank_city_id,
          e.experience, ef.ot_allowed, e.income_tax_amount, e.ss_no,
          e.eobi_no, e.blood_group, e.marital_status, e.gate_employee_no,
          e.employee_id, e.NAME, e.fname, e.address1, e.address2,
          e.NAME || ' / ' || e.fname namefname, e.nid_no nic, e.nid_no,
          e.religion, ef.salary_group
-- ,e.SEX
          , e.status_id, e.doj, TO_CHAR (doj, 'MON yyyy') joining_month,
          e.dol, TO_CHAR (dol, 'MON yyyy') leaving_month
-- ,e.REMARKS
          , e.REFERENCE, e.address1 || ' ' || address2 address,
          dd.designation_id designation, dd.designation_id,
          dd.department_id department, dd.department_id, dd.grade, d.order_by,
          0 grosssalary
-- ,e.PROBATION
-- ,e.MARITALSTATUS
          , e.dob
-- ,e.JOBTYPE
-- ,e.QUALIFICATION
-- ,e.LEDGERCODE
          , e.city_id, e.country_id
-- ,e.TEL
          , e.email,  ----ef.basic_salary, ef.house_rent hrent, ef.house_rent,
                           ---ef.convy,
                         ---  ef.utiltiy utilitie, ef.fixed_ot, ef.utiltiy utility,
                    -----------       (ef.basic_salary + ef.house_rent + ef.utiltiy) net_salary,
          0 gross_salary,
                         ---    (SYSDATE - e.doc) service_age,
                         doc,                  --- ef.ot_rate, ef.absent_rate,
                             e.gender, e.old_nic, e.family_code,
          
          --e.insert_by, e.insert_date,     e.insert_term, e.last_updated_by, e.last_updated_date,  e.last_updated_term,
          0 salary_advance_balance, 0 cell
     FROM hr_employee e,
          hr_emp_latest_dept_desig_view dd,
          hr_emp_latest_fin_view ef,
          hr_emp_latest_qualif_view q,
          hr_department d,
          hr_emp_fin_latest_view2 ef2
    WHERE e.employee_id = dd.employee_id(+)
      AND e.employee_id = ef.employee_id(+)
      AND dd.department_id = d.department_id(+)
      AND e.employee_id = q.employee_id(+)
      AND e.employee_id = ef2.employee_id(+);   
 ---------------------------
 
 CREATE OR REPLACE FORCE VIEW hr_employee_latest_shift 
AS
   SELECT f.employee_id, f.hr_shift_id, sf.in_time, sf.out_time, sf.rest_day
     FROM hr_employee_shift f,
          (SELECT   employee_id, MAX (fdatetime) fdatetime
               FROM hr_employee_shift
           GROUP BY employee_id) dt,
          hr_shift sf
    WHERE f.fdatetime = dt.fdatetime
      AND f.employee_id = dt.employee_id
      AND f.hr_shift_id = sf.hr_shift_id;     
      
----------------------

CREATE OR REPLACE FORCE VIEW hr_employee_latest_late_policy 
AS
   SELECT f.employee_id, f.hr_late_id, lt.daily_max_late, lt.monthly_max_late
     FROM hr_employee_late_policy f,
          (SELECT   employee_id, MAX (fdatetime) fdatetime
               FROM hr_employee_late_policy
           GROUP BY employee_id) dt,
          hr_late lt
    WHERE f.fdatetime = dt.fdatetime
      AND f.employee_id = dt.employee_id
      AND f.hr_late_id = lt.hr_late_id;
 ----------------------------------------------------
 CREATE OR REPLACE FUNCTION hr_net_payable_days(e number, m date) RETURN NUMBER IS
tmpVar NUMBER;
lm number:=0;
am number:=0;
ans number:=0;
x number := 0;
sp varchar2(50);
md number;
/******************************************************************************
   NAME:       net_late_minutes
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/6/2013          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     net_late_minutes
      Sysdate:         10/6/2013
      Date and Time:   10/6/2013, 10:34:36 PM, and 10/6/2013 10:34:36 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
   select service_provider into sp from hr_employee where employee_id = e;
   
   md := nvl(to_number(to_char(last_day(m),'dd')),0);
   
   if (sp = 'YES') then
     ans := md;
   --elsif (sp = 'NO') then
     --ans := 99;
   --elsif  (sp is null) then
     --ans := 67;   
   else
     null;
     select sum(present)+sum(rest)+sum(leave)+SUM(GH) into ans from hr_attendance_view 
     where employee_id = e and to_char(attendance_date,'mmyyyy') = to_char(m,'mmyyyy');
     
     --lm := round(((net_late_minutes(e,m))/60)/8,2);   
   
     --if (ans < 0) then ans := 0; else ans := ans - lm; end if;
     
   end if; 
   
   
   tmpVar := 0;
   RETURN ans;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END hr_net_payable_days;     
---------------------------
CREATE OR REPLACE FUNCTION hr_net_late_minutes(e number, m date) RETURN NUMBER IS
tmpVar NUMBER;
lm number:=0;
am number:=0;
ans number:=0;
x number := 0;
SP NUMBER;
/******************************************************************************
   NAME:       net_late_minutes
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/6/2013          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     net_late_minutes
      Sysdate:         10/6/2013
      Date and Time:   10/6/2013, 10:34:36 PM, and 10/6/2013 10:34:36 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
	--SELECT OT_ALLOWED INTO SP FROM employee_latest_financial_view WHERE EMPLOYEE_ID=E;
	--IF (SP='1') THEN
	
   select MIN_TO_HOUR(sum(TRUNC(late)*60 + MOD(late,TRUNC(late))*100)) into lm 
   from hr_attendance 
   where employee_id = e and to_char(attendance_date,'mmyyyy')=to_char(m,'mmyyyy');
   
   select count(*) into x from hr_employee_latest_late_policy where e in (select employee_id from hr_employee_latest_late_policy);
   if (x > 0) then
    select monthly_max_late into am from hr_employee_latest_late_policy
    where employee_id = e;
   end if; 
   
   --ans := TO_NUMBER(lm,'09.00');
   --END IF;
   if (ans < 0) then ans := 0; end if;
   tmpVar := 0;
   RETURN LM;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END hr_net_late_minutes;
----------------------------------------

           



