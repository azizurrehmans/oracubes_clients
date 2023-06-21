ALTER TABLE ASKARI.WO
 ADD (cpo_coa_main_id  NUMBER(2));

ALTER TABLE ASKARI.WO
 ADD (cpo_coa_sub_id  NUMBER(4));

ALTER TABLE ASKARI.WO
 ADD ("cpo-coa_id"  NUMBER(6));

ALTER TABLE ASKARI.WO
 ADD CONSTRAINT wo_cpo_coa_fk 
 FOREIGN KEY (cpo_coa_main_id, cpo_coa_sub_id, "cpo-coa_id") 
 REFERENCES ASKARI.COA (COA_MAIN_ID, COA_SUB_ID, COA_ID);

