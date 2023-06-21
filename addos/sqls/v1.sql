DROP VIEW ADDOS.EXP_CARTON_DET_VIEW;

/* Formatted on 2022/12/12 17:10 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW addos.exp_carton_det_view (carton_id,
                                                        customer_id,
                                                        fdatetime,
                                                        item_id,
                                                        status,
                                                        user_id,
                                                        customer,
                                                        cpo_detail_id
                                                       )
AS
   SELECT c.carton_id, c.customer_id, c.fdatetime, c.item_id, c.status,
          c.user_id, cu.description customer, i.cpo_detail_id
     FROM exp_carton c, exp_customer cu, exp_cpo_det_pcs i
    WHERE c.customer_id = cu.customer_id AND c.item_id = i.item_id;


