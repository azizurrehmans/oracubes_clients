select c.coa, c.description, 
  j.voucher_no,  j.voucher_catagory, j.CR_AMOUNT, j.DR_AMOUNT
from coa_view c,
     (select coa_main_id, coa_sub_id, coa_id, voucher_no, voucher_catagory, sum(dr_amount) dr_amount, sum(cr_amount) cr_amount 
      from 
        voucher_detail_view_new v,        
        (select coa_main_id, coa_sub_id, coa_id, max(voucher_date) voucher_date
        from voucher_detail_view_new
        where voucher_catagory='JV'
        group by coa_main_id,coa_sub_id, coa_id) vd
      where v.voucher_catagory = 'JV' 
      and v.coa_main_id = vd.coa_main_id
      and v.coa_sub_id= vd.coa_sub_id
      and v.coa_id = cd.coa_id
      and v.voucher_date = cd.voucher_date) vd 
        
      group by coa_main_id, coa_sub_id, coa_id, voucher_no, voucher_catagory) j
      
     where c.coa_main_id = 3 and c.coa_sub_id = 4 and c.coa_id = 1 
     and c.coa_main_id = j.COA_MAIN_ID(+)
     and c.coa_sub_id = j.coa_sub_id(+)
     and c.coa_id = j.coa_id(+)
