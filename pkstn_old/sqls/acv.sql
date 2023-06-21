DROP VIEW ADDOS.HR_SAL_ADV_CONT_DATE_VIEW;

/* Formatted on 2022/02/24 18:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW addos.hr_sal_adv_cont_date_view (adv_date,
                                                              amount)
AS
   SELECT   TRUNC (fdatetime) adv_date, SUM (amount) amount
       FROM hr_sal_adv_cont
   GROUP BY TRUNC (fdatetime);


