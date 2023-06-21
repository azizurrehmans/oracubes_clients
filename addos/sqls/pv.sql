--------------------------------------------------------
--  File created - Thursday-May-12-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View EXP_INV_PAYMENT_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ADDOS"."EXP_INV_PAYMENT_VIEW" ("BANK_VOC_CUSTOMER", "ACCOUNT_NO", "ACCOUNT_TYPE", "BANK_DATE", "BANK_ID", "CUSTOMER_ID", "EFORM_AMOUNT", "BALANCE", "CURRENCY_ID", "EDS", "EXCHANGE_RATE", "VOUCHER_STATUS", "FDATETIME", "FOREIGN_BANK_CHARGES", "FOREIGN_BANK_CHARGES_RS", "INV_PAYMENT_ID", "LCL_BANK_CHARGES", "OTHER", "PACKING_ID", "PAYMENT_IN_FC", "PAYMENT_IN_PK_RS", "STATUS_ID", "USER_ID", "VOUCHER_SEQ", "WH_TAX_ON_EXP", "NET_AMOUNT") AS 
  SELECT i.bank_voc_customer, i.account_no, i.account_type, i.bank_date, i.bank_id, i.customer_id, p.eform_amount, nvl(i.payment_in_fc,0) - nvl(p.eform_amount,0) balance,
          exp_customer.currency_id, i.eds, i.exchange_rate,
          v.status voucher_status, i.fdatetime, i.foreign_bank_charges,
          i.exchange_rate * i.foreign_bank_charges foreign_bank_charges_rs,
          i.inv_payment_id, i.lcl_bank_charges, i.other, i.packing_id,
          i.payment_in_fc, i.exchange_rate * i.payment_in_fc payment_in_pk_rs, 
          i.status_id, i.user_id, i.voucher_seq, i.wh_tax_on_exp,
            - (i.exchange_rate * i.foreign_bank_charges)
          + (i.payment_in_fc * i.exchange_rate)
          - NVL (i.eds, 0)
          --+ NVL(i.FOREIGN_BANK_CHARGES_RS,0)
          - NVL (i.lcl_bank_charges, 0)
          - NVL (i.other, 0)
          - NVL (i.payment_in_pk_rs, 0)
          - NVL (i.wh_tax_on_exp, 0) net_amount
     FROM exp_payment i, ac_coa_view c, ac_voucher_det v, exp_customer,
          (select inv_payment_id, sum(qty*eform_rate) eform_amount 
           from exp_packing p1, exp_packing_detail pd1
           where p1.packing_id = pd1.packing_id
           group by inv_payment_id) p
    WHERE i.customer_id = c.coa_seq(+)
      AND i.voucher_seq = v.voucher_seq(+)
      AND i.customer_id = exp_customer.customer_id                                  
      and i.inv_payment_id = p.inv_payment_id(+)
;
