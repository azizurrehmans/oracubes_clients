ALTER TABLE ORACLE.TRANS
 DROP CONSTRAINT SYS_C0032318;
ALTER TABLE ORACLE.TRANS
 ADD CHECK ((gir_id is not null and gir_year is not null and gir_detail_id is not null)
or (ir_id is not null and ir_year is not null and ir_detail_id is not null)
or (frr_id is not null and frr_year is not null and frr_detail_id is not null)
or (stn_id is not null and stn_year is not null and stn_detail_id is not null)
or (fgrr_id is not null and fgrr_year is not null)
or (san_id is not null and san_year is not null)
or (btn_id is not null and btn_year is not null and btn_detail_id is not null)
or (Pr_id is not null and Pr_year is not null and Pr_detail_id is not null));

ALTER TABLE ORACLE.TRANS
 ADD CONSTRAINT trans_pr_uq
 UNIQUE (PR_ID, PR_YEAR, PR_DETAIL_ID);

