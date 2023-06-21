alter table hr_employee add(salary_adv_coa_seq number, loan_coa_seq number, salary_coa_seq number, salary_payable_coa_seq number);
hr_employee_view;
CREATE OR REPLACE FORCE VIEW hr_sal_cont_detail_view (sal_cont_id
,                                                             employee_id
,                                                             NAME
,                                                             fname
,                                                             salary
,                                                             loan_ded
,                                                             tot_loans
,                                                             salary_advance
,                                                             tot_sal_advances
,                                                             net
,                                                             loan_opening
,                                                             loan_closing
,                                                             status_id
,                                                             ajv
,                                                             net_payable
,                                                             acv
,                                                             paid
,                                                             balance
                                                             )
AS
   SELECT c.sal_cont_id, cd.employee_id, cd.NAME, cd.fname, salary, loan_ded
,         tot_loans, salary_advance, tot_sal_advances
,         salary - loan_ded - salary_advance net, loan_opening, loan_closing
,         cd.status_id, ajv
,         DECODE (ajv
,                 NULL, 0
,                 (salary - loan_ded - salary_advance)
                 ) net_payable
,         acv
,         DECODE (acv, NULL, 0, (salary - loan_ded - salary_advance)) paid
,           DECODE (ajv
,                   NULL, 0
,                   (salary - loan_ded - salary_advance)
                   )
          - DECODE (acv, NULL, 0, (salary - loan_ded - salary_advance))
                                                                      balance
     FROM hr_sal_cont c, hr_sal_cont_detail cd
    WHERE c.sal_cont_id = cd.sal_cont_id AND c.sal_cont_no = cd.sal_cont_no;
    ---------------------
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
 
 CREATE OR REPLACE FORCE VIEW hr_sal_cont_view (acv
,                                                      ajv
,                                                      fdatetime
,                                                      sal_cont_id
,                                                      sal_cont_no
,                                                      status_id
,                                                      user_id
,                                                      earning
,                                                      fine
,                                                      loan_closing
,                                                      loan_ded
,                                                      loan_opening
,                                                      salary
,                                                      salary_advance
                                                      )
AS
   SELECT   sc.acv, sc.ajv, sc.fdatetime, sc.sal_cont_id, sc.sal_cont_no
,           sc.status_id, sc.user_id, SUM (scd.earning) earning
,           SUM (scd.fine) fine, SUM (scd.loan_closing) loan_closing
,           SUM (scd.loan_ded) loan_ded, SUM (scd.loan_opening) loan_opening
,           SUM (scd.salary) salary, SUM (scd.salary_advance) salary_advance
       FROM hr_sal_cont sc, hr_sal_cont_detail scd
      WHERE sc.sal_cont_id = scd.sal_cont_id
        AND sc.sal_cont_no = scd.sal_cont_no
   GROUP BY sc.acv
,           sc.ajv
,           sc.fdatetime
,           sc.sal_cont_id
,           sc.sal_cont_no
,           sc.status_id
,           sc.user_id;


