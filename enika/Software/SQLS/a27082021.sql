
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
 
 create or replace view inv_rogp_bill_det_view
as
select b.BILL_DATE, b.BILL_ID, b.FDATETIME, b.STATUS bill_status, b.SUPPLIER_ID, b.USER_ID, b.VOUCHER_SEQ,
bd.igp_detail_id,
i.ACCEPTED_QTY, i.AMOUNT,     i.IGP, i.IGP_DATE, i.IGP_ID, i.IGP_TYPE, i.IGP_YEAR,   i.PAYMENT_STATUS, i.REMARKS, i.STATUS_ID,  
i.TAKEN_IN_BY, i.TAKEN_IN_DATETIME,  i.VEHICLE_NO, i.VEHICLE_TYPE, ac.description supplier     
from inv_rogp_bill b,
       inv_rogp_bill_det bd,
       inv_igp_detail_view i,
       ac_coa ac
where b.BILL_ID = bd.BILL_ID    
    and bd.IGP_DETAIL_ID = i.IGP_DETAIL_ID
   and  b.SUPPLIER_ID = ac.coa_seq     ;
    
create or replace  view inv_rogp_bill_view
as   
select sum(v.ACCEPTED_QTY) accepted_qty, sum(v.AMOUNT) amount, v.BILL_DATE, v.BILL_ID,  v.bill_status, count(*) Items,
          v.SUPPLIER_ID, ac.description supplier
          from inv_rogp_bill_det_view v,
                 ac_coa ac
where v.SUPPLIER_ID = ac.coa_seq                 
                 
group by  v.BILL_DATE, v.BILL_ID, v.BILL_STATUS, v.supplier_id, ac.description  