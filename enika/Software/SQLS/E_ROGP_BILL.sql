 ALTER TABLE INV_ROGP_BILL
 DROP PRIMARY KEY CASCADE;
 
DROP TABLE INV_ROGP_BILL CASCADE CONSTRAINTS;

CREATE TABLE INV_ROGP_BILL
(
  BILL_ID      NUMBER,
  BILL_DATE    DATE                             NOT NULL,
  STATUS       VARCHAR2(10 BYTE)                NOT NULL,
  SUPPLIER_ID  NUMBER                           NOT NULL,
  USER_ID      VARCHAR2(20 BYTE)                NOT NULL,
  FDATETIME    DATE                             NOT NULL,
  --PO_ID        NUMBER                           NOT NULL,
  VOUCHER_SEQ  NUMBER
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


CREATE UNIQUE INDEX INV_ROGP_BILL_PK ON INV_ROGP_BILL
(BILL_ID)
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


ALTER TABLE INV_ROGP_BILL ADD (
  CONSTRAINT INV_ROGP_BILL_PK
 PRIMARY KEY
 (BILL_ID)
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
     ----------------------------------------------------
     
     DROP TABLE INV_ROGP_BILL_DET CASCADE CONSTRAINTS;

CREATE TABLE INV_ROGP_BILL_DET
(
  BILL_ID        NUMBER,
  ROGP_DETAIL_ID  NUMBER
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


ALTER TABLE INV_ROGP_BILL_DET ADD (
  UNIQUE (ROGP_DETAIL_ID)
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

ALTER TABLE INV_ROGP_BILL_DET ADD (
  CONSTRAINT INV_ROGP_BILL_FK 
 FOREIGN KEY (BILL_ID) 
 REFERENCES INV_ROGP_BILL (BILL_ID));        
 ----------------------------------------------------------------  
 CREATE SEQUENCE ENIKA.INV_ROGP_BILL_SEQ
START WITH 0
INCREMENT BY 1
MINVALUE 0
NOCACHE 
NOCYCLE 
NOORDER 