create or replace view inv_demand_month_view
as
select distinct month_no from inv_demand_view;

select * from inv_demand_month_view;

CREATE OR REPLACE FORCE VIEW sktfoods.inv_demand_monthly_view0 (month_no,
                                                                total_customers,
                                                                bills,
                                                                paid,
                                                                payment_status,
                                                                route_id,
                                                                route,
                                                                demand_status,
                                                                from_date,
                                                                TO_DATE,
                                                                status_id
                                                               )
AS
   SELECT month_no, total_customers, bills, paid, payment_status, route_id,
          route, d.status_id demand_status, from_date, TO_DATE,
          CASE
             WHEN total_customers > 0
             AND bills IS NULL
             AND d.status_id IN ('MIXED', 'HOLD')
                THEN 'NOT READY FOR BILLING'
             WHEN total_customers > 0
             AND bills IS NULL
             AND d.status_id = 'READY FOR BILLING'
                THEN 'READY FOR BILLING'
             WHEN total_customers = bills
                THEN 'BILLS GENERATED'
          END status_id
     FROM (SELECT   m.month_no, COUNT (*) total_customers, m.route_id,
                    m.route, inv_demand_month_status (m.month_no) status_id,
                    from_date, TO_DATE, b.bills bills, b.paid,
                    NULL payment_status, NULL demand_status
               FROM (SELECT   customer_coa_seq, month_no, COUNT (*), route_id,
                              route, MIN (demand_date) from_date,
                              MAX (demand_date) TO_DATE
                         FROM inv_demand_det_view
                        WHERE mode_of_payment = 'MONTHLY'
                     GROUP BY customer_coa_seq, month_no, route_id, route) m,
                    (SELECT   month_no, COUNT (*) bills,
                              COUNT (voucher_seq) paid
                         FROM inv_bill
                     GROUP BY month_no) b
              WHERE m.month_no = b.month_no(+)
           GROUP BY m.month_no,
                    b.bills,
                    b.paid,
                    from_date,
                    TO_DATE,
                    m.route_id,
                    m.route) d;
-------------------------
CREATE OR REPLACE FORCE VIEW sktfoods.inv_demand_monthly_view (bills,
                                                               demand_status,
                                                               month_no,
                                                               paid,
                                                               payment_status,
                                                               status_id,
                                                               route_id,
                                                               route,
                                                               from_date,
                                                               TO_DATE,
                                                               total_customers
                                                              )
AS
   SELECT   v.bills, v.demand_status, v.month_no, v.paid, v.payment_status,
            v.status_id, v.route_id, v.route, MIN (v.from_date) from_date,
            MAX (v.TO_DATE) TO_DATE, SUM (v.total_customers) total_customers
       FROM inv_demand_monthly_view0 v
   GROUP BY v.bills,
            v.demand_status,
            v.month_no,
            v.paid,
            v.payment_status,
            v.status_id,
            v.route_id,
            v.route;                    
                    
                    