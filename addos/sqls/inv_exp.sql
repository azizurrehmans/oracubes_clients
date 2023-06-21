ALTER TABLE ADDOS.INV_EXPENSE
 DROP PRIMARY KEY CASCADE;
DROP TABLE ADDOS.INV_EXPENSE CASCADE CONSTRAINTS;

CREATE TABLE ADDOS.INV_EXPENSE
(
  INV_EXPENSE_ID  NUMBER,
  DESCRIPTION     VARCHAR2(100 BYTE)            NOT NULL,
  COA_SEQ         NUMBER,
  USER_ID         VARCHAR2(20 BYTE)             NOT NULL,
  FDATETIME       DATE                          NOT NULL
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


CREATE UNIQUE INDEX ADDOS.INV_EXPENSE_PK ON ADDOS.INV_EXPENSE
(INV_EXPENSE_ID)
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


CREATE UNIQUE INDEX ADDOS.INV_EXPENSE_DESC_UQ ON ADDOS.INV_EXPENSE
(DESCRIPTION)
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


ALTER TABLE ADDOS.INV_EXPENSE ADD (
  CONSTRAINT INV_EXPENSE_PK
 PRIMARY KEY
 (INV_EXPENSE_ID)
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
               ),
  CONSTRAINT INV_EXPENSE_DESC_UQ
 UNIQUE (DESCRIPTION)
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

ALTER TABLE ADDOS.INV_EXPENSE ADD (
  CONSTRAINT INV_EXPENSE_COA_SEQ_FK 
 FOREIGN KEY (COA_SEQ) 
 REFERENCES ADDOS.AC_COA (COA_SEQ),
  CONSTRAINT INV_EXPENSE_USER_FK 
 FOREIGN KEY (USER_ID) 
 REFERENCES ADDOS.ADM_USERS (USER_ID));

