delete from stu_fee where challan_id in (
select challan_id from (
select challan_id, student_id, first_name, class, section, amt, arrear, discount_amount,  amount from stu_fee_view 
where challan_id in (select max(challan_id) from stu_fee where rec_bank_date is null and challan_type='MON' and arrear > 0 group by student_id )
order by class_order, section, student_id)
where discount_amount > 0);
-----

---select challan_id from (
select challan_id, student_id, first_name, class, section, amt, arrear, discount_amount,  amount from stu_fee_view 
where challan_id in (select max(challan_id) from stu_fee where rec_bank_date is null and challan_type='MON' and arrear > 0 group by student_id )
and discount_amount > 0;

--order by class_order, section, student_id) where discount_amount > 0);

delete from stu_fee_det where challan_id in (2395,2531,3688,2499,3681,2117,2118,2530,2366,2394,2436,2527,2528);
delete from stu_fee where challan_id in (2395,2531,3688,2499,3681,2117,2118,2530,2366,2394,2436,2527,2528);
delete from stu_monthly_challan_no where challan_id in (2395,2531,3688,2499,3681,2117,2118,2530,2366,2394,2436,2527,2528);