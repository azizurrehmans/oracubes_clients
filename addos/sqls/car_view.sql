DROP VIEW ADDOS.EXP_CARTON_VIEW;

/* Formatted on 2022/12/12 16:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW addos.exp_carton_view (total_items,
                                                    carton_id,
                                                    customer,
                                                    customer_id,
                                                    status,
                                                    start_datetime,
                                                    end_datetime
                                                   )
AS
   SELECT   COUNT (*) total_items, carton_id, customer, customer_id, status,
            MIN (fdatetime) start_datetime, MAX (fdatetime) end_datetime
       FROM exp_carton_det_view
   GROUP BY carton_id, customer, status, customer_id;


