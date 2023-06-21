ALTER TABLE IR
 ADD (wo_id  NUMBER(5))
ALTER TABLE IR
 ADD (wo_year  VARCHAR2(5));
ALTER TABLE IR
 ADD CONSTRAINT ir_wo_fk 
 FOREIGN KEY (wo_id, wo_year) 
 REFERENCES WO (wo_id, wo_year);
/
