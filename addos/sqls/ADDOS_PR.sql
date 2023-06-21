ALTER TABLE inv_PR DROP PRIMARY KEY CASCADE;
DROP TABLE inv_PR CASCADE CONSTRAINTS;

CREATE TABLE inv_PR
(
  PR_ID        NUMBER(20)                       NOT NULL,
  PR_DATE      DATE                             NOT NULL,
  ISSUED_TO    VARCHAR2(30 BYTE)                NOT NULL,
  STATUS_ID    VARCHAR2(20 BYTE)                NOT NULL,
  FDATETIME    DATE                             NOT NULL,
  USER_ID      VARCHAR2(20 BYTE)                NOT NULL,
  REMARKS      VARCHAR2(200 BYTE),
  SUPPLIER_ID  NUMBER(4),
  VOUCHER_SEQ  NUMBER(10)
)
TABLESPACE oracubes
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


CREATE UNIQUE INDEX PR_PK ON INV_PR
(PR_ID)
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


ALTER TABLE INV_PR ADD (
  CONSTRAINT PR_PK
 PRIMARY KEY
 (PR_ID)
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
---------------------------
ALTER TABLE INV_PR_DETAIL DROP PRIMARY KEY CASCADE;
DROP TABLE INV_PR_DETAIL CASCADE CONSTRAINTS;

CREATE TABLE INV_PR_DETAIL
(
  PR_ID              NUMBER(20)                 NOT NULL,
  PR_DETAIL_ID       NUMBER(2),  
  SC_ID              NUMBER(2)                  NOT NULL,
  REQ_QTY            NUMBER(12,6),
  ISSUE_QTY          NUMBER(12,6)               NOT NULL,
  VALUE              NUMBER(14,6)               NOT NULL,
  GIR_ID             NUMBER(5)                  NOT NULL, 
  GIR_DETAIL_ID      NUMBER(2)                  NOT NULL,
  GIR_QTY            NUMBER                     NOT NULL,
  STORE_BALANCE_QTY  NUMBER                     NOT NULL,
  RATE               NUMBER                     NOT NULL
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


CREATE UNIQUE INDEX INV_PR_DETAIL_PK ON INV_PR_DETAIL
(PR_ID, PR_DETAIL_ID)
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


ALTER TABLE INV_PR_DETAIL ADD (
  CONSTRAINT PR_DETAIL_PK
 PRIMARY KEY
 (PR_ID, PR_DETAIL_ID)
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

ALTER TABLE INV_PR_DETAIL ADD (
  CONSTRAINT PR_DET_GIR_FK  FOREIGN KEY (GIR_DETAIL_ID) REFERENCES INV_GIR_DETAIL (GIR_DETAIL_ID),
  CONSTRAINT PR_DETAIL_SC_FK FOREIGN KEY (SC_ID) REFERENCES INV_SC (SC_ID),
  CONSTRAINT PR_DET_PR_FK FOREIGN KEY (PR_ID) REFERENCES INV_PR (PR_ID));   
  -------------------------
  SELECT igd.igp_id, gd.igp_detail_id, g.voucher_seq,
          igd.igp_id || '/' || igd.igp_detail_id igp_and_igp_detail,
          g.gir_id || '/' || gd.gir_detail_id gir_and_gir_detail,
          DECODE (NVL (t.trans_id, 0), 0, 'NO', 'YES') trx, pdv.po_id, pdv.l1,
          pdv.l2, pdv.l3, pdv.l4, pdv.l5, '' ygp, g.gir_id, pdv.po_date,
          t.issue_value cr_amount, t.rec_value dr_amount, t.trans_id,
          t.trans_year, g.user_id, inv_igp_qty (gd.igp_detail_id) igp_qty,
          v.voucher_id, v.voucher_month_id, v.voucher_type_id,
          
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
          
          --(pdv.sales_tax) * (gd.received_qty - gd.rejected_qty) sales_tax,
          g.status_id status_name, pdv.unit_id, pdv.unit_id uom_id,
          
          ---g.igp_id, g.igp_year,

          ---g.igp_id  igp,
          gd.igp_detail_id,
                           --- pdv.igp_date,
                           pr.issue_qty pr_qty, pdv.color, pdv.cpo_id
     FROM inv_gir g,
          inv_gir_detail gd,
          inv_igp_detail igd,
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
      AND (gd.gir_detail_id = t.gir_detail_id(+))
----
      AND (gd.igp_detail_id = igd.igp_detail_id);
  -------------------------
---  CREATE OR REPLACE FORCE VIEW cmi1.pr_detail_view AS
   SELECT DECODE (NVL (t.trans_id, 0), 0, 'NO', 'YES') trx, t.trans_id,
          t.trans_year, t.issue_value cr_amount, t.rec_value dr_amount,
          p.pr_id || '/' || p.pr_year pr_no, p.pr_id, p.pr_year, p.pr_date,
          p.supplier_id, p.user_id, p.fdatetime, p.remarks, p.status_id,
          p.issued_to, pd.pr_detail_id, pd.gir_id, pd.gir_year,
          pd.gir_detail_id, pd.gir_qty, pd.issue_qty pr_qty, pd.rate,
          pd.issue_qty issue_qty, pd.sc_main_id, pd.sc_sub_id, pd.sc_id,
          pd.store_balance_qty, pd.VALUE, sc.sc_desc, sc.store_code,
          sc.sc_main_desc, sc.sc_sub_desc,
          sc.sc_main_desc || '/' || sc.sc_sub_desc main_sub_desc,
          pd.gir_id || '/' || pd.gir_year || '/' || pd.gir_detail_id gir_no,
          sup.description supplier_name, sc.unit_id, v.voucher_no, g.po_id,
          g.po_year, g.po_detail_id, g.po_type
     FROM inv_pr p,
          inv_pr_detail pd,
          ac_coa_view sup,
          inv_sc_view sc,
          ---ac_voucher_detail_summary_view1 v,
          inv_gir_detail_view g,
          inv_trans t
    WHERE p.pr_id = pd.pr_id
      AND p.pr_year = pd.pr_year
      AND pd.sc_main_id = sc.sc_main_id
      AND pd.sc_sub_id = sc.sc_sub_id
      AND pd.sc_id = sc.sc_id
      AND p.supplier_id = sup.coa_seq
      AND p.pr_id = v.pr_id(+)
      AND p.pr_year = v.pr_year(+)
      AND pd.gir_id = g.gir_id
      AND pd.gir_detail_id = g.gir_detail_id
      AND pd.gir_year = g.gir_year
      ---
      AND pd.pr_id = t.pr_id(+)
      AND pd.pr_year = t.pr_year(+)
      AND pd.pr_detail_id = t.pr_detail_id(+);            