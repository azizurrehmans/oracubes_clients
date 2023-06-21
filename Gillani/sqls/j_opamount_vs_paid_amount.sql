select customer_id, our_cpo, cpo_year, operation_type, style, color_id, sum(prod_qty) prod_qty, sum(receive_qty) receive_qty, sum(issue_qty) issue_qty,  sum(op_amount) op_amount, sum(paid_amount) paid_amount
from exp_cpo_jcd_view
group by customer_id, our_cpo, cpo_year, operation_type, style, color_id
order by our_cpo