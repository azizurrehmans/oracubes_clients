view inv_sc_desc
inv_po_detail_view
create or replace view hr_sal_adv_cont_date_view
as
select distinct(trunc(fdatetime)) adv_date from hr_sal_adv_cont 