CREATE SEQUENCE PROD_JCD_SEQ;
CREATE SEQUENCE PROD_JC_SEQ;

ALTER TABLE ADDOS.EXP_CUSTOMER MODIFY(STATUS_ID NUMBER NULL);
UPDATE ADDOS.EXP_CUSTOMER SET STATUS_ID=NULL;
ALTER TABLE ADDOS.EXP_CUSTOMER MODIFY(STATUS_ID VARCHAR2(10));
UPDATE ADDOS.EXP_CUSTOMER SET STATUS_ID='RELEASE';
ALTER TABLE ADDOS.EXP_CUSTOMER MODIFY(STATUS_ID VARCHAR2(10) NOT NULL);

ALTER TABLE ADDOS.ADM_CURRENCY DROP COLUMN INSERT_BY;
ALTER TABLE ADDOS.ADM_CURRENCY DROP COLUMN INSERT_DATE;
ALTER TABLE ADDOS.ADM_CURRENCY DROP COLUMN INSERT_TERM;
ALTER TABLE ADDOS.ADM_CURRENCY DROP COLUMN LAST_UPDATED_BY;
ALTER TABLE ADDOS.ADM_CURRENCY DROP COLUMN LAST_UPDATED_DATE;
ALTER TABLE ADDOS.ADM_CURRENCY DROP COLUMN LAST_UPDATED_TERM;

CREATE OR REPLACE FUNCTION inv_preq_qty_without_po(c number)
 RETURN NUMBER IS
tmpVar NUMBER;
/******************************************************************************
   NAME:       preq_qty_without_po
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        9/28/2013          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     preq_qty_without_po
      Sysdate:         9/28/2013
      Date and Time:   9/28/2013, 11:57:11 AM, and 9/28/2013 11:57:11 AM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
tmpVar := 0;
select sum(r.qty) into tmpVar
from inv_preq_det r,
     inv_po_detail_view p
where r.sc_id = p.sc_id(+)
 and r.preq_id = p.preq_id(+)
 and r.preq_year = p.preq_year(+)
 and P.PO_QUANTITY is null
 and r.sc_id = c;
 
 --group by R.sc_main_id, R.SC_sub_id, R.sc_id
   
   RETURN tmpVar;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END inv_preq_qty_without_po;
/
CREATE OR REPLACE FUNCTION inv_po_qty_without_igp(c number)
RETURN NUMBER IS
tmpVar NUMBER;
/******************************************************************************
   NAME:       po_qty_without_igp
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        9/28/2013          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     po_qty_without_igp
      Sysdate:         9/28/2013
      Date and Time:   9/28/2013, 12:09:42 PM, and 9/28/2013 12:09:42 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
   tmpVar := 0;
   select sum(p.po_quantity) into tmpVar
   from inv_po_detail p,
     inv_igp_detail_view i
  where P.PO_ID = i.po_id(+)
  ---and p.po_year = i.po_year(+)
  and p.po_type = i.po_type(+)
  and p.po_detail_id = i.po_detail_id(+)
  and (i.accepted_qty is null or i.accepted_qty = 0)
  and p.sc_id = c;
  

   RETURN tmpVar;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END inv_po_qty_without_igp;
/
CREATE OR REPLACE FUNCTION inv_igp_qty_without_gir(c number)
RETURN NUMBER IS
tmpVar NUMBER;
/******************************************************************************
   NAME:       igp_qty_without_gir
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        9/28/2013          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     igp_qty_without_gir
      Sysdate:         9/28/2013
      Date and Time:   9/28/2013, 12:20:17 PM, and 9/28/2013 12:20:17 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
   tmpVar := 0;
   select sum(accepted_qty) into tmpVar from inv_igp_detail_view
  where gir_id is null and po_id is not null and sc_id = c;
  
  -- group by sc_main_id, sc_sub_id, sc_id
   RETURN tmpVar;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END inv_igp_qty_without_gir;
/
-----------------------------
alter table hr_employee add (english_name varchar2(100));
alter table hr_employee add (salary_adv_coa_seq number, loan_coa_seq number, salary_coa_seq number, salary_payable_coa_seq number);
------------------------------
ALTER TABLE HR_SAL_ADV_CONT
 DROP PRIMARY KEY CASCADE;
DROP TABLE HR_SAL_ADV_CONT CASCADE CONSTRAINTS;

CREATE TABLE HR_SAL_ADV_CONT
(
  AMOUNT           NUMBER(10,4)                 NOT NULL,
  COA_SEQ          NUMBER(6),
  EMPLOYEE_ID      NUMBER(6),
  STATUS_ID        VARCHAR2(16 BYTE)            NOT NULL,
  SAL_CONT_ID      DATE,
  USER_ID          VARCHAR2(20 BYTE),
  FDATETIME        DATE,
  REASON           VARCHAR2(100 BYTE)           NOT NULL,
  SAL_ADV_CONT_ID  NUMBER(6),
  LOAN_TYPE        VARCHAR2(5 BYTE)             DEFAULT 'WA',
  VOUCHER_SEQ      NUMBER(9)
)
TABLESPACE ORACUBES
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          256K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX SAL_CONT_ADV_PK ON HR_SAL_ADV_CONT
(SAL_ADV_CONT_ID)
LOGGING
TABLESPACE ORACUBES
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE HR_SAL_ADV_CONT ADD (
  CONSTRAINT SALCONT_ADV_STS_CHK
 CHECK (status_id in ('HOLD','RELEASE')),
  CONSTRAINT SAL_CONT_ADV_PK
 PRIMARY KEY
 (SAL_ADV_CONT_ID)
    USING INDEX 
    TABLESPACE ORACUBES
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          128K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ));

ALTER TABLE HR_SAL_ADV_CONT ADD (
  CONSTRAINT SALCOA_ADVANCE_COA_FK 
 FOREIGN KEY (COA_SEQ) 
 REFERENCES AC_COA (COA_SEQ),
  CONSTRAINT SALCONT_ADVANCE_EMP_FK 
 FOREIGN KEY (EMPLOYEE_ID) 
 REFERENCES HR_EMPLOYEE (EMPLOYEE_ID),
  CONSTRAINT SALCONT_ADV_USER_FK 
 FOREIGN KEY (USER_ID) 
 REFERENCES ADM_USERS (USER_ID));
-------------------------------- 
CREATE OR REPLACE FORCE VIEW ac_voc_detail_summary_view1 (voucher_no,
                                                                  voucher_type_id,
                                                                  voucher_id,
                                                                  voucher_month_id,
                                                                  voucher_date,
                                                                  status_id,
                                                                  gir_id,
                                                                  gir_year,
                                                                  loan_id,
                                                                  loan_type,
                                                                  employee_id,
                                                                  salary_group_id,
                                                                  salary_id,
                                                                  pr_id,
                                                                  pr_year,
                                                                  dr_amount,
                                                                  cr_amount,
                                                                  diff
                                                                 )
AS
   SELECT      short_voucher_type
            || '/'
            || voucher_id
            || '/'
            || TO_CHAR (voucher_month_id, 'mon yy') voucher_no,
            voucher_type_id, voucher_id, voucher_month_id, voucher_date,
            status_id, gir_id, gir_year, loan_id, loan_type, employee_id,
            salary_group_id, salary_id, pr_id, pr_year,
            SUM (dr_amount) dr_amount, SUM (cr_amount) cr_amount,
            SUM (dr_amount) - SUM (cr_amount) diff
       FROM ac_voucher_detail_view
   GROUP BY short_voucher_type,
            voucher_type_id,
            voucher_id,
            voucher_month_id,
            status_id,
            gir_id,
            gir_year,
            loan_id,
            loan_type,
            employee_id,
            salary_group_id,
            salary_id,
            voucher_date,
            pr_id,
            pr_year;
--------------------------------
CREATE OR REPLACE FORCE VIEW hr_sal_adv_cont_view (voucher_seq,
                                                           employee_id,
                                                           fdatetime,
                                                           reason,
                                                           user_id,
                                                           amount,
                                                           sav_status,
                                                           sal_adv_cont_id,
                                                           NAME,
                                                           employee_status,
                                                           status_desc,
                                                           voucher_no,
                                                           voucher_id,
                                                           voucher_type_id,
                                                           voucher_month_id
                                                          )
AS
   SELECT sa.voucher_seq, sa.employee_id, sa.fdatetime, sa.reason, sa.user_id,
          sa.amount, sa.status_id sav_status, sa.sal_adv_cont_id, e.NAME,
          e.status_id employee_status, e.status_id status_desc, voucher_no,
          voucher_id, voucher_type_id, voucher_month_id
     FROM hr_sal_adv_cont sa, hr_employee e, ac_voc_detail_summary_view1 v
    WHERE sa.employee_id = e.employee_id
      AND sa.sal_adv_cont_id = v.loan_id(+)
      AND sa.loan_type = v.loan_type(+);
------------------------------
CREATE OR REPLACE FORCE VIEW hr_sal_cont_view (acv,
                                                       ajv,
                                                       fdatetime,
                                                       sal_cont_id,
                                                       sal_cont_no,
                                                       status_id,
                                                       user_id,
                                                       earning,
                                                       fine,
                                                       loan_closing,
                                                       loan_ded,
                                                       loan_opening,
                                                       salary,
                                                       salary_advance
                                                      )
AS
   SELECT   sc.acv, sc.ajv, sc.fdatetime, sc.sal_cont_id, sc.sal_cont_no,
            sc.status_id, sc.user_id, SUM (scd.earning) earning,
            SUM (scd.fine) fine, SUM (scd.loan_closing) loan_closing,
            SUM (scd.loan_ded) loan_ded, SUM (scd.loan_opening) loan_opening,
            SUM (scd.salary) salary, SUM (scd.salary_advance) salary_advance
       FROM hr_sal_cont sc, hr_sal_cont_detail scd
      WHERE sc.sal_cont_id = scd.sal_cont_id
        AND sc.sal_cont_no = scd.sal_cont_no
   GROUP BY sc.acv,
            sc.ajv,
            sc.fdatetime,
            sc.sal_cont_id,
            sc.sal_cont_no,
            sc.status_id,
            sc.user_id;    
----------------------
CREATE OR REPLACE FORCE VIEW jillani.hr_employee_view (monthly_max_late,
                                                       service_provider,
                                                       absent_rate,
                                                       english_name,
                                                       urdu_english,
                                                       qualification_id,
                                                       service_age2,
                                                       age2,
                                                       ntn,
                                                       muslim,
                                                       christian,
                                                       hindu,
                                                       male,
                                                       female,
                                                       married,
                                                       SINGLE,
                                                       widow,
                                                       seperated,
                                                       teacher,
                                                       non_teacher,
                                                       service_age,
                                                       age,
                                                       cur_coa_main_id,
                                                       cur_coa_sub_id,
                                                       cur_coa_id,
                                                       employee_type,
                                                       advance_20th,
                                                       page_no,
                                                       coa_main_id,
                                                       provident_bank_ac,
                                                       coa_sub_id,
                                                       coa_id,
                                                       bank_id,
                                                       bank_account,
                                                       bank_city_id,
                                                       experience,
                                                       ot_allowed,
                                                       income_tax_amount,
                                                       ss_no,
                                                       eobi_no,
                                                       blood_group,
                                                       marital_status,
                                                       gate_employee_no,
                                                       employee_id,
                                                       NAME,
                                                       fname,
                                                       address1,
                                                       address2,
                                                       namefname,
                                                       nic,
                                                       nid_no,
                                                       religion,
                                                       salary_group,
                                                       status_id,
                                                       doj,
                                                       joining_month,
                                                       dol,
                                                       leaving_month,
                                                       REFERENCE,
                                                       address,
                                                       designation,
                                                       designation_id,
                                                       department,
                                                       department_id,
                                                       grade,
                                                       order_by,
                                                       grosssalary,
                                                       net_salary,
                                                       deduction,
                                                       dob,
                                                       city_id,
                                                       country_id,
                                                       email,
                                                       gross_salary,
                                                       doc,
                                                       gender,
                                                       old_nic,
                                                       family_code,
                                                       salary_advance_balance,
                                                       cell
                                                      )
AS
   SELECT 0 monthly_max_late, 'NO' service_provider, 0 absent_rate,
          e.english_name, e.english_name || ' ' || e.NAME urdu_english,
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
          ef2.gross grosssalary, ef2.net_salary net_salary,
          ef2.deduction deduction, e.dob, e.city_id, e.country_id, e.email,
          ef2.earning gross_salary, doc, e.gender, e.old_nic, e.family_code,
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
