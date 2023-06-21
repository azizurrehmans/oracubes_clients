create or replace view stu_adm_monthly_view
as
select trunc(a.rec_sys_date,'month') month, trunc(a.rec_sys_date,'year') year, count(*) admissions, sum(ad.amount) amount
from stu_adm_challan a, 
     (select challan_id, sum(amount) amount from stu_adm_challan_det group by challan_id) ad
where a.rec_sys_date is not null
  and a.challan_id = ad.challan_id
group by trunc(a.rec_sys_date,'month'), trunc(a.rec_sys_date,'year') ;


create or replace view stu_adm_monthly_class_view
as
select trunc(a.rec_sys_date,'month') month, class, count(*) admissions, sum(ad.amount) amount
from stu_adm_challan a, 
     (select challan_id, sum(amount) amount from stu_adm_challan_det group by challan_id) ad
where a.rec_sys_date is not null
  and a.challan_id = ad.challan_id
group by trunc(a.rec_sys_date,'month'),  class
order by month, class;

create or replace view stu_adm_date_view
as
select trunc(a.rec_sys_date,'month') month, trunc(a.rec_sys_date) admission_date, count(*) admissions, sum(ad.amount) amount
from stu_adm_challan a, 
     (select challan_id, sum(amount) amount from stu_adm_challan_det group by challan_id) ad
where a.rec_sys_date is not null
  and a.challan_id = ad.challan_id
group by trunc(a.rec_sys_date,'month'), trunc(a.rec_sys_date)
order by month, admission_date;


create or replace view stu_adm_yearly_view
as
select trunc(a.rec_sys_date,'YEAR') year, count(*) admissions, sum(ad.amount) amount
from stu_adm_challan a, 
     (select challan_id, sum(amount) amount from stu_adm_challan_det group by challan_id) ad
where a.rec_sys_date is not null
  and a.challan_id = ad.challan_id
group by trunc(a.rec_sys_date,'YEAR');

------

create or replace view stu_fee_yearly_view
as
select trunc(a.rec_sys_date,'YEAR') year, count(*) fees, sum(ad.amount) amount
from stu_fee a, 
     (select challan_id, sum(amount) amount from stu_fee_det group by challan_id) ad
where a.rec_sys_date is not null
  and a.challan_id = ad.challan_id
group by trunc(a.rec_sys_date,'YEAR');

create or replace view stu_fee_monthly_view
as
select trunc(a.rec_sys_date,'month') month, trunc(a.rec_sys_date,'year') year, count(*) fees, sum(ad.amount) amount
from stu_fee a, 
     (select challan_id, sum(amount) amount from stu_fee_det group by challan_id) ad
where a.rec_sys_date is not null
  and a.challan_id = ad.challan_id
group by trunc(a.rec_sys_date,'month'), trunc(a.rec_sys_date,'year') ;


create or replace view stu_fee_date_view
as
select trunc(a.rec_sys_date,'month') month, trunc(a.rec_sys_date) fee_date, count(*) fees, sum(ad.amount) amount
from stu_fee a, 
     (select challan_id, sum(amount) amount from stu_fee_det group by challan_id) ad
where a.rec_sys_date is not null
  and a.challan_id = ad.challan_id
group by trunc(a.rec_sys_date,'month'), trunc(a.rec_sys_date) ;