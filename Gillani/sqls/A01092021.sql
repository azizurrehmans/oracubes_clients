ALTER TABLE EXP_CSC
 DROP PRIMARY KEY CASCADE;
DROP TABLE .EXP_CSC CASCADE CONSTRAINTS;

CREATE TABLE EXP_CSC
(
  STYLE                VARCHAR2(50 BYTE)        NOT NULL,
  COLOR_ID             VARCHAR2(50 BYTE)        NOT NULL,
  SPECIAL_INST         VARCHAR2(4000 BYTE),
  CUSTOMER_ID          NUMBER                   NOT NULL,
  CSC_ID               NUMBER,
  ITEM_CODE            VARCHAR2(50 BYTE),
  ITEM_DESCRIPTION     VARCHAR2(200 BYTE),
  CUSTOMS_DESCRIPTION  VARCHAR2(200 BYTE)
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


CREATE UNIQUE INDEX EXP_CSC_PK ON EXP_CSC
(CSC_ID)
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


CREATE UNIQUE INDEX EXP_CSC_UK ON EXP_CSC
(CUSTOMER_ID, STYLE, COLOR_ID)
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


ALTER TABLE EXP_CSC ADD (
  CONSTRAINT EXP_CSC_PK
 PRIMARY KEY
 (CSC_ID)
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
  CONSTRAINT EXP_CSC_UK
 UNIQUE (CUSTOMER_ID, STYLE, COLOR_ID)
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

ALTER TABLE EXP_CSC ADD (
  CONSTRAINT EXP_CSC_FK 
 FOREIGN KEY (CUSTOMER_ID) 
 REFERENCES EXP_CUSTOMER (CUSTOMER_ID),
  CONSTRAINT EXP_CSC_CLR_CLR_FK 
 FOREIGN KEY (COLOR_ID) 
 REFERENCES EXP_COLOR (COLOR_ID));
 
 -----------------------------------------------------------------------------
 
 ALTER TABLE EXP_CSC_PHOTO
 DROP PRIMARY KEY CASCADE;
DROP TABLE EXP_CSC_PHOTO CASCADE CONSTRAINTS;

CREATE TABLE EXP_CSC_PHOTO
(
  CSC_ID  NUMBER,
  PHOTO   LONG RAW
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


CREATE UNIQUE INDEX EXP_CSC_PHOTO_PK ON EXP_CSC_PHOTO
(CSC_ID)
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


ALTER TABLE EXP_CSC_PHOTO ADD (
  CONSTRAINT EXP_CSC_PH_PK
 PRIMARY KEY
 (CSC_ID)
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

ALTER TABLE EXP_CSC_PHOTO ADD (
  CONSTRAINT EXP_CS_CLR_PH_FK 
 FOREIGN KEY (CSC_ID) 
 REFERENCES EXP_CSC (CSC_ID));
--------------------------------------------------------------------
ALTER TABLE ADDOS.EXP_CPO_DETAIL  DROP CONSTRAINT EXP_CPO_DET_CSC_FK;
ALTER TABLE ADDOS.EXP_CPO_DETAIL ADD CONSTRAINT CPO_DET_CSC_FK FOREIGN KEY (CSC_ID)  REFERENCES ADDOS.EXP_CSC (CSC_ID);
------------------------------------------
CREATE OR REPLACE FORCE VIEW addos.exp_packing_detail_view 
AS
   SELECT
             --pd.material,
             company_prefix
          || '/'
          ||  pd.packing_id
          || '/'
          || pd.packing_year inv_no,
          pd.color_id, pd.rsize, pd.lot_no, pd.item_description, pd.style,
          cdv.shipment_date,
                            --cc.alternative_code,
                            ---cc.alternative_desc,
                            p.packing_id, p.packing_year, p.packing_date,
          p.despatched_to, p.eform_no, p.eform_date, p.customer_id, p.awb,
          p.awb_date, p.commision, p.freight_ins, p.discount,
          c.description customer_name, 
                                       ---cc.item_code customer_store_code,
          '-' item_code, '-' sc_main_id, '-' sc_sub_id, '-' sc_id, pd.qty,
          '-' breakage, pd.parcel_no, '-' sub_parcel_no, pd.cpo_id,
          pd.POSITION, pd.rate acc_rate, pd.gross_wt, pd.net_wt, '-' tc,
          '-' milled, '-' rd, '-' high_polish, '-' ncr, '-' SAMPLE,
          cdv.quantity order_qty, '-' forging_type, '-' parent_cpo,
          '-' sub_customer_id, '-' finish_id, pd.remarks, 0 rate,
          c.milling_per, c.hi_polish_per, NVL (c.currency_id,
                                               '-') currency_id,
          ps.tot_parcel, ps.from_parcel, ps.to_parcel, ps.tot_breakage,
          cpo.pi_no, cpo.our_cpo, cpo.cpo_year, cdv.customs_item_desc
     FROM exp_packing p,
          exp_packing_detail pd,
          exp_customer c,
          exp_cpo cpo,
          exp_cpo_detail cdv,
          (SELECT   customer_id, packing_id, packing_year,
                    COUNT (DISTINCT parcel_no) tot_parcel,
                    MIN (parcel_no) from_parcel, MAX (parcel_no) to_parcel,
                    0 tot_breakage
               FROM exp_packing_detail
           GROUP BY customer_id, packing_id, packing_year) ps
    WHERE p.packing_id = pd.packing_id
      AND p.packing_year = pd.packing_year
      AND p.customer_id = pd.customer_id
      -------
      AND p.customer_id = c.customer_id(+)
      -------
      AND pd.cpo_id = cpo.cpo_id(+)
      -------
      AND pd.cpo_id = cdv.cpo_id(+)
      AND pd.POSITION = cdv.POSITION(+)
      -------
      AND p.packing_id = ps.packing_id(+)
      AND p.packing_year = ps.packing_year(+)
      AND p.customer_id = ps.customer_id(+);
      ----------------------------------------------------------
      CREATE OR REPLACE FORCE VIEW inv_customer_code_view 
AS
   SELECT c.sub_customer, c.alternative_code, c.alternative_desc, sc.l4_seq,
          c.customer_coa_seq, sc.fdatetime, c.item_code, c.sc_id, c.status_id,
          sc.user_id, '-' abbri, coa.description customer_name, sc.avg_rate,
          sc.balance, sc.coa, sc.coa_seq, sc.description, sc.english, 0 hrate,
          sc.item_description, sc.l1, sc.l2, sc.l3, sc.l4, sc.l5,
          sc.last_purchase_rate, sc.LEVELS, sc.sc_desc, sc.SPECIFICATION,
          sc.unit_id, sc.uom_id
     FROM inv_customer_code c, ac_coa coa, inv_sc_view sc
    WHERE c.customer_coa_seq = coa.coa_seq AND c.sc_id = sc.sc_id;
    -------------------------------------
    -----ALTER TALBE AC_COA_SEQ ADD(ABBRI VARCHAR2(10));
    ALTER TABLE ADDOS.AC_COA ADD (ABBRI  VARCHAR2(10));
    
    ALTER TABLE ADDOS.INV_SC MODIFY(L2  NULL);
   ALTER TABLE ADDOS.INV_SC MODIFY(L3  NULL);
----------------------------------------------
ALTER TABLE INV_PO DROP PRIMARY KEY CASCADE;
DROP TABLE INV_PO CASCADE CONSTRAINTS;

CREATE TABLE INV_PO
(
  PO_ID              NUMBER                     NOT NULL,
  PO_YEAR            VARCHAR2(7 BYTE)           NOT NULL,
  PO_DATE            DATE                       NOT NULL,
  SUPPLIER_ID        NUMBER(6)                  NOT NULL,
  CPO_ID             VARCHAR2(20 BYTE),
  SPECIAL_INS        VARCHAR2(120 BYTE)         NOT NULL,
  STATUS_ID          VARCHAR2(10 BYTE)          DEFAULT 0                     NOT NULL,
  FDATETIME          DATE                       DEFAULT sysdate               NOT NULL,
  DELIVERY_DATE      DATE,
  PO_TYPE            VARCHAR2(10 BYTE)          NOT NULL,
  BILL               VARCHAR2(1 BYTE),
  FINISH             VARCHAR2(50 BYTE),
  SC_FINISH_ID       VARCHAR2(50 BYTE),
  USER_ID            VARCHAR2(20 BYTE)          DEFAULT 'aziz'                NOT NULL,
  OUR_CPO            VARCHAR2(5 BYTE),
  CPO_YEAR           VARCHAR2(5 BYTE),
  DEMANDEDBY         VARCHAR2(40 BYTE)          NOT NULL,
  PURPOSE            VARCHAR2(200 BYTE)         NOT NULL,
  DELETED_USER       VARCHAR2(20 BYTE),
  DELETED_FDATETIME  DATE,
  DELETED_REASON     VARCHAR2(100 BYTE),
  RATE_STATUS_ID     VARCHAR2(20 BYTE),
  PREQ_ID            NUMBER(5),
  PREQ_YEAR          VARCHAR2(5 BYTE),
  SUP_COA_SEQ        NUMBER(5),
  FCURRENCY          VARCHAR2(20 BYTE),
  EXCHANGE_RATE      NUMBER,
  PO_YEARLY_ID       NUMBER
)
TABLESPACE ORACUBES
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512K
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


CREATE UNIQUE INDEX PO_PK ON INV_PO
(PO_ID, PO_YEAR)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX INV_PO_PK ON INV_PO
(PO_ID)
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


ALTER TABLE INV_PO ADD (
  CONSTRAINT INV_PO_PK
 PRIMARY KEY
 (PO_ID)
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

ALTER TABLE INV_PO ADD (
  CONSTRAINT PO_PREQ_FK 
 FOREIGN KEY (PREQ_ID, PREQ_YEAR) 
 REFERENCES INV_PREQ (PREQ_ID,PREQ_YEAR),
  CONSTRAINT PO_USER_FK 
 FOREIGN KEY (USER_ID) 
 REFERENCES ADM_USERS (USER_ID));
----------------------------------------------
ALTER TABLE INV_PO_DETAIL DROP PRIMARY KEY CASCADE;
DROP TABLE INV_PO_DETAIL CASCADE CONSTRAINTS;

CREATE TABLE INV_PO_DETAIL
(
  PO_ID              NUMBER                     NOT NULL,
  PO_DETAIL_ID       NUMBER(5)                  NOT NULL,
  POSITION           NUMBER(4),
  SC_ID              NUMBER(4)                  NOT NULL,
  PO_QUANTITY        NUMBER(15,5)               NOT NULL,
  DELIVERY_DATE      DATE,
  RATE               NUMBER(15,5)               DEFAULT 0,
  SALES_TAX          NUMBER(15,6),
  PO_TYPE            VARCHAR2(10 BYTE),
  ADD_SPECS          VARCHAR2(100 BYTE),
  SC_FINISH_ID       VARCHAR2(50 BYTE),
  STATUS_ID          VARCHAR2(10 BYTE)          DEFAULT 1                     NOT NULL,
  EXCESS_PER         NUMBER(10,2)               DEFAULT 0                     NOT NULL,
  EXCESS_QTY         NUMBER(15,5)               DEFAULT 0                     NOT NULL,
  PI_ID              NUMBER(10),
  PI_YEAR            VARCHAR2(5 BYTE),
  PI_DETAIL_ID       NUMBER(2),
  SC_CAT_ID          VARCHAR2(2 BYTE)           DEFAULT 'P'                   NOT NULL,
  SAMPLE             VARCHAR2(1 BYTE)           DEFAULT 'N',
  GUAGE              VARCHAR2(1 BYTE)           DEFAULT 'N',
  DRAWING            VARCHAR2(1 BYTE)           DEFAULT 'N',
  CATALOG_COPY       VARCHAR2(1 BYTE)           DEFAULT 'N',
  OUR_CPO            VARCHAR2(5 BYTE),
  CPO_YEAR           VARCHAR2(5 BYTE),
  DELETED_USER       VARCHAR2(20 BYTE),
  DELETED_FDATETIME  DATE,
  DELETED_REASON     VARCHAR2(100 BYTE),
  FC_RATE            NUMBER
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
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX INV_PO_DETAIL_PK ON INV_PO_DETAIL
(PO_DETAIL_ID)
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


ALTER TABLE INV_PO_DETAIL ADD (
  CONSTRAINT INV_PO_DETAIL_PK
 PRIMARY KEY
 (PO_DETAIL_ID)
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

ALTER TABLE INV_PO_DETAIL ADD (
  CONSTRAINT INV_PO_DET_FK 
 FOREIGN KEY (PO_ID) 
 REFERENCES INV_PO (PO_ID));
----------------------------------------------
CREATE OR REPLACE FORCE VIEW inv_gir_detail_view
AS
   SELECT DECODE (NVL (t.trans_id, 0), 0, 'NO', 'YES') trx, pdv.po_id,
          pdv.po_date, t.issue_value cr_amount, t.rec_value dr_amount,
          t.trans_id, t.trans_year, g.user_id,
          inv_igp_qty (gd.igp_detail_id) igp_qty, v.voucher_id,
          v.voucher_month_id, v.voucher_type_id,
          
             ---v.voucher_no,
             v.voucher_type_id
          || '/'
          || v.voucher_id
          || '/'
          || v.voucher_month_id voucher_no,
          g.gir_id, g.gir_id gir, g.gir_date,
          
          ---   g.po_id,
          DECODE (g.po_type, 'CASH', 'PO-CS', 'CREDIT', 'PO-CR') po,
          g.remarks, g.status_id, g.fdatetime,
                                                   ---g.mgir_id, g.mgir_year,
                                              ---   g.mgir_id || '/' || g.mgir_year mgir, g.igp_type,
                                              gd.gir_detail_id,
          gd.receiving_date, gd.po_detail_id, gd.received_qty,
          gd.rejected_qty, gd.received_qty - gd.rejected_qty accepted_qty,
          gd.received_by, gd.inspected_by, gd.lot_status, gd.freight,
          pdv.po_type, pdv.supplier_id, s.description supplier_name,
          s.address || ' ' || s.phone supplier_address,
                                                       ----   pdv.cpo_type || '/' || pdv.our_cpo || '/' || pdv.cpo_year our_cpo,
                                                       ---   pdv.cpo_detail_id cpo_id, ---p.po_date,
                                                       pdv.POSITION,
          pdv.store_code, pdv.po_store_code, pdv.sc_finish_id, pdv.sc_id,
          
          ----    pdv.sc_id,
          pdv.item_description sc_desc, pdv.item_description item_description,
          pdv.po_quantity, pdv.rate,
          DECODE (pdv.rate,
                  NULL, 0,
                  pdv.rate * (gd.received_qty - gd.rejected_qty)
                 ) amount,
          (pdv.sales_tax) * (gd.received_qty - gd.rejected_qty) sales_tax,
          g.status_id status_name, pdv.unit_id, pdv.unit_id uom_id,
          
          ---g.igp_id, g.igp_year,

          ---g.igp_id  igp,
          gd.igp_detail_id,
                           --- pdv.igp_date,
                           pr.issue_qty pr_qty
     FROM inv_gir g,
          inv_gir_detail gd,
          ac_coa s,
          inv_po_detail_view pdv,
          ac_voucher v,
          (SELECT   gir_detail_id, SUM (issue_qty) issue_qty
               FROM inv_pr_detail
           GROUP BY gir_detail_id) pr,
          inv_trans t
    WHERE (g.gir_id = gd.gir_id)
---
      AND (pdv.supplier_id = s.coa_seq)
---
      AND (gd.po_detail_id = pdv.po_detail_id)
----
      AND (g.gir_id = v.gir_id(+))
---
      AND (gd.gir_detail_id = pr.gir_detail_id(+))
---
      AND (gd.gir_detail_id = t.gir_detail_id(+));
----------------------------------------------
ALTER TABLE INV_IGP_DETAIL ADD(GIR_DETAIL_ID NUMBER);
-----------------------------------------------
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
--------------------------------------------
ALTER TABLE INV_OGP_DETAIL ADD(JCD_ID NUMBER);
------------------
CREATE OR REPLACE FORCE VIEW inv_ogp_detail_view
AS
   SELECT ALL TRUNC ((SYSDATE - o.ogp_date)) days, o.ogp_id, o.ogp_year,
              rec_ogps.po_id, o.inv_ogp_id,
              o.ogp_id || '/' || o.ogp_year ogp_no, sc.l5_id, o.ogp_date,
              o.payment, o.ogp_type, o.remarks, o.vehicle_type, o.vehicle_no,
              o.user_id, o.vehicle_type || '-' || o.vehicle_no vehicle_info,
              o.freight, o.octroi, o.status, o.fdatetime, o.taken_out_by,
              o.taken_out_datetime,
              o.taken_out_by || '-' || o.taken_out_datetime taken_out_info,
              o.expected_return_date, o.actual_return_date, o.party_name,
              o.purpose, o.supplier_id, s.description supplier_name,
              
              --    s.address, s.phone, s.phone2,
              od.in_out, od.ogp_detail_id, od.jcd_id,
                                                     ---od.igp_id,
                                                     od.igp_detail_id,
                                                               -- od.igp_year,
              od.igp_detail_id igp_no, od.sc_id,
                                                --latest_rate (od.sc_id) rate,
                                                od.sc_id store_code,
              od.cpo_id,
                 od.cpo_id
              || '/'
              || od.POSITION
              || '/'
              || od.job_card_id job_card_no,
              od.POSITION, od.job_card_id,
              od.item_description item_description, od.unit_id, od.quantity,
              od.remarks detail_remarks, NVL (od.wo_id, o.wo_id) wo_id,
              od.wo_detail_id,          --NVL (od.wo_year, o.wo_year) wo_year,
                              od.wo_id || '/' || od.wo_detail_id wo_no,
              rec_ogps.status_id igp_status,                        --od.rate,
              
              --  rec_ogps.ygp,
              NVL (rec_ogps.sum_igp_rec_qty, 0) sum_igp_rec_qty,
              NVL (rec_ogps.sum_igp_rej_qty, 0) sum_igp_rej_qty,
              NVL (rec_ogps.sum_igp_rej_qty, 0) rej_qty,
              DECODE (in_out,
                      'IN', NVL (od.quantity, 0)
                       - NVL (rec_ogps.sum_igp_rec_qty, 0),
                      0
                     ) in_ogp_balance_qty,
              DECODE (in_out,
                      'OUT', NVL (od.quantity, 0)
                       - NVL (rec_ogps.sum_igp_rec_qty, 0),
                      0
                     ) out_ogp_balance_qty,
              DECODE (in_out,
                      'IN', NVL (od.quantity, 0)
                       - NVL (rec_ogps.sum_igp_rec_qty, 0),
                      0
                     ) ogp_balance_qty,
                NVL (od.quantity, 0)
              - NVL (rec_ogps.sum_igp_rej_qty, 0) ogp_accepted_qty,
                NVL (od.quantity, 0)
              - NVL (rec_ogps.sum_igp_rej_qty, 0) accepted_qty,
                (  NVL (od.quantity, 0)
                 - NVL (rec_ogps.sum_igp_rej_qty, 0)
                 - NVL (sum_igp_breakage, 0)
                )
              * od.rate amount,
              
              --pr.po_id, pr.po_year, pr.po_detail_id, pr.po_type, pr.pr_id,
              --pr.pr_year, pr.pr_detail_id,
              DECODE (od.in_out, 'OUT', od.quantity, 0) out_qty,
              DECODE (od.in_out, 'IN', od.quantity, 0) in_qty
         FROM inv_ogp o,
              inv_ogp_detail od,
              inv_sc_view sc,
              ac_coa s,
              (SELECT   ogp_detail_id, status_id, po_id,
                        SUM (NVL (accepted_qty, 0)) sum_igp_rec_qty,
                        SUM (NVL (reject_qty, 0)) sum_igp_rej_qty,
                        SUM (NVL (breakage, 0)) sum_igp_breakage
                   FROM inv_igp_detail_view
               GROUP BY ogp_detail_id, status_id, po_id) rec_ogps
                                                                           --,
        --pr_detail_view pr
   WHERE      o.inv_ogp_id = od.inv_ogp_id
----
          AND o.supplier_id = s.coa_seq(+)
----
          AND od.sc_id = sc.sc_id
          AND od.ogp_detail_id = rec_ogps.ogp_detail_id(+);
----------------------------------------------
CREATE OR REPLACE FORCE VIEW inv_po_balance_view1
AS
   SELECT   po.supplier_id, po.supplier_name, po.address, po.phone, po.phone2,
            po.po_type, po.po_type_old, po.delivery_date, po.po_year,
            po.po_date, po.status_id, status_id status_desc,
               DECODE (po.po_type, 'CASH', 'PO-CS', 'CREDIT', 'PO-CR')
            || '/'
            || po.po_id
            || '/'
            || po.po_year po,
            po.po_id, po.rate_status_id, SUM (po.pr_qty) pr_qty,
            SUM (po.po_quantity) po_quantity, SUM (po.gir_qty) gir_qty,
            SUM (po.balance_qty) balance_qty, NVL (igp.igp_qty, 0) igp_qty,
            NVL (ogp.ogp_qty, 0) ogp_qty,
              SUM (po.po_quantity)
            - NVL (igp.igp_qty, 0)
            + NVL (ogp.ogp_qty, 0) igp_balance_qty
       FROM (SELECT   po_id, po_year,
                        SUM (supp_qty)
                      - SUM (short_qty)
                      - SUM (reject_qty) igp_qty
                 FROM inv_igp_detail
             GROUP BY po_id, po_year, po_type) igp,
            (SELECT   po_id, SUM (out_qty) ogp_qty
                 FROM inv_ogp_detail_view
             GROUP BY po_id) ogp,
            (SELECT   p.supplier_id, p.po_type, p.po_type_old, p.our_cpo,
                      p.cpo_year, delivery_date, p.po_id, p.po_year,
                      p.po_detail_id, p.po_date, p.supplier_name, s.address,
                      s.phone, NULL phone2, p.po_quantity po_quantity,
                      p.status_id, p.rate_status_id,
                      SUM (NVL (accepted_qty, 0)) gir_qty,
                      SUM (NVL (pr_qty, 0)) pr_qty,
                        NVL (p.po_quantity, 0)
                      - SUM (NVL (accepted_qty, 0))
                      + SUM (NVL (pr_qty, 0)) balance_qty
                 FROM inv_po_detail_view p,
                      inv_gir_detail_view g,
                      ac_coa_view s
                WHERE p.po_id = g.po_id(+)
                  --AND p.po_year = g.po_year(+)
                  AND p.po_detail_id = g.po_detail_id(+)
                  AND p.supplier_id = s.coa_seq(+)
             --AND p.sc_main_id < 900
             --AND p.status_id IN (0, 1, 7, 31)
             ---AND p.po_det_status_id = 'CANCELLED'
             GROUP BY p.supplier_id,
                      p.supplier_name,
                      s.address,
                      s.phone,
                      p.po_type,
                      p.po_type_old,
                      p.our_cpo,
                      p.cpo_year,
                      p.delivery_date,
                      p.po_id,
                      p.po_year,
                      p.po_detail_id,
                      p.po_date,
                      p.po_quantity,
                      p.status_id,
                      p.rate_status_id) po
      WHERE po.po_id = igp.po_id(+)
                                   --AND po.po_year = igp.po_year(+)
                                   ---
            AND po.po_id = ogp.po_id(+)
        --AND po.po_year = ogp.po_year(+)
   ---
   GROUP BY po.supplier_id,
            po.supplier_id,
            po.supplier_name,
            po.address,
            po.phone,
            po.phone2,
            po.po_type,
            po.po_type_old,
            po.po_year,
            po.po_date,
            po.po_id,
            po.status_id,
            po.rate_status_id,
            po.delivery_date,
            igp.igp_qty,
            ogp.ogp_qty;
 ---------------------------------------------------        
 ALTER TABLE INV_PO ADD(PO_YEARLY_ID NUMBER);
 --------------------------------------------------- 
 
 CREATE OR REPLACE FORCE VIEW inv_po_balance_view2 (po_id,
                                                           po,
                                                           delivery_date,
                                                           supplier_id,
                                                           po_type,
                                                           po_year,
                                                           po_date,
                                                           status_id,
                                                           address,
                                                           balance_qty,
                                                           gir_qty,
                                                           igp_balance_qty,
                                                           igp_qty,
                                                           ogp_qty,
                                                           phone,
                                                           phone2,
                                                           po_quantity,
                                                           pr_qty,
                                                           rate_status_id,
                                                           supplier_name
                                                          )
AS
   SELECT p.po_id, p.po_yearly_id || '/' || p.po_year po, p.delivery_date,
          p.supplier_id, p.po_type, p.po_year, p.po_date, p.status_id,
          b.address, b.balance_qty, b.gir_qty, b.igp_balance_qty, b.igp_qty,
          b.ogp_qty, b.phone, b.phone2, b.po_quantity, b.pr_qty,
          b.rate_status_id, b.supplier_name
     FROM inv_po p, inv_po_balance_view1 b
    WHERE p.po_id = b.po_id(+);  
 -------------------------------------------------------------
 CREATE TABLE INV_PO_HISTORY
(
  PO_ID             VARCHAR2(26 BYTE),
  PO_DETAIL_ID      NUMBER(5),
  ITEM_DESCRIPTION  VARCHAR2(4000 BYTE),
  GIR               VARCHAR2(87 BYTE),
  SC_MAIN_ID        VARCHAR2(122 BYTE),
  GIR_DATE          DATE,
  SUPPLIER_NAME     VARCHAR2(50 BYTE),
  ACCEPTED_QTY      NUMBER,
  RATE              NUMBER(15,5),
  AMOUNT            NUMBER,
  PO_DATE           DATE
)
TABLESPACE ORACUBES
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          128K
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
-------------------------------------------------
CREATE TABLE INV_PO_TERMS
(
  PO_ID    VARCHAR2(20 BYTE)                    NOT NULL,
  PO_YEAR  VARCHAR2(7 BYTE)                     NOT NULL,
  TERM     VARCHAR2(200 BYTE)                   NOT NULL
)
TABLESPACE ORACUBES
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          448K
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


CREATE UNIQUE INDEX PO_TERM_UK ON INV_PO_TERMS
(PO_ID, TERM)
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


ALTER TABLE INV_PO_TERMS ADD (
  CONSTRAINT PO_TERM_UK
 UNIQUE (PO_ID, TERM)
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
------------------------------------------------------      
CREATE OR REPLACE FUNCTION inv_sc_lookup(sc number, fld varchar2) RETURN varchar2 IS
  answer varchar2(500);
  x number;
BEGIN
  select count(*) into x from inv_sc where sc_id = sc;
  if (x > 0) then
    if (fld = 'desc') then
      select description into answer from inv_sc where sc_id = sc;
      return answer;
    elsif (fld = 'unit') then
      select uom_id into answer from inv_sc where sc_id = sc;
      return answer;    
    end if;  
  end if;
  return sc||' is an Invalid Item Code';
END;         
----------------------------------------------------

CREATE TABLE INV_PI
(
  PI_ID          NUMBER,
  PI_YEAR        VARCHAR2(5 BYTE),
  FDATETIME      DATE                           NOT NULL,
  USER_ID        VARCHAR2(12 BYTE)              NOT NULL,
  STATUS_ID      NUMBER(2)                      NOT NULL,
  REQ_BY_ID      NUMBER(6),
  DEPARTMENT_ID  VARCHAR2(30 BYTE),
  PRIORITY       VARCHAR2(10 BYTE),
  REMINDER       NUMBER(10)                     DEFAULT 0                     NOT NULL,
  SC_ID          NUMBER(10)
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


CREATE UNIQUE INDEX INV_PI_PK ON INV_PI
(PI_ID, PI_YEAR)
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


ALTER TABLE INV_PI ADD (
  CONSTRAINT PI_PRIORITY_CHK
 CHECK (PRIORITY IN ('NORMAL','URGENT','TOP URGENT')),
  CONSTRAINT PI_PK
 PRIMARY KEY
 (PI_ID, PI_YEAR));
 -------------------------------------------------------
 CREATE TABLE INV_SC_FINISH
(
  SC_FINISH_ID  VARCHAR2(40 BYTE)               NOT NULL,
  STATUS_ID     NUMBER(2)                       DEFAULT 0                     NOT NULL,
  FDATETIME     DATE                            DEFAULT sysdate,
  USER_ID       NUMBER(6)
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


ALTER TABLE INV_SC_FINISH ADD (
  CHECK ("FDATETIME" IS NOT NULL),
  PRIMARY KEY
 (SC_FINISH_ID)
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

GRANT REFERENCES, SELECT ON INV_SC_FINISH TO PUBLIC;
-------------------------------------------
CREATE OR REPLACE FUNCTION inv_igp_po_balance_qty (
  
   pod   NUMBER
)
   RETURN NUMBER
IS
/******************************************************************************
   NAME:       store_po_balance_qty
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/8/2012          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     store_po_balance_qty
      Sysdate:         10/8/2012
      Date and Time:   10/8/2012, 1:17:53 PM, and 10/8/2012 1:17:53 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
   tmpvar   NUMBER (15, 6);
   p        NUMBER;
   pq       NUMBER;
   x        NUMBER (15, 6);
   g        NUMBER;
   o        NUMBER;
   gq       NUMBER (15, 6);
   pr       NUMBER;
BEGIN
   SELECT COUNT (*) 
     INTO p
     FROM inv_po_detail
    WHERE po_detail_id = pod;

   IF (p > 0)
   THEN
      SELECT po_quantity
        INTO pq
        FROM inv_po_detail
       WHERE po_detail_id = pod;
   END IF;

   SELECT COUNT (*)
     INTO g
     FROM inv_igp_detail
    WHERE  po_detail_id = pod;

   IF (g > 0)
   THEN
      SELECT   SUM (NVL (supp_qty, 0))
             - SUM (NVL (reject_qty, 0))
             - SUM (NVL (short_qty, 0))
        INTO gq
        FROM inv_igp_detail
       WHERE po_detail_id = pod;
   END IF;

   SELECT COUNT (*)
     INTO x
     FROM inv_pr_detail pd, inv_gir g, inv_gir_detail gd
    WHERE pd.gir_id = gd.gir_id
      AND pd.gir_detail_id = gd.gir_detail_id
      AND pd.gir_year = gd.gir_year
      --
      AND g.gir_id = gd.gir_id
      --AND g.gir_year = gd.gir_year
      --      
      AND gd.po_detail_id = pod;

   IF (x > 0)
   THEN
      SELECT sum(pd.issue_qty)
        INTO pr
        FROM inv_pr_detail pd, inv_gir g, inv_gir_detail gd
       WHERE pd.gir_id = gd.gir_id
         AND pd.gir_detail_id = gd.gir_detail_id
         AND pd.gir_year = gd.gir_year
         --
         AND g.gir_id = gd.gir_id
         --AND g.gir_year = gd.gir_year
         --       
         AND gd.po_detail_id = pod;
   END IF;

    --select count(*) into x from pr_detail_view WHERE P.PO_ID = 166 AND PO_YEAR = '17' AND P.PO_DETAIL_ID = 1;
   -- return x;

   --select count(*) into O from ogp_detail_view;
       --  where po_id=po and po_year=yr and po_detail_id= pod and po_type=pty;
   -- if (g > 0) then
   --    select SUM(nvl(SUPP_qty,0)) - SUM(nvl(reject_qty,0)) - SUM(NVL(SHORT_QTY,0)) into gq from IGP_detail
    --     where po_id=po and po_year=yr and po_detail_id= pod and po_type=pty;

   --end if;
   tmpvar := x;
   RETURN NVL (pq, 0) - NVL (gq, 0) + NVL (pr, 0);
--RETURN nvl(g,0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE;
END inv_igp_po_balance_qty;
-------------------------------------------
CREATE OR REPLACE FORCE VIEW inv_po_detail_view                                                        
AS
   SELECT po.fcurrency, po.exchange_rate, pd.fc_rate, po.po_year,
          pd.fc_rate * pd.po_quantity fc_amount,
          pd.fc_rate * pd.po_quantity || po.fcurrency fc_amount2, 
          po.po_type,
          po.po_type po_type_old, 
          po.preq_id, 
          po.preq_year,
             DECODE (po.po_type, 'CASH', 'PO-CS', 'CREDIT', 'PO-CR')
          || '/'
          || po.po_id
          || '/'
          || po.po_year
          || '/'
          || pd.po_detail_id pod,
             DECODE (po.po_type, 'CASH', 'PO-CS', 'CREDIT', 'PO-CR')
          || '/'
          || po.po_id
          || '/'
          || po.po_year po,
          cpo.cpo_type || '/' || po.our_cpo || '/' || po.cpo_year cpo,
          cpo.cpo_type, po.our_cpo, po.cpo_year, po.demandedby, po.purpose,
          po.user_id, pd.catalog_copy, pd.SAMPLE, pd.guage, pd.drawing,
          pd.status_id po_det_status_id, pd.po_id, po.po_date,
          ---po.po_type po_type, 
          po.special_ins, po.special_ins po_remarks,
          pd.add_specs po_detail_remarks, pd.add_specs, NULL supplier_phone2,
          '' ygp, '' customer_code, '' batch_no,
                                                --po.supplier_id,
                                                pd.delivery_date, po.bill,
          po.status_id, pd.po_detail_id, pd.POSITION,
                                                     --cc.item_code customer_item_code,
                                                     sc.sc_id po_store_code,
          sc.sc_id store_code, sc.description item_description,
          sc.unit_id unit_id, pd.sc_id sc_id,
                                             --store_code_desc.store_code (pd.sc_main_id) sc_main_desc,
                                             pd.po_quantity, pd.excess_qty,
          pd.excess_per, pd.rate, pd.po_quantity * pd.rate amount,
          pd.sales_tax,                                       ---pd.add_specs,
                       pd.sc_finish_id, po.supplier_id,
          s.description supplier_name, s.address supplier_address,
          s.phone supplier_phone1, po.status_id status, po.rate_status_id,
          inv_igp_po_balance_qty (pd.po_detail_id) igp_balance_qty
     FROM inv_po po,
          inv_po_detail pd,
          exp_cpo cpo,
          --customer_code cc,
          ac_coa_view s,
          inv_sc_view sc
    WHERE po.po_id = pd.po_id
------
      AND po.our_cpo = cpo.our_cpo(+)
      AND po.cpo_year = cpo.cpo_year(+)
------
      AND po.supplier_id = s.coa_seq(+)
-------
      AND pd.sc_id = sc.sc_id;
------------------------------------------------------
DROP TABLE INV_PO_TERMS CASCADE CONSTRAINTS;

CREATE TABLE INV_PO_TERMS
(
  PO_ID    VARCHAR2(20 BYTE)                    NOT NULL,
  PO_YEAR  VARCHAR2(7 BYTE)                     NOT NULL,
  TERM     VARCHAR2(200 BYTE)                   NOT NULL
)
TABLESPACE ORACUBES
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          448K
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


CREATE UNIQUE INDEX PO_TERM_UK ON INV_PO_TERMS
(PO_ID, TERM)
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


ALTER TABLE INV_PO_TERMS ADD (
  CONSTRAINT PO_TERM_UK
 UNIQUE (PO_ID, TERM)
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
  --------------------------------------
  CREATE OR REPLACE FORCE VIEW inv_po_terms_view (po_id, po_year, term)
AS
   SELECT pt.po_id, pt.po_year, pt.term
     FROM inv_po_terms pt
   UNION
   SELECT 'ALL', 'ALL', pta.term || '-' || pta.NO
     FROM inv_po_terms_all pta;
------------------------------------------
DROP TABLE INV_PO_TERMS_ALL CASCADE CONSTRAINTS;

CREATE TABLE INV_PO_TERMS_ALL
(
  TERM  VARCHAR2(500 BYTE)                      NOT NULL,
  NO    NUMBER
)
TABLESPACE ORACUBES
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          448K
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


CREATE UNIQUE INDEX INV_PO_TERMS_ALL ON INV_PO_TERMS_ALL
(TERM)
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


ALTER TABLE INV_PO_TERMS_ALL ADD (
  CONSTRAINT INV_PO_TERMS_ALL
 UNIQUE (TERM)
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

             