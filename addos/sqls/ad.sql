create or replace view prod_jcd_stg_stl_op_cost_view
as
select 
    j.CPO_ID,  
    j.STAGE, j.STAGE_NAME,  sum(j.REC_QTY) rec_qty, sum(j.OPERATION_RATE*j.rec_qty) amount
from prod_jcd_view j
where payment_status_id = 'RELEASE' and rec_date is not null
group by j.cpo_id, j.stage, j.stage_name
order by cpo_id, j.stage, j.stage_name;

-----

CREATE OR REPLACE FORCE VIEW prod_jcd_emp_stl_op_cost_view
AS
   SELECT   j.cpo_id, j.NAME, SUM (j.rec_qty) rec_qty,
            SUM (j.operation_rate * j.rec_qty) amount
       FROM prod_jcd_view j
      WHERE payment_status_id = 'RELEASE' AND rec_date IS NOT NULL
   GROUP BY j.cpo_id, j.NAME
   ORDER BY cpo_id, j.NAME;
   
 CREATE OR REPLACE FORCE VIEW addos.prod_jcd_op_cost_view 
AS
   SELECT   j.cpo_id, j.operation_id, SUM (j.rec_qty) rec_qty,
            SUM (j.operation_rate * j.rec_qty) amount
       FROM prod_jcd_view j
      WHERE payment_status_id = 'RELEASE' AND rec_date IS NOT NULL
   GROUP BY j.cpo_id, j.operation_id
   ORDER BY cpo_id, j.operation_id;
   
CREATE OR REPLACE FORCE VIEW addos.prod_jcd_mo_style_cost_view 
AS
   SELECT   j.cpo_id, j.style, SUM (j.rec_qty) rec_qty,
            SUM (j.operation_rate * j.rec_qty) amount
       FROM prod_jcd_view j
      WHERE payment_status_id = 'RELEASE' AND rec_date IS NOT NULL
   GROUP BY j.cpo_id, j.style
   ORDER BY cpo_id, j.style;
 