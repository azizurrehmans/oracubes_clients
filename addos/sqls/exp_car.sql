ALTER TABLE ADDOS.EXP_CARTON
 DROP PRIMARY KEY CASCADE;
DROP TABLE ADDOS.EXP_CARTON CASCADE CONSTRAINTS;

CREATE TABLE ADDOS.EXP_CARTON
(
  CARTON_ID    NUMBER                           NOT NULL,
  CUSTOMER_ID  NUMBER                           NOT NULL,
  ITEM_ID      NUMBER                           NOT NULL,
  FDATETIME    DATE                             NOT NULL,
  STATUS       VARCHAR2(20 BYTE)                NOT NULL,
  USER_ID      VARCHAR2(20 BYTE)                NOT NULL
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


CREATE UNIQUE INDEX ADDOS.EXP_CARTON_PK1 ON ADDOS.EXP_CARTON
(ITEM_ID)
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


ALTER TABLE ADDOS.EXP_CARTON ADD (
  CONSTRAINT EXP_CARTON_PK
 PRIMARY KEY
 (ITEM_ID));

