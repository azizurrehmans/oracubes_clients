ALTER TABLE ORACLE3.IGP_DETAIL
 ADD CONSTRAINT igp_det_igppo_fk 
 FOREIGN KEY (IGP_ID, IGP_YEAR, IGP_TYPE, PO_ID, PO_YEAR, PO_TYPE) 
 REFERENCES ORACLE3.IGP (IGP_ID, IGP_YEAR, IGP_TYPE, PO_ID, PO_YEAR, PO_TYPE);
