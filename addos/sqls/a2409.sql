ALTER TABLE INV_IGP DROP PRIMARY KEY CASCADE;
DROP TABLE INV_IGP CASCADE CONSTRAINTS;

CREATE TABLE INV_IGP
(
  IGP_ID                NUMBER(6)               NOT NULL,
  IGP_YEAR              VARCHAR2(5 BYTE)        NOT NULL,
  IGP_DATE              DATE                    NOT NULL,
  IGP_TYPE              VARCHAR2(20 BYTE)       NOT NULL,
  PO_ID                 VARCHAR2(20 BYTE),
  PO_YEAR               VARCHAR2(5 BYTE),
  REMARKS               VARCHAR2(120 BYTE),
  VEHICLE_TYPE          VARCHAR2(20 BYTE),
  VEHICLE_NO            VARCHAR2(20 BYTE),
  TAKEN_IN_BY           VARCHAR2(50 BYTE),
  FREIGHT               NUMBER(15),
  OCTROI                NUMBER(15),
  STATUS_ID             VARCHAR2(10 BYTE)       DEFAULT 0                     NOT NULL,
  FDATETIME             DATE                    DEFAULT sysdate               NOT NULL,
  EMPLOYEE_ID           NUMBER(6),
  TAKEN_IN_DATETIME     DATE,
  SUPPLIER              VARCHAR2(100 BYTE),
  PAYMENT_STATUS        VARCHAR2(1 BYTE),
  BILL_OR_VOUCHER_DATE  DATE,
  BILL_OR_VOUCHER_NO    VARCHAR2(50 BYTE),
  PO_TYPE               VARCHAR2(15 BYTE),
  SUPPLIER_ID           NUMBER(5),
  USER_ID               VARCHAR2(20 BYTE)       NOT NULL,
  OGP_ID                NUMBER,
  OGP_YEAR              VARCHAR2(6 BYTE),
  WO_YEAR               VARCHAR2(5 BYTE),
  WO_ID                 NUMBER,
  WO_VOUCHER_SEQ        NUMBER,
  OGP_VOUCHER_SEQ       NUMBER,
  IGP_YEARLY_ID         NUMBER,
  GST                   NUMBER,
  BILL_NO               VARCHAR2(50 BYTE),
  BILL_DATE             DATE,
  VOUCHER_SEQ           NUMBER
)
TABLESPACE oracubes
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
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX INV_IGP_PK ON INV_IGP
(IGP_ID)
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


CREATE UNIQUE INDEX INV_IGP_UK ON INV_IGP
(IGP_YEAR, IGP_YEARLY_ID)
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


ALTER TABLE INV_IGP ADD (
  CONSTRAINT IGP_TYPE_CHECK
 CHECK (IGP_TYPE IN ('GENERAL','AGAINST ROGP','AGAINST PO','AGAINST RC','AGAINST WO')),
  CONSTRAINT INV_IGP_PK
 PRIMARY KEY
 (IGP_ID)
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
               ),
  CONSTRAINT INV_IGP_UK
 UNIQUE (IGP_YEAR, IGP_YEARLY_ID)
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

ALTER TABLE INV_IGP ADD (
  CONSTRAINT IGP_USER_FK 
 FOREIGN KEY (USER_ID) 
 REFERENCES ADM_USERS (USER_ID));
---------------------------------
ALTER TABLE INV_IGP_DETAIL DROP PRIMARY KEY CASCADE;
DROP TABLE INV_IGP_DETAIL CASCADE CONSTRAINTS;

CREATE TABLE INV_IGP_DETAIL
(
  IGP_ID            NUMBER(6)                   NOT NULL,
  IGP_DETAIL_ID     NUMBER(2)                   NOT NULL,
  ITEM_DESCRIPTION  VARCHAR2(200 BYTE),
  UNIT_ID           VARCHAR2(20 BYTE),
  SUPP_QTY          NUMBER(15,6)                NOT NULL,
  SHORT_QTY         NUMBER(15,6)                DEFAULT 0                     NOT NULL,
  REJECT_QTY        NUMBER(15,6)                DEFAULT 0                     NOT NULL,
  PO_ID             VARCHAR2(20 BYTE),
  PO_DETAIL_ID      NUMBER(6),
  PO_YEAR           VARCHAR2(5 BYTE),
  REMARKS           VARCHAR2(120 BYTE),
  OGP_ID            NUMBER(6),
  OGP_DETAIL_ID     NUMBER(2),
  OGP_YEAR          VARCHAR2(5 BYTE),
  PO_TYPE           VARCHAR2(15 BYTE),
  IGP_TYPE          VARCHAR2(15 BYTE),
  BREAKAGE          NUMBER(15)                  DEFAULT 0                     NOT NULL,
  WO_ID             NUMBER(5),
  WO_YEAR           VARCHAR2(5 BYTE),
  WO_DETAIL_ID      NUMBER(2),
  RATE              NUMBER,
  GIR_DETAIL_ID     NUMBER
)
TABLESPACE oracubes
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          3M
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


CREATE UNIQUE INDEX INV_IGP_DETAIL_PK ON INV_IGP_DETAIL
(IGP_DETAIL_ID)
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


ALTER TABLE INV_IGP_DETAIL ADD (
  CONSTRAINT INV_IGP_DETAIL_PK
 PRIMARY KEY
 (IGP_DETAIL_ID)
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

ALTER TABLE INV_IGP_DETAIL ADD (
  CONSTRAINT INV_IGP_DET_IGP_FK 
 FOREIGN KEY (IGP_ID) 
 REFERENCES INV_IGP (IGP_ID));
-------------------------------- 
CREATE SEQUENCE ADDOS.INV_IGP_DET_SEQ START WITH 0 INCREMENT BY 1 MINVALUE 0 NOCACHE NOCYCLE NOORDER; 
 

CREATE OR REPLACE FORCE VIEW igp_view                                   
AS
   SELECT i.igp_yearly_id || '/' || i.igp_year igp, '' gir_id, gst,
          s.currency_id currency, i.igp_yearly_id, i.bill_date, i.voucher_seq,
          igd.amount, i.bill_no, i.fdatetime, i.igp_date, i.igp_id,
          i.igp_type, i.igp_year, i.payment_status, i.remarks, i.status_id,
          i.supplier_id, s.description supplier, i.taken_in_by,
          i.taken_in_datetime, i.user_id, i.vehicle_no, i.vehicle_type,
          
          --i.voucher_seq,
          NULL ogp_id, igd.accepted_qty
     FROM inv_igp i,
          ac_coa s,
          (SELECT   SUM (accepted_qty) accepted_qty, SUM (amount) amount,
                    igp_id, igp_year
               FROM inv_igp_detail_view
           GROUP BY igp_id, igp_year) igd
    WHERE i.supplier_id = s.coa_seq(+) AND i.igp_id = igd.igp_id(+);
    
 --------------------------------------------------------------------------------
 ALTER TABLE INV_GIR  DROP PRIMARY KEY CASCADE;
DROP TABLE INV_GIR CASCADE CONSTRAINTS;

CREATE TABLE INV_GIR
(
  GIR_ID         NUMBER(6),
  GIR_DATE       DATE                           NOT NULL,
  REMARKS        VARCHAR2(120 BYTE)             NOT NULL,
  STATUS_ID      VARCHAR2(10 BYTE)              DEFAULT 'HOLD'                NOT NULL,
  FDATETIME      DATE                           DEFAULT sysdate               NOT NULL,
  PO_TYPE        VARCHAR2(15 BYTE)              NOT NULL,
  CANCEL_REASON  VARCHAR2(100 BYTE),
  USER_ID        VARCHAR2(20 BYTE)              NOT NULL,
  VOUCHER_SEQ    NUMBER(9),
  SUPPLIER_ID    NUMBER(6)
)
TABLESPACE ORACUBES
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          640K
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


ALTER TABLE INV_GIR ADD (
  PRIMARY KEY
 (GIR_ID)
    USING INDEX 
    TABLESPACE ORACUBES
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          192K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE INV_GIR ADD (
  CONSTRAINT GIR_USER_FK 
 FOREIGN KEY (USER_ID) 
 REFERENCES ADM_USERS (USER_ID));  
 
 --------------------------------------------------- 
 
 ALTER TABLE INV_GIR_DETAIL DROP PRIMARY KEY CASCADE;
DROP TABLE INV_GIR_DETAIL CASCADE CONSTRAINTS;

CREATE TABLE INV_GIR_DETAIL
(
  GIR_ID          NUMBER(6)                     NOT NULL,
  GIR_DETAIL_ID   NUMBER(6)                     NOT NULL,
  GIR_YEAR        VARCHAR2(5 BYTE),
  RECEIVING_DATE  DATE                          NOT NULL,
  BATCH_NO        VARCHAR2(20 BYTE),
  DHS_NO          VARCHAR2(5 BYTE),
  PO_DETAIL_ID    NUMBER(6),
  RECEIVED_QTY    NUMBER(10,3),
  REJECTED_QTY    NUMBER(10,3),
  RECEIVED_BY     NUMBER(6),
  INSPECTED_BY    NUMBER(6),
  LOT_STATUS      VARCHAR2(8 BYTE),
  RATE            NUMBER(15,6),
  IGP_ID          NUMBER(6),
  IGP_DETAIL_ID   NUMBER(2),
  IGP_YEAR        VARCHAR2(5 BYTE),
  SALES_TAX       NUMBER(15,6),
  FREIGHT         NUMBER(15,6)
)
TABLESPACE oracubes
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          640K
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


CREATE UNIQUE INDEX GIR_DET_IGP_UK ON INV_GIR_DETAIL
(IGP_ID, IGP_DETAIL_ID, IGP_YEAR)
LOGGING
TABLESPACE oracubes
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          320K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX INV_GIR_DETAIL_PK ON INV_GIR_DETAIL
(GIR_DETAIL_ID)
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


ALTER TABLE INV_GIR_DETAIL ADD (
  CHECK (lot_status in ('ACCEPTED','REJECTED')),
  CONSTRAINT INV_GIR_DETAIL_PK
 PRIMARY KEY
 (GIR_DETAIL_ID)
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
               ),
  CONSTRAINT GIR_DET_IGP_UK
 UNIQUE (IGP_ID, IGP_DETAIL_ID, IGP_YEAR)
    USING INDEX 
    TABLESPACE oracubes
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          320K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));
--------------------------------------

CREATE OR REPLACE FORCE VIEW inv_igp_detail_view                                                
                                                      
AS
   SELECT pdv.po_id,     ---pdv.po_yearly_id, ---pdv.english,--- pdv.batch_no,
                    '' ygp, g.gir_id, igd.gir_detail_id,  
          od.quantity ogp_qty_in,      --- pdv.customer_code, ---pdv.customer,
                                 ---pdv.advance_amount,
                                 ---i.igp_yearly_id || '/' || i.igp_year igp,
                                 i.status_id status_name,
          i.status_id igp_status_id, i.igp_id, i.igp_year,
          i.igp_id || '/' || i.igp_year igp, i.igp_date, i.igp_type,
          i.payment_status, i.remarks, i.vehicle_type, i.vehicle_no,
          i.taken_in_by, i.status_id, i.fdatetime, i.taken_in_datetime,
          i.user_id, i.supplier_id, igd.wo_detail_id, igd.po_detail_id,
          igd.igp_detail_id,
          CASE
             WHEN igd.ogp_detail_id IS NOT NULL
                THEN inv_sc_desc2 (od.sc_id)
             ELSE igd.item_description
          END item_description,
          CASE
             WHEN igd.ogp_detail_id IS NOT NULL
                THEN inv_sc_desc2 (od.sc_id)
             ELSE igd.item_description
          END sc_desc,
          
          ---igd.gir_detail_id,
          igd.short_qty, igd.reject_qty,
          igd.supp_qty - igd.short_qty - igd.reject_qty accepted_qty,
          igd.breakage, igd.remarks item_remarks, igd.ogp_detail_id,
          igd.ogp_detail_id ogp_no, igd.supp_qty,        ---igd.gir_detail_id,
                                                 pd.po_quantity,
            NVL (pdv.rate, 0)
          * DECODE (pdv.rate,
                    NULL, igd.supp_qty,
                    igd.supp_qty - igd.short_qty - igd.reject_qty
                   ) amount,
          
          --pdv.rate_status po_det_rate_status,
          pdv.po_type, pdv.po_type powo_type,
                                             ---pdv.ygp,
                                                                            ---    pdv.cposition,
                                             NVL (pdv.rate, 0) rate,
          pdv.po_type ppo_type,
          
             --l1, l2, l3,
             ---l4,
             DECODE (pdv.po_type, 'CREDIT', 'PO-CR', 'CASH', 'PO-CS')
          || '/'
          || pdv.po_id po_no,
          NVL (pdv.unit_id, igd.unit_id) unit_id,
          NVL (pdv.unit_id, igd.unit_id) uom_id,
                                                ---pdv.sc_desc,
                                                ---pdv.po_id,
                                                pdv.po_date,
          pdv.po_date powo_date, pdv.po_det_status_id po_detail_status_id,
          pdv.delivery_date,
                            ---pdv.cpo_id,
                            pdv.store_code, pdv.po_store_code,
          pdv.item_description po_item_description, pdv.unit_id po_unit_id,
          
          /*
          CASE
             WHEN pdv.po_id IS NOT NULL
                THEN pdv.unit_id
             WHEN igd.ogp_detail_id IS NOT NULL
                THEN inv_sc_unit (od.sc_id)
          END unit_id,*/
          CASE
             WHEN pdv.po_id IS NOT NULL
                THEN pdv.sc_id
             WHEN igd.ogp_detail_id IS NOT NULL
                THEN od.sc_id
          END sc_id,
          '-' src, CASE
             WHEN pdv.po_id IS NOT NULL
                THEN 'PO'
          END powo, CASE
             WHEN pdv.po_id IS NOT NULL
                THEN pdv.po_id
          END powo_no, sup.description supplier_name, sup.address, sup.phone
     FROM inv_igp i,
          inv_igp_detail igd,
          inv_po_detail pd,
          inv_po_detail_view pdv,
          ac_coa sup,
          inv_gir_detail gd,
          inv_gir g,
          inv_ogp_detail od
    --         inv_pr_detail pr,
      --       ac_voucher_detail_summary_view v,
        --     inv_wo_detail wod
   WHERE  (i.igp_id = igd.igp_id)
---
      AND (igd.po_detail_id = pdv.po_detail_id(+))
---
      AND (igd.po_detail_id = pd.po_detail_id(+))
      AND (i.supplier_id = sup.coa_seq(+))
---
      AND (igd.igp_detail_id = gd.igp_detail_id(+))
---
      AND (gd.gir_id = g.gir_id(+))
---
      AND (igd.ogp_detail_id = od.ogp_detail_id(+));               
-------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW inv_gir_view
AS
   SELECT   gir_id, supplier_id, status_id, gir_date, supplier_name, po_type, voucher_seq
       FROM inv_gir_detail_view
   GROUP BY gir_id, supplier_id, status_id, gir_date, supplier_name, po_type
   ORDER BY gir_id;
-------------------------------
CREATE OR REPLACE FUNCTION "INV_OPENING_VALUE_DATE" (
   s     NUMBER,
   d     DATE,
   sts   VARCHAR2
)
   RETURN NUMBER
IS
   o    NUMBER;
   q    NUMBER;
   t    NUMBER;
   x    NUMBER;
   iq   NUMBER;
   oq   NUMBER;
   ov   NUMBER;
   --yr   VARCHAR2 (5) := fisical_year (d);
BEGIN
   x := 0;
   o := 0;
   q := 0;
   iq := 0;
   oq := 0;
   ov := 0;

   SELECT COUNT (*)
     INTO x
     FROM inv_sc_opening
    WHERE sc_id = s 
    --AND oyear = yr 
    AND item_status = sts;

   IF (x > 0)
   THEN
      SELECT NVL (oRATE, 0), NVL (oqty, 0)
        INTO o, q
        FROM inv_sc_opening
       WHERE sc_id = s 
       --AND oyear = yr 
       AND item_status = sts;

      ov := o * q;
   ELSE
      o := 0;
      ov := 0;
   END IF;

   SELECT COUNT (*)
     INTO x
     FROM inv_trans
    WHERE sc_id = s
      ----and trans_date > '31-MAR-2006'
      --AND fisical_year (trans_date) = yr
      AND trans_date < d
      AND item_status = sts;

   IF (x > 0)
   THEN
      SELECT SUM (NVL (rec_value, 0)) - SUM (NVL (issue_value, 0))
        INTO iq
        FROM inv_trans
       WHERE sc_id = s
         ----and trans_date > '31-MAR-2006'
         ---AND fisical_year (trans_date) = yr
         AND trans_date < d
         AND item_status = sts;
   ELSE
      iq := 0;
   END IF;

   oq := NVL (ov, 0) + NVL (iq, 0);
   RETURN oq;
END;   
---------------------------------------
CREATE OR REPLACE FUNCTION inv_sc_avg_rate (s NUMBER, d DATE)
   RETURN NUMBER
IS
   tmpvar   NUMBER;
/******************************************************************************
   NAME:       INV_TRX_AVG_RATE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/12/2017          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     INV_TRX_AVG_RATE
      Sysdate:         6/12/2017
      Date and Time:   6/12/2017, 6:44:03 PM, and 6/12/2017 6:44:03 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
   iq       NUMBER;
   iv       NUMBER;
   rq       NUMBER;
   rv       NUMBER;
   fy       VARCHAR2 (5);
   oq       NUMBER;
   ov       NUMBER;
   v        NUMBER;
   q        NUMBER;
   tt       VARCHAR2 (10);
   x        NUMBER;
BEGIN
   --fy := ac_fisical_year (d);

   SELECT COUNT (*)
     INTO x
     FROM inv_sc_opening
    WHERE sc_id = s 
    --AND oyear = fy 
    and item_status='OK';

   IF (x > 0)
   THEN
      SELECT oqty, oqty * orate
        INTO oq, ov
        FROM inv_sc_opening
       WHERE sc_id = s 
       --AND oyear = fy 
       and item_status='OK';
   END IF;

 --  return ov;
   SELECT NVL (SUM (rec_qty), 0), NVL (SUM (rec_value), 0),
          NVL (SUM (issue_qty), 0), NVL (SUM (issue_value), 0)
     INTO rq, rv,
          iq, iv
     FROM inv_trans
    WHERE sc_id = s AND trans_date <= d  and item_status='OK';
   --RETURN 3;
   v := (NVL (ov, 0) + NVL (rv, 0) - NVL (iv, 0));
                                                 -- / (nvl(RQ,0) - nvl(IQ,0));
   --RETURN 4;
   q := (NVL (oq, 0) + NVL (rq, 0) - NVL (iq, 0));

   --return Q;
   --tmpVar := 0;
   IF (v = 0 OR q = 0)
   THEN
      RETURN 0;
   END IF;

   RETURN v / q;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE;
END inv_sc_avg_rate;
---------------------------------------
CREATE OR REPLACE FORCE VIEW inv_ir_detail_view
AS
   SELECT  --inv_sale_return_qty (ird.ir_detail_id) returned_qty, i.payment,
           --  ird.issue_qty - inv_sale_return_qty (ird.ir_detail_id) bal_qty,
          i.department_id, i.batch_no,
          i.ir_yearly_id || '/' || i.ir_year_id ir, i.ir_yearly_id, i.ir_id,
          CASE
             WHEN t.issue_value <= 0
                THEN 0
             ELSE t.issue_value / t.issue_qty
          END trans_issue_rate,
          req_qty, i.customer_id, (ird.rate * ird.issue_qty) * 0.17 stn,
          ird.rate, ird.rate * ird.issue_qty amount,
          inv_sc_avg_rate (ird.sc_id, ir_date) * ird.issue_qty COST, 0 profit,
          scv.uom_id, scv.uom_id unit_id, i.ir_type,       --- i.payment_mode,
                                                    i.user_id, i.ir_date,
          i.fdatetime, i.issued_to, i.status_id, ird.ir_detail_id, ird.sc_id,
          ird.issue_qty, scv.description sc_desc, scv.description,
          scv.item_description sc_description, c.address, c.cell,
          c.contact_person, c.credit_days, c.currency_id,
          c.description customer, c.ntn ntn_no, c.phone, c.stn stn_no
     FROM inv_ir_detail ird, inv_sc_view scv, inv_ir i, ac_coa c, inv_trans t
    WHERE ird.sc_id = scv.sc_id(+)
      AND ird.ir_id = i.ir_id
      ---
      AND i.customer_id = c.coa_seq(+)
      ---
      AND ird.ir_detail_id = t.ir_detail_id(+);
--------------------------------------
CREATE OR REPLACE FORCE VIEW inv_trans_view
AS
   SELECT t.department_id, t.item_status, t.trans_id, t.trans_year,
          t.trans_date, NULL ir_order_info,
          TO_CHAR (t.trans_date, 'MON YYYY') MONTH,
          TO_CHAR (t.trans_date, 'YYYYMM') trans_month,
          TO_DATE ('01-' || TO_CHAR (t.trans_date, 'MON-YYYY')) period,
          t.trans_type, t.gir_id, t.gir_detail_id, t.ir_id, t.ir_detail_id,
          idv.ir_type,                             -- idv.voucher_seq ir_vseq,
                      --  idv.voucher ir_voucher,
                      t.gir_id || '/' || t.gir_detail_id gir_no,
          t.ir_id || '/' || t.ir_detail_id ir_no, t.remarks, t.status_id,
          t.fdatetime, t.user_id, t.issue_qty, t.issue_value, t.rec_qty,
          t.rec_value,                                     -- t.department_id,
                      sc.sc_id sc_code, sc.sc_id store_code,
          DECODE (trans_type,
                  'GIR', g.item_description,
                  'IR', idv.sc_desc,
                  sc.item_description
                 ) item_description,
          DECODE (trans_type,
                  'GIR', g.item_description,
                  'IGP', g.supplier_name,
                  'IR', idv.sc_desc
                 ) to_from,
          t.sc_id, idv.issued_to
     FROM inv_trans t,
          inv_gir_detail_view g,
          inv_ir_detail_view idv,
          inv_sc_view sc
--- PRODUCTION.JOB_CARD_VIEW J
   WHERE  (t.gir_detail_id = g.gir_detail_id(+))
      AND (t.ir_id = idv.ir_id(+) AND t.ir_detail_id = idv.ir_detail_id(+))
---
      AND t.sc_id = sc.sc_id;
      -----------
      inv_po_detail_view
      inv_gir_detail_view
      
      ALTER TABLE ADDOS.INV_L1 ADD (coa_seq  NUMBER);
      ALTER TABLE ADDOS.INV_L1 ADD FOREIGN KEY (coa_seq) REFERENCES ADDOS.AC_COA (coa_seq);
