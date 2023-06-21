ALTER TABLE GILLANI.PPC_MP_OP  ADD (EMPLOYEE_ID  NUMBER);
ALTER TABLE GILLANI.HR_SAL_CONT_MO_DETAIL ADD CONSTRAINT HR_SAL_CONT_MO_DETAIL_PK  PRIMARY KEY  (SAL_CONT_ID, EMPLOYEE_ID, SAL_CONT_NO, JCD_ID);
ALTER TABLE GILLANI.HR_SAL_CONT_MO_DETAIL ADD CONSTRAINT sal_cont_mo_det_fkfk  FOREIGN KEY (SAL_CONT_ID, EMPLOYEE_ID, SAL_CONT_NO)  REFERENCES GILLANI.HR_SAL_CONT_DETAIL (SAL_CONT_ID, EMPLOYEE_ID, SAL_CONT_NO);

CREATE OR REPLACE FORCE VIEW prod_jcd_view
AS
   SELECT v.rate op_rate, o.ogp_no, o.bal, ogp_id, ogp_year,
          o.out_qty ogp_out_qty, o.out_qty - o.bal ogp_rec_qty,
          o.in_qty ogp_to_be_in_qty,
          prod_jcd_payment_date (jd.jcd_id) payment_date, c.cpo_id,
          ac_coa_lookup2 (c.our_cpo || '/' || c.cpo_year) cpo_coa_seq,
          c.quantity order_qty, v.stage, v.operation_type stage_name,
          v.rate operation_rate, jd.jcd_id, jd.operation_id,
          jd.qty sub_lot_qty, jd.employee_id, jd.issue_date, jd.rec_date,
          jd.cpo_year, jd.qty issue_qty, jd.POSITION, c.color_id, c.style,
          c.rsize, jd.our_cpo,
             jd.our_cpo
          || '/'
          || jd.cpo_year
          || '/'
          || c.style
          || '/'
          || c.color_id
          || '/'
          || c.rsize
          || '/'
          || jd.jcd_id lot_no,
             jd.our_cpo
          || '/'
          || jd.cpo_year
          || '/'
          || c.color_id
          || '/'
          || c.rsize
          || '/'
          || jd.jcd_id w_lot_no,
          e.NAME, jd.operation_no, jd.status_id,
          CASE
             WHEN jd.rec_qty > 0
                THEN jd.rec_qty
             WHEN o.ogp_no IS NOT NULL
                THEN o.out_qty - o.bal
          END rec_qty,
          jd.rec_user_id rec_status_id, jd.payment_status_id,
          jd.status_id issue_status_id
     FROM prod_jcd jd,
          exp_cpo_detail c,
          hr_employee e,
          exp_cpo_detail_mp_op_view v,
          ac_coa a,
          (SELECT   jcd_id, ogp_no, ogp_id, ogp_year,
                    SUM (ogp_balance_qty) bal, SUM (out_qty) out_qty,
                    SUM (in_qty) in_qty
               FROM inv_ogp_detail_view
              WHERE jcd_id IS NOT NULL
           GROUP BY jcd_id, ogp_no, ogp_id, ogp_year) o
    WHERE jd.our_cpo = c.our_cpo
      AND jd.cpo_year = c.cpo_year
      AND jd.POSITION = c.POSITION
      AND jd.employee_id = e.employee_id(+)
      -----
      AND jd.our_cpo = v.our_cpo
      AND jd.cpo_year = v.cpo_year
      AND jd.POSITION = v.POSITION
      AND jd.operation_no = v.operation_no
      ------
      AND c.cpo_id = a.coa_seq(+)
      ------
      AND jd.jcd_id = o.jcd_id(+);

