ALTER TABLE ASKARI.SAL_CONT_DETAIL
 ADD CONSTRAINT sal_cont_det_pk
 PRIMARY KEY
 (SAL_CONT_ID, EMPLOYEE_ID, SAL_CONT_NO);

ALTER TABLE ASKARI.SAL_CONT_DETAIL
 ADD CONSTRAINT sal_cont_det_sal_cnot_fk 
 FOREIGN KEY (SAL_CONT_ID, SAL_CONT_NO) 
 REFERENCES ASKARI.SAL_CONT (SAL_CONT_ID, SAL_CONT_NO);

