ALTER TABLE ASKARI.IGP_DETAIL
 ADD (wo_id  NUMBER(5));

ALTER TABLE ASKARI.IGP_DETAIL
 ADD (wo_year  VARCHAR2(5));

ALTER TABLE ASKARI.IGP_DETAIL
 ADD (wo_detail_id  NUMBER(2));

ALTER TABLE ASKARI.IGP_DETAIL
 ADD CONSTRAINT igp_det_wo_fk 
 FOREIGN KEY (wo_id, wo_year, wo_detail_id) 
 REFERENCES ASKARI.WO_DETAIL (wo_id, wo_year, wo_detail_id);

