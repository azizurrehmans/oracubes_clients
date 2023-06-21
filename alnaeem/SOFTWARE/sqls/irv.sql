DROP VIEW ALNAEEM.INV_IR_VIEW;

/* Formatted on 2022/02/21 15:19 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW alnaeem.inv_ir_view (ir,
                                                  ir_yearly_id,
                                                  discount,
                                                  advance_tax_per,
                                                  advance_tax_amt,
                                                  qty,
                                                  ir_no,
                                                  payment,
                                                  voucher_seq,
                                                  remarks,
                                                  ir_remarks,
                                                  ir_stn,
                                                  ir_add_stn,
                                                  ir_amount,
                                                  net_amount,
                                                  ir_cost,
                                                  add_stn,
                                                  customer_id,
                                                  stn,
                                                  payment_mode,
                                                  ir_type,
                                                  user_id,
                                                  ir_id,
                                                  ir_year,
                                                  ir_date,
                                                  fdatetime,
                                                  issued_to,
                                                  status_id,
                                                  address,
                                                  cell,
                                                  contact_person,
                                                  credit_days,
                                                  currency_id,
                                                  customer_name,
                                                  ntn_no,
                                                  phone,
                                                  stn_no,
                                                  ir_profit
                                                 )
AS
   SELECT i.ir_yearly_id || '/' || i.ir_year ir, i.ir_yearly_id, discount,
          advance_tax_per, advance_tax_amt, qty,
          i.ir_yearly_id || '/' || i.ir_year ir_no, i.payment, i.voucher_seq,
          i.remarks, i.remarks ir_remarks, ird.ir_stn, ird.ir_add_stn,
          ird.ir_amount,
          NVL (ird.ir_amount, 0) - NVL (i.discount, 0) net_amount,
          ird.ir_cost, i.add_stn, i.customer_id, i.stn, i.payment_mode,
          i.ir_type, i.user_id, i.ir_id, i.ir_year, i.ir_date, i.fdatetime,
          i.issued_to, i.status_id, c.address, c.cell, c.contact_person,
          c.credit_days, c.currency_id, c.description customer_name,
          c.ntn ntn_no, c.phone, c.stn stn_no, ir_profit
     FROM inv_ir i,
          ac_coa c,
          (SELECT   ir_id, ROUND (SUM (NVL (amount, 0)), 2) ir_amount,
                    ROUND (SUM (NVL (COST, 0)), 2) ir_cost,
                    ROUND (SUM (NVL (profit, 0)), 2) ir_profit,
                    ROUND (SUM (NVL (stn, 0)), 2) ir_stn,
                    ROUND (SUM (NVL (add_stn, 2)), 2) ir_add_stn,
                    ROUND (SUM (NVL (advance_tax_amt, 2)), 2) advance_tax_amt,
                    SUM (issue_qty) qty
               FROM inv_ir_detail_view
           GROUP BY ir_id) ird
    WHERE i.customer_id = c.coa_seq AND i.ir_id = ird.ir_id(+);


