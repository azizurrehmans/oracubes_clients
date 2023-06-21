DROP VIEW ADDOS.INV_TRANS_VIEW;

/* Formatted on 2023/01/01 20:55 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW addos.inv_trans_view (department_id,
                                                   item_status,
                                                   trans_id,
                                                   trans_year,
                                                   color,
                                                   cpo_id,
                                                   trans_date,
                                                   ir_order_info,
                                                   unit_id,
                                                   MONTH,
                                                   trans_month,
                                                   period,
                                                   trans_type,
                                                   gir_id,
                                                   gir_detail_id,
                                                   ir_id,
                                                   ir_detail_id,
                                                   ir_type,
                                                   gir_no,
                                                   ir_no,
                                                   remarks,
                                                   status_id,
                                                   fdatetime,
                                                   user_id,
                                                   issue_qty,
                                                   issue_value,
                                                   rec_qty,
                                                   rec_value,
                                                   sc_code,
                                                   store_code,
                                                   item_description,
                                                   to_from,
                                                   sc_id,
                                                   issued_to
                                                  )
AS
   SELECT t.department_id, t.item_status, t.trans_id, t.trans_year, sc.color,
          i.cpo_id, t.trans_date, NULL ir_order_info, sc.unit_id,
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
          inv_sc_view sc,
          inv_ir_detail_view i
--- PRODUCTION.JOB_CARD_VIEW J
   WHERE  (t.gir_detail_id = g.gir_detail_id(+))
      AND (t.ir_detail_id = i.ir_detail_id(+))
      AND (t.ir_id = idv.ir_id(+) AND t.ir_detail_id = idv.ir_detail_id(+))
---
      AND t.sc_id = sc.sc_id;


