DROP VIEW ADDOS.EXP_CPO_JCD_VIEW;

/* Formatted on 2021/11/16 14:17 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW addos.exp_cpo_jcd_view (cpo_id
,                                                    cpo_year
,                                                    our_cpo
,                                                    style
,                                                    color_id
,                                                    rsize
,                                                    op_remarks
,                                                    operation_type
,                                                    quantity
,                                                    POSITION
,                                                    prod_qty
,                                                    stage
,                                                    operation_no
,                                                    op_no
,                                                    operation_id
,                                                    mp_id
,                                                    customer_id
,                                                    issue_qty
,                                                    issue_balance
,                                                    receive_qty
,                                                    receive_balance
,                                                    prod_balance
,                                                    issuable_balance
,                                                    prod_balance_1
                                                    )
AS
   SELECT c.cpo_id, c.cpo_year, c.our_cpo, style, color_id, c.rsize
,         c.op_remarks, c.operation_type, c.quantity, c.POSITION, c.prod_qty
,         c.stage, c.operation_no, c.operation_no op_no, c.operation_id
,         c.mp_id, c.customer_id, NVL (ji.issue_qty, 0) issue_qty
,         c.prod_qty - NVL (ji.issue_qty, 0) issue_balance
,         NVL (jr.receive_qty, 0) receive_qty
,         
          ---  NVL(OGP_REC_QTY,0) OGP_REC_QTY,
          NVL (ji.issue_qty, 0) - NVL (jr.receive_qty, 0) receive_balance
,         0 prod_balance
,         prod_issuable_balance (c.our_cpo
,                                c.POSITION
,                                c.operation_no
,                                c.prod_qty
,                                c.stage
                                ) issuable_balance
,         NVL (c.prod_qty, 0) - NVL (jr.receive_qty, 0) prod_balance
     FROM exp_cpo_detail_mp_op_view c
,         (SELECT   our_cpo, POSITION, operation_no, operation_id
,                   operation_type, NVL (SUM (qty), 0) issue_qty
               FROM prod_jcd j
              WHERE j.issue_date IS NOT NULL
           GROUP BY our_cpo
,                   POSITION
,                   operation_no
,                   operation_id
,                   operation_type) ji
,         (SELECT   our_cpo, POSITION, operation_no, operation_id
,                   operation_type
,                     NVL (SUM (rec_qty), 0)
                    + SUM (NVL (prod_jcd_ogp_rec_qty (jcd_id), 0))
                                                                  receive_qty
               FROM prod_jcd j
              WHERE j.rec_date IS NOT NULL OR prod_jcd_ogp_rec_qty (jcd_id) >
                                                                             0
           GROUP BY our_cpo
,                   POSITION
,                   operation_no
,                   operation_id
,                   operation_type) jr
    WHERE c.our_cpo = ji.our_cpo(+)
      ---    AND c.cpo_year = ji.cpo_year(+)
      AND c.POSITION = ji.POSITION(+)
      AND c.operation_id = ji.operation_id(+)
      AND c.operation_type = ji.operation_type(+)
      AND c.operation_no = ji.operation_no(+)
-----
      AND c.our_cpo = jr.our_cpo(+)
      ---     AND c.cpo_year = jr.cpo_year(+)
      AND c.POSITION = jr.POSITION(+)
      AND c.operation_id = jr.operation_id(+)
      AND c.operation_type = jr.operation_type(+)
      AND c.operation_no = jr.operation_no(+);


