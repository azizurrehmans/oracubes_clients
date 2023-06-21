CREATE OR REPLACE FORCE VIEW hr_sal_cont_view 
AS
   SELECT   sc.acv, sc.ajv, sc.fdatetime, sc.sal_cont_id, sc.sal_cont_no,
            sc.status_id, sc.user_id, SUM (scd.earning) earning,
            SUM (scd.fine) fine, SUM (scd.loan_closing) loan_closing,
            SUM (scd.loan_ded) loan_ded, SUM (scd.loan_opening) loan_opening,
            SUM (scd.salary) salary, SUM (scd.salary_advance) salary_advance
       FROM hr_sal_cont sc, hr_sal_cont_detail scd
      WHERE sc.sal_cont_id = scd.sal_cont_id
        AND sc.sal_cont_no = scd.sal_cont_no
   GROUP BY sc.acv,
            sc.ajv,
            sc.fdatetime,
            sc.sal_cont_id,
            sc.sal_cont_no,
            sc.status_id,
            sc.user_id;
