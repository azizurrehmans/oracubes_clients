ALTER TABLE ORACLE4.OGP_DETAIL
 ADD (pr_id  NUMBER);

ALTER TABLE ORACLE4.OGP_DETAIL
 ADD (pr_year_id  VARCHAR2(5));

ALTER TABLE ORACLE4.OGP_DETAIL
 ADD (pr_detail_id  NUMBER);

ALTER TABLE ORACLE4.OGP_DETAIL
 ADD CONSTRAINT wo_det_pd_det_fk 
 FOREIGN KEY (pr_id, pr_year_id, pr_detail_id) 
 REFERENCES ORACLE4.PR_DETAIL (pr_id, pr_detail_id, PR_YEAR);

