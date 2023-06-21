DROP TABLE ADDOS.INV_PR CASCADE CONSTRAINTS;

CREATE TABLE ADDOS.INV_PR
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
TABLESPACE USERS
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

-------

ALTER TABLE ADDOS.INV_PR_DETAIL
 DROP PRIMARY KEY CASCADE;
DROP TABLE ADDOS.INV_PR_DETAIL CASCADE CONSTRAINTS;

CREATE TABLE ADDOS.INV_PR_DETAIL
(
  PR_ID              NUMBER(20)                 NOT NULL,
  PR_DETAIL_ID       NUMBER(6),
  SC_ID              NUMBER(2)                  NOT NULL,
  REQ_QTY            NUMBER(12,6),
  ISSUE_QTY          NUMBER(12,6)               NOT NULL,
  VALUE              NUMBER(14,6)               NOT NULL,
  GIR_ID             NUMBER(5)                  NOT NULL,
  GIR_DETAIL_ID      NUMBER(6)                  NOT NULL,
  GIR_QTY            NUMBER                     NOT NULL,
  STORE_BALANCE_QTY  NUMBER                     NOT NULL,
  RATE               NUMBER                     NOT NULL,
  CUSTOMER_QTY       NUMBER,
  REASON             VARCHAR2(200 BYTE)
)
TABLESPACE USERS
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


CREATE UNIQUE INDEX ADDOS.INV_PR_DETAIL_PK ON ADDOS.INV_PR_DETAIL
(PR_DETAIL_ID)
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


CREATE UNIQUE INDEX ADDOS.INV_PR_DET_SC_UQ ON ADDOS.INV_PR_DETAIL
(PR_ID, GIR_DETAIL_ID)
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


ALTER TABLE ADDOS.INV_PR_DETAIL ADD (
  CONSTRAINT INV_PR_DETAIL_PK
 PRIMARY KEY
 (PR_DETAIL_ID)
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
  CONSTRAINT INV_PR_DET_SC_UQ
 UNIQUE (PR_ID, GIR_DETAIL_ID)
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
-----
CREATE OR REPLACE FORCE VIEW addos.inv_pr_detail_view (supplier_id,
                                                       fdatetime,
                                                       pr_date,
                                                       pr_id,
                                                       remarks,
                                                       status_id,
                                                       user_id,
                                                       voucher_seq,
                                                       customer_qty,
                                                       pr_detail_id,
                                                       rate,
                                                       issue_qty,
                                                       sc_id,
                                                       amount,
                                                       avg_rate,
                                                       balance,
                                                       coa,
                                                       coa_seq,
                                                       description,
                                                       item_description,
                                                       l1,
                                                       l2,
                                                       l3,
                                                       l4,
                                                       l5,
                                                       last_purchase_rate,
                                                       LEVELS,
                                                       sc_desc,
                                                       SPECIFICATION,
                                                       unit_id,
                                                       uom_id,
                                                       customer_name,
                                                       gir_id,
                                                       gir_no,
                                                       gir_qty,
                                                       gir_detail_id,
                                                       issued_to,
                                                       reason
                                                      )
AS
   SELECT p.supplier_id, p.fdatetime, p.pr_date, p.pr_id,
                                                         --p.pr_yearly_id,
                                                         p.remarks,
          p.status_id, p.user_id, p.voucher_seq, pd.customer_qty,
                                                            --pd.ir_detail_id,
          pd.pr_detail_id, pd.rate, pd.issue_qty, pd.sc_id,
                                                 --pd.item_status item_status,
          pd.rate * pd.issue_qty amount, s.avg_rate, s.balance, s.coa,
          s.coa_seq, s.description, s.item_description, s.l1, s.l2, s.l3,
          s.l4, s.l5, s.last_purchase_rate, s.LEVELS,
                                                     --s.sc_id,
                                                     s.sc_desc,
          s.SPECIFICATION, s.unit_id, s.uom_id, c.description customer_name,
          pd.gir_id, pd.gir_id || '/' || pd.gir_detail_id gir_no, pd.gir_qty,
          pd.gir_detail_id, p.issued_to, pd.reason
     FROM inv_pr p, inv_pr_detail pd, inv_sc_view s, ac_coa_view c
    WHERE p.pr_id = pd.pr_id(+) AND pd.sc_id = s.sc_id(+)
          AND p.supplier_id = c.coa_seq(+);
------

CREATE OR REPLACE FORCE VIEW addos.inv_pr_view (amount,
                                                qty,
                                                supplier_id,
                                                ogp_id,
                                                fdatetime,
                                                pr_date,
                                                pr_id,
                                                remarks,
                                                status_id,
                                                user_id,
                                                voucher_seq,
                                                customer_name,
                                                pr
                                               )
AS
   SELECT   SUM (i.amount) amount, SUM (i.customer_qty) qty, i.supplier_id,
            o.ogp_id, i.fdatetime, i.pr_date, i.pr_id, i.remarks, i.status_id,
            i.user_id, i.voucher_seq, i.customer_name, i.pr_id pr
       FROM inv_pr_detail_view i,
            (SELECT ogp_id, pr_id
               FROM inv_ogp) o
      WHERE i.pr_id = o.pr_id(+)
   GROUP BY i.supplier_id,
            i.fdatetime,
            i.pr_date,
            i.pr_id,
            i.remarks,
            i.status_id,
            i.user_id,
            i.voucher_seq,
            i.customer_name,
            o.ogp_id;               


