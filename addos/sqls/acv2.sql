DROP VIEW ADDOS.HR_SAL_ADV_CONT_VIEW;

/* Formatted on 2022/02/24 18:44 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW addos.hr_sal_adv_cont_view (voucher_seq,
                                                         employee_id,
                                                         fdatetime,
                                                         reason,
                                                         user_id,
                                                         adv_date,
                                                         amount,
                                                         sav_status,
                                                         sal_adv_cont_id,
                                                         NAME,
                                                         employee_status,
                                                         status_desc,
                                                         voucher_no,
                                                         voucher_id,
                                                         voucher_type_id,
                                                         voucher_month_id
                                                        )
AS
   SELECT sa.voucher_seq, sa.employee_id, sa.fdatetime, sa.reason, sa.user_id,
          TRUNC (sa.fdatetime) adv_date, sa.amount, sa.status_id sav_status,
          sa.sal_adv_cont_id, e.NAME, e.status_id employee_status,
          e.status_id status_desc, voucher_no, voucher_id, voucher_type_id,
          voucher_month_id
     FROM hr_sal_adv_cont sa, hr_employee e, ac_voc_detail_summary_view1 v
    WHERE sa.employee_id = e.employee_id
      AND sa.sal_adv_cont_id = v.loan_id(+)
      AND sa.loan_type = v.loan_type(+);


