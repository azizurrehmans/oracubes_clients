DROP VIEW ALNAEEM.INV_IR_DETAIL_VIEW;

/* Formatted on 2022/02/21 15:18 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW alnaeem.inv_ir_detail_view (incentive,
                                                         discount_per,
                                                         l1,
                                                         l2,
                                                         l3,
                                                         l4,
                                                         l5,
                                                         returned_qty,
                                                         payment,
                                                         advance_tax_per,
                                                         rate_bf_discount,
                                                         discount,
                                                         rec_qty,
                                                         previous_bal,
                                                         previous_bal_date,
                                                         bal_qty,
                                                         ir,
                                                         ir_yearly_id,
                                                         ir_id,
                                                         trans_issue_rate,
                                                         ir_remarks,
                                                         add_stn,
                                                         customer_id,
                                                         stn,
                                                         advance_tax_amt,
                                                         rate,
                                                         amount,
                                                         COST,
                                                         profit,
                                                         uom_id,
                                                         unit_id,
                                                         ir_type,
                                                         payment_mode,
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
   SELECT i.incentive, ird.discount discount_per, scv.l1, scv.l2, scv.l3,
          scv.l4, scv.l5, inv_sale_return_qty (ird.ir_detail_id) returned_qty,
          i.payment, i.advance_tax_per, ird.rate_bf_discount, i.discount,
          0 rec_qty, i.previous_bal, i.previous_bal_date,
          ird.issue_qty - inv_sale_return_qty (ird.ir_detail_id) bal_qty,
          i.ir_yearly_id || '/' || i.ir_year ir, i.ir_yearly_id, i.ir_id,
          CASE
             WHEN t.issue_value = 0 OR t.issue_qty = 0
                THEN 0
             ELSE t.issue_value / t.issue_qty
          END trans_issue_rate,
          i.remarks ir_remarks,
          CASE
             WHEN i.add_stn IS NOT NULL
                THEN (ird.rate * ird.issue_qty) * 0.02
             ELSE 0
          END add_stn,
          i.customer_id, (ird.rate * ird.issue_qty) * 0.17 stn,
            (ird.rate * ird.issue_qty)
          * NVL (advance_tax_per, 0)
          * 0.01 advance_tax_amt,
          ird.rate, ird.rate * ird.issue_qty amount,
          CASE
             WHEN scv.profitable = 'YES'
                THEN inv_sc_avg_rate (ird.sc_id, ir_date)
                     * ird.issue_qty
             WHEN scv.profitable = 'NO'
                THEN (ird.rate * ird.issue_qty)
          END COST,
          
          --inv_sc_avg_rate (ird.sc_id, ir_date) * ird.issue_qty COST,
          CASE
             WHEN scv.profitable = 'YES'
                THEN   (ird.rate * ird.issue_qty)
                     - (inv_sc_avg_rate (ird.sc_id, ir_date) * ird.issue_qty)
             WHEN scv.profitable = 'NO'
                THEN 0
          END profit,
          scv.uom_id, scv.uom_id unit_id, i.ir_type, i.payment_mode,
          i.user_id, i.ir_date, i.fdatetime, i.issued_to, i.status_id,
          ird.ir_detail_id, ird.sc_id, ird.issue_qty, scv.description sc_desc,
          scv.description, scv.item_description sc_description, c.address,
          c.cell, c.contact_person, c.credit_days, c.currency_id,
          c.description customer, c.ntn ntn_no, c.phone, c.stn stn_no
     FROM inv_ir_detail ird, inv_sc_view scv, inv_ir i, ac_coa c, inv_trans t
    WHERE ird.sc_id = scv.sc_id(+)
      AND ird.ir_id = i.ir_id
      ---
      AND i.customer_id = c.coa_seq
      ---
      AND ird.ir_detail_id = t.ir_detail_id(+);


