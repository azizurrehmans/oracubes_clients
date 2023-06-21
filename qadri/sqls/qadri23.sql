delete from ac_voucher_detail where voucher_seq in (select voucher_seq from ac_voucher where voucher_date <= '30-jun-2021');

delete from inv_trans where ir_id in (select ir_id from inv_ir where trunc(ir_date) <= '30-jun-2021');
delete from inv_ir_detail where ir_id in (select ir_id from inv_ir where trunc(ir_date) <= '30-jun-2021');
delete from inv_ir where trunc(ir_date) <= '30-jun-2021';

delete from inv_trans where igp_id in (select igp_id from inv_igp where igp_date <= '30-jun-2021');
delete from inv_igp_detail where igp_id in (select igp_id from inv_igp where igp_date <= '30-jun-2021');
delete from inv_igp where igp_date <= '30-jun-2021';

delete from inv_trans where pr_id in (select pr_id from inv_pr where trunc(pr_date) <= '30-jun-2021');
delete from inv_trans where trans_type = 'PR' and pr_id is null and trans_date <= '30-jun-2021';
delete from inv_pr_detail where  pr_id in (select pr_id from inv_pr where trunc(pr_date) <= '30-jun-2021');
delete from inv_pr where trunc(pr_date) <= '30-jun-2021';

delete from inv_trans where btn_id in (select btn_id from inv_btn where trunc(btn_date) <= '30-jun-2021');
delete from inv_btn where trunc(btn_date) <= '30-jun-2021';

delete from ac_voucher where voucher_date <= '30-jun-2021' ; 

select count(*) from ac_voucher where voucher_date <= '30-jun-2021';
select trans_type, count(*) from inv_trans where trans_date <= '30-jun-2021' group by trans_type;
select count(*) from qadri1.inv_trans;
select btn_id, btn_date from inv_btn where btn_id in (select btn_id from inv_trans where trans_date <= '30-jun-2021' and trans_type='BTN');
select pr_id, pr_date from inv_pr where pr_id in (select pr_id from inv_trans where trunc(trans_date) <= '30-jun-2021' and trans_type='PR');
select trans_type, pr_id, trans_date from inv_trans where trans_type = 'PR' and trans_date <= '30-jun-2021';