ALTER TABLE ADDOS.EXP_CPO_DET_PCS RENAME COLUMN pcs_id TO item_ID;

CREATE OR REPLACE FORCE VIEW addos.exp_cpo_det_pcs_view 
AS
   SELECT p.cpo_detail_id, p.label, p.NAME, p.numbers, p.item_id, d.cpo_id, p.item_id pcs_id,
          c.customer_id, cu.description customer
     FROM exp_cpo_det_pcs p, exp_cpo_detail d, exp_cpo c, exp_customer cu
    WHERE p.cpo_detail_id = d.cpo_detail_id
      AND d.cpo_id = c.cpo_id
      AND c.customer_id = cu.customer_id;

