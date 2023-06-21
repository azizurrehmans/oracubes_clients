ALTER TABLE ADDOS.INV_IGP_EXPENSE
 DROP PRIMARY KEY CASCADE;
DROP TABLE ADDOS.INV_IGP_EXPENSE CASCADE CONSTRAINTS;

CREATE TABLE ADDOS.INV_IGP_EXPENSE
(
  IGP_ID      NUMBER(6)                         NOT NULL,
  EXPENSE_ID  VARCHAR2(50 BYTE),
  AMOUNT      NUMBER(6),
  PAID_BY     VARCHAR2(50 BYTE)
)
TABLESPACE ORACUBES
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2M
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


CREATE UNIQUE INDEX ADDOS.INV_IGP_EXPENSE_PK ON ADDOS.INV_IGP_EXPENSE
(IGP_ID, EXPENSE_ID)
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


ALTER TABLE ADDOS.INV_IGP_EXPENSE ADD (
  CONSTRAINT INV_IGP_EXPENSE_PK
 PRIMARY KEY
 (IGP_ID, EXPENSE_ID)
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

