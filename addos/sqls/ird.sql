DROP VIEW ADDOS.INV_IR_DETAIL_VIEW;

/* Formatted on 2023/01/01 20:55 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW addos.inv_ir_detail_view (cpo_id,
                                                       department_id,
                                                       batch_no,
                                                       doc_no,
                                                       color,
                                                       ir,
                                                       ir_yearly_id,
                                                       ir_id,
                                                       trans_issue_rate,
                                                       req_qty,
                                                       customer_id,
                                                       stn,
                                                       rate,
                                                       amount,
                                                       COST,
                                                       profit,
                                                       uom_id,
                                                       unit_id,
                                                       ir_type,
                                                       user_id,
                                                       ir_date,
                                                       fdatetime,
                                                       issued_to,
                                                       status_id,
                                                       ir_detail_id,
                                                       sc_id,
                                                       issue_qty,
                                                       sc_desc,
                                                       description,
                                                       sc_description,
                                                       address,
                                                       cell,
                                                       contact_person,
                                                       credit_days,
                                                       currency_id,
                                                       customer,
                                                       ntn_no,
                                                       phone,
                                                       stn_no
                                                      )
AS
   SELECT  --inv_sale_return_qty (ird.ir_detail_id) returned_qty, i.payment,
           --  ird.issue_qty - inv_sale_return_qty (ird.ir_detail_id) bal_qty,
          i.cpo_id, i.department_id, i.batch_no, i.doc_no, scv.color,
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


