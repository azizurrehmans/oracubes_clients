ALTER TABLE ASKARI.WO_DETAIL
 ADD CONSTRAINT wo_det_sc_fk 
 FOREIGN KEY (SC_MAIN_ID, SC_SUB_ID, SC_ID) 
 REFERENCES ASKARI.SC (SC_MAIN_ID, SC_SUB_ID, SC_ID);

