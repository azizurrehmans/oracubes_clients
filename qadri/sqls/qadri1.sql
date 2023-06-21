SELECT i.igp_yearly_id || '/' || i.igp_year igp, gst, s.currency,
          i.igp_yearly_id, i.bill_date, i.voucher_seq, i.payment_mode,
          --NVL (igd.amount, 0) + NVL (ige.amount, 0) total_amount,
         -- supp_qty - reject_qty - short_qty accepted_qty,
         --- NVL (igd.amount, 0) amount, --NVL (ige.amount, 0) expense_amount,
          i.bill_no, i.fdatetime, i.igp_date, i.igp_id, i.igp_type,
          i.igp_year, i.payment_status, i.remarks, i.status_id, i.supplier_id,
          s.description supplier, i.taken_in_by, i.taken_in_datetime,
          i.user_id, i.vehicle_no, i.vehicle_type
     FROM inv_igp i,
          ac_coa s /*,
          (SELECT   SUM (amount) amount, SUM (supp_qty) supp_qty,
                    SUM (reject_qty) reject_qty, SUM (short_qty) short_qty,
                    igp_id
               FROM inv_igp_detail_view
           GROUP BY igp_id) igd  /*,
          (SELECT   SUM (amount) amount, igp_id
               FROM inv_igp_expense
           GROUP BY igp_id) ige*/
    WHERE i.supplier_id = s.coa_seq(+) 
     --- AND i.igp_id = igd.igp_id(+)
     -- AND i.igp_id = ige.igp_id(+)