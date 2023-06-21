ALTER TABLE ADDOS.EXP_PACKING
 ADD (ship_by  VARCHAR2(50));

ALTER TABLE ADDOS.EXP_PACKING
 ADD (proforma_inv  VARCHAR2(50));
 
ALTER TABLE ADDOS.EXPORT_SETUP  ADD (statement_of_orgion  VARCHAR2(500)); 

ALTER TABLE ADDOS.exp_packing  ADD (sro_yn  VARCHAR2(3)); 
ALTER TABLE ADDOS.exp_packing  ADD (statement_of_origion_yn  VARCHAR2(3));
ALTER TABLE ADDOS.exp_packing  ADD (statement_of_origion VARCHAR2(500));