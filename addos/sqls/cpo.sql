ALTER TABLE ASKARI.CPO
 ADD (coa_main_id  NUMBER(2));

ALTER TABLE ASKARI.CPO
 ADD (coa_sub_id  NUMBER(4));

ALTER TABLE ASKARI.CPO
 ADD (coa_id  NUMBER(6));

ALTER TABLE ASKARI.CPO
 ADD CONSTRAINT cpo_coa_fk 
 FOREIGN KEY (coa_main_id, coa_sub_id, coa_id) 
 REFERENCES ASKARI.COA (coa_main_id, coa_sub_id, coa_id);

