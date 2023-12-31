ALTER TABLE ADDOS.HR_SALARY_TEMP
 ADD (SHORT_HRS  NUMBER(5,2));

ALTER TABLE ADDOS.HR_SALARY_TEMP
 ADD (SHORT_AMT  NUMBER);

ALTER TABLE ADDOS.HR_SALARY_TEMP DROP COLUMN CJM;

ALTER TABLE ADDOS.HR_SALARY_TEMP DROP COLUMN COMP;

ALTER TABLE ADDOS.HR_SALARY_TEMP DROP COLUMN GUN;

ALTER TABLE ADDOS.HR_SALARY_TEMP DROP COLUMN MEDI;

ALTER TABLE ADDOS.HR_SALARY_TEMP DROP COLUMN SCIENCE;

ALTER TABLE ADDOS.HR_SALARY_TEMP DROP COLUMN BANK_LETTER_DATE;

ALTER TABLE ADDOS.HR_SALARY_TEMP DROP COLUMN TAX_PAYMENT_DATE;

ALTER TABLE ADDOS.HR_SALARY_TEMP DROP COLUMN TAX_PAYMENT_AMT;

----------------
ALTER TABLE ADDOS.HR_SALARY_FINE
 DROP PRIMARY KEY CASCADE;
DROP TABLE ADDOS.HR_SALARY_FINE CASCADE CONSTRAINTS;

CREATE TABLE ADDOS.HR_SALARY_FINE
(
  AMOUNT            NUMBER(10,4)                NOT NULL,
  EMPLOYEE_ID       NUMBER(6),
  STATUS_ID         VARCHAR2(16 BYTE)           NOT NULL,
  SALARY_ID         DATE,
  USER_ID           VARCHAR2(20 BYTE),
  FDATETIME         DATE,
  REASON            VARCHAR2(100 BYTE)          NOT NULL,
  VOUCHER_SEQ       NUMBER(9),
  SALARY_FINE_DATE  DATE
)
TABLESPACE ORACUBES
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
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


CREATE UNIQUE INDEX ADDOS.HR_SALARY_FINE_PK ON ADDOS.HR_SALARY_FINE
(EMPLOYEE_ID, SALARY_ID, FDATETIME)
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
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE ADDOS.HR_SALARY_FINE ADD (
  CONSTRAINT HR_SALARY_FINE_AMT_CHK
 CHECK (amount is not null and amount > 0),
  CONSTRAINT HR_SALARY_FINE_STS_CHK
 CHECK (status_id in ('HOLD','RELEASE')),
  CONSTRAINT HR_SALARY_FINE_PK
 PRIMARY KEY
 (EMPLOYEE_ID, SALARY_ID, FDATETIME)
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
                FREELISTS        1
                FREELIST GROUPS  1
               ));
----------------
ALTER TABLE ADDOS.HR_SALARY_INCENTIVE
 DROP PRIMARY KEY CASCADE;
DROP TABLE ADDOS.HR_SALARY_INCENTIVE CASCADE CONSTRAINTS;

CREATE TABLE ADDOS.HR_SALARY_INCENTIVE
(
  AMOUNT                 NUMBER(10,4)           NOT NULL,
  EMPLOYEE_ID            NUMBER(6),
  STATUS_ID              VARCHAR2(16 BYTE)      NOT NULL,
  SALARY_ID              DATE,
  USER_ID                VARCHAR2(20 BYTE),
  FDATETIME              DATE,
  REASON                 VARCHAR2(100 BYTE)     NOT NULL,
  VOUCHER_SEQ            NUMBER(9),
  SALARY_INCENTIVE_DATE  DATE                   NOT NULL
)
TABLESPACE ORACUBES
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
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


CREATE UNIQUE INDEX ADDOS.HR_SALARY_INCENTIVE_PK ON ADDOS.HR_SALARY_INCENTIVE
(EMPLOYEE_ID, SALARY_ID, FDATETIME)
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
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE ADDOS.HR_SALARY_INCENTIVE ADD (
  CONSTRAINT HR_SALARY_INCENTIVE_STS_CHK
 CHECK (status_id in ('HOLD','RELEASE')),
  CONSTRAINT HR_SALARY_INCENTIVE_AMT_CHK
 CHECK (amount is not null and amount > 0),
  CONSTRAINT HR_SALARY_INCENTIVE_PK
 PRIMARY KEY
 (EMPLOYEE_ID, SALARY_ID, FDATETIME)
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
                FREELISTS        1
                FREELIST GROUPS  1
               ));
----------------

CREATE OR REPLACE VIEW HR_SALARY_DETAIL_EMP_VIEW 
AS
SELECT E.ALLOWANCE_ID, E.AMOUNT, E.DAYS, E.DESCRIPTION, E.EMPLOYEE_ID, E.REMARKS, E.SALARY_ID, 0 COA_SEQ, A.EFFECT
FROM HR_SALARY_DETAIL_EMP E,
          HR_ALLOWANCE A
WHERE E.ALLOWANCE_ID =A.ALLOWANCE_ID     
