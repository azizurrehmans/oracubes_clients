DROP VIEW ADDOS.EXP_PACKING_VIEW;

/* Formatted on 2022/12/28 12:04 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW addos.exp_packing_view (amount_settled,
                                                     eform_amount,
                                                     low_amt_balance,
                                                     inv_payment_id,
                                                     qty,
                                                     fc_amount,
                                                     sale_jv_seq,
                                                     cartons,
                                                     ship_by,
                                                     gross_wt,
                                                     eform_amount_1,
                                                     cpos,
                                                     pinos,
                                                     pos,
                                                     awbs,
                                                     all_awbs,
                                                     status,
                                                     voucher_status,
                                                     exchange_rate,
                                                     dr_amount,
                                                     cr_amount,
                                                     balance,
                                                     packing,
                                                     awb,
                                                     awb_date,
                                                     carton_dimensions,
                                                     cnic,
                                                     cnic_issue_date,
                                                     cnic_issue_place,
                                                     commision,
                                                     country,
                                                     currency,
                                                     customer_address,
                                                     customer_id,
                                                     customer_name,
                                                     customs_desc,
                                                     departure,
                                                     despatched_to,
                                                     destination,
                                                     discount,
                                                     eform_date,
                                                     eform_no,
                                                     exp_reg_date,
                                                     exp_reg_no,
                                                     fdatetime,
                                                     freight_ins,
                                                     full_address,
                                                     gir,
                                                     lc_bank,
                                                     lc_date,
                                                     lc_no,
                                                     packing_date,
                                                     packing_id,
                                                     packing_year,
                                                     phone,
                                                     product,
                                                     sro,
                                                     sro_date,
                                                     status_id,
                                                     tax_circle,
                                                     user_id
                                                    )
AS
   SELECT NVL (low_pay.amount, 0) amount_settled,
          NVL (eform_amount, 0) eform_amount,
          ABS (NVL (low_pay.amount, 0)
               - NVL (eform_amount, 0)) low_amt_balance, p.inv_payment_id,
          pd.qty, pd.amount fc_amount, sale_jv_seq, pd.cartons, p.ship_by,
          pd.gross_wt, pd.eform_amount, exp_packing_cpos (p.packing_id) cpos,
          exp_packing_pis (p.packing_id) pinos,
          exp_packing_pos (p.packing_id) pos,
          exp_packing_awbs (p.packing_id) awbs,
          exp_packing_all_awbs (p.packing_id) all_awbs, p.status_id status,
          v.status voucher_status, exchange_rate,
          pd.amount * exchange_rate dr_amount, inv.amount cr_amount,
          NVL (pd.amount * exchange_rate, 0) - NVL (inv.amount, 0) balance,
          p.packing_id packing, p.awb, p.awb_date, p.carton_dimensions,
          p.cnic, p.cnic_issue_date, p.cnic_issue_place, p.commision,
          p.country, c.currency_id currency, p.customer_address,
          p.customer_id, p.customer_name, p.customs_desc, p.departure,
          p.despatched_to, p.destination, p.discount, p.eform_date,
          p.eform_no, p.exp_reg_date, p.exp_reg_no, p.fdatetime,
          p.freight_ins, p.full_address, p.gir, p.lc_bank, p.lc_date, p.lc_no,
          p.packing_date, p.packing_id, p.packing_year, p.phone, p.product,
          p.sro, p.sro_date, p.status_id, p.tax_circle, p.user_id
     FROM exp_packing p,
          exp_customer c,
          ac_voucher_det v,
          (SELECT   packing_id, packing_year, customer_id, SUM (qty) qty,
                    MAX (parcel_no) cartons, SUM (gross_wt) gross_wt,
                    SUM (NVL (qty, 0) * NVL (eform_rate, 0)) eform_amount,
                    SUM (rate) rate, SUM (NVL (qty, 0) * NVL (rate, 0))
                                                                       amount
               FROM exp_packing_detail
           GROUP BY packing_id, packing_year, customer_id) pd,
          (SELECT   packing_id,                               ---packing_year,
                               customer_id, SUM (payment_in_pk_rs) amount
               FROM exp_inv_payment_view
           GROUP BY packing_id, customer_id) inv,              --packing_year,
          (SELECT   packing_id, SUM (amount) amount
               FROM exp_packing_payment
           GROUP BY packing_id) low_pay
    WHERE p.customer_id = c.customer_id(+)
      ---
      AND p.packing_id = low_pay.packing_id(+)
      ---
      AND p.packing_id = pd.packing_id(+)
      -- AND p.packing_year = pd.packing_year(+)
      AND p.customer_id = pd.customer_id(+)
      ---
      AND p.packing_id = inv.packing_id(+)
      -- AND p.packing_year = inv.packing_year(+)
      AND p.customer_id = inv.customer_id(+)
      ---
      AND p.sale_jv_seq = v.voucher_seq(+);


