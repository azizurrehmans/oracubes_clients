ALTER TABLE ORACLE4.VOUCHER_TYPE
 ADD CONSTRAINT drorcr_check
 CHECK (drocr in ('DR','CR','ANY'));

