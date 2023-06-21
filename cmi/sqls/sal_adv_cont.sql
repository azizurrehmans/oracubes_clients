ALTER TABLE ASKARI.SAL_ADV_CONT
 ADD (voucher_seq  NUMBER(8));

ALTER TABLE ASKARI.SAL_ADV_CONT
 ADD CONSTRAINT sal_adv_cont_voucher_seq_fk 
 FOREIGN KEY (voucher_seq) 
 REFERENCES ASKARI.VOUCHER (voucher_seq);

