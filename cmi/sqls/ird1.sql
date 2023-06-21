ALTER TABLE ASKARI.IR_DETAIL
 ADD (wo_id  NUMBER(5));

ALTER TABLE ASKARI.IR_DETAIL
 ADD (Wo_year  VARCHAR2(5));

ALTER TABLE ASKARI.IR_DETAIL
 ADD (wo_detail_id  NUMBER(5));

ALTER TABLE ASKARI.IR_DETAIL
 ADD CONSTRAINT ir_detail_wo_detail_fk 
 FOREIGN KEY (wo_id, Wo_year, wo_detail_id) 
 REFERENCES ASKARI.WO_DETAIL (wo_id, Wo_year, wo_detail_id);

