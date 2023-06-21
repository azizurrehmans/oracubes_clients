ALTER TABLE IGP
 ADD CONSTRAINT igp_wo_fk 
 FOREIGN KEY (wo_id, wo_year) 
 REFERENCES WO (wo_id, wo_year);

