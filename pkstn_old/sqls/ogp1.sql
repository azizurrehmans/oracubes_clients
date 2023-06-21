ALTER TABLE ASKARI.OGP
 ADD (wo_id  NUMBER(4));

ALTER TABLE ASKARI.OGP
 ADD (wo_year  VARCHAR2(5));

ALTER TABLE ASKARI.OGP
 ADD CONSTRAINT ogp_wo_uq
 UNIQUE (wo_id, wo_year);

ALTER TABLE ASKARI.OGP
 ADD CONSTRAINT ogp_wo_fk 
 FOREIGN KEY (wo_id, wo_year) 
 REFERENCES ASKARI.WO (wo_id, wo_year);

