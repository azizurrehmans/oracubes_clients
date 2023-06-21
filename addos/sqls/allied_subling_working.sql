update stu_hist_det s set mon_amount=3900 
where s.fee_head_id = 1 
      and trunc(s.fdatetime) = '03-mar-2023' 
      and s.student_id in (select student_id from stu_hist_det 
                                        where mon_amount = 3500 and fee_head_id=1);
                                        
--select count(*) from stu                                        

select * from stu_hist_det 
where trunc(fdatetime) = '03-mar-2023' 
  and fee_head_id = 1 
  and student_id in (select student_id from stu_hist_det where mon_amount = 3500);
select distinct trunc(fdatetime) from stu_history order by trunc(fdatetime) desc;

select challan_id from stu_fee where class not in ('NURSERY','PREP') AND (trunc(fdatetime) = '03-mar-2023' OR FEE_MONTH='01-MAR-2023');

delete from stu_monthly_challan_no where challan_id in (select challan_id from stu_fee where class not in ('NURSERY','PREP') AND (trunc(fdatetime) = '03-mar-2023' OR FEE_MONTH='01-MAR-2023') ) ;
delete from stu_fee_det where challan_id in (select challan_id from stu_fee where class not in ('NURSERY','PREP') AND (trunc(fdatetime) = '03-mar-2023' OR FEE_MONTH='01-MAR-23') ) ;
delete from stu_fee where challan_id in (select challan_id from stu_fee where class not in ('NURSERY','PREP') AND (trunc(fdatetime) = '03-mar-2023' OR FEE_MONTH='01-MAR-23') ) ;
---delete from stu_monthly_challan_no where challan_id in (select challan_id from stu_fee where (trunc(fdatetime) = '04-mar-2023' OR FEE_MONTH='01-MAR-2023') ) ;

delete from stu_monthly_challan_no where challan_id = 14303;
delete from stu_fee_det where challan_id = 14303;
delete from stu_fee where challan_id = 14303;

SELECT F.STUDENT_ID, F.CLASS, S.CLASS, CHALLAN_ID, FEE_MONTH FROM STU_FEE F , STU_STUDENT_VIEW S WHERE F.STUDENT_ID = S.STUDENT_ID AND FEE_MONTH = '01-MAR-23' AND F.CLASS <> S.CLASS



