delete from ac_voucher where voucher_seq in (
select voucher_seq from ac_voucher where voucher_seq not in (select voucher_seq from ac_voucher_detail));