ALTER TABLE ORACLE4.EXPORT_SETUP
 ADD (CPO_COA_MAIN_ID  NUMBER);

ALTER TABLE ORACLE4.EXPORT_SETUP
 ADD (CPO_COA_SUB_ID  NUMBER);

ALTER TABLE ORACLE4.EXPORT_SETUP
 ADD CONSTRAINT CPO_COA_FK 
 FOREIGN KEY (CPO_COA_MAIN_ID, CPO_COA_SUB_ID) 
 REFERENCES ORACLE4.COA_SUB (COA_MAIN_ID, COA_SUB_ID);

