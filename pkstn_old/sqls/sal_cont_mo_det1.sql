ALTER TABLE ASKARI.SAL_CONT_MO_DETAIL
 ADD CONSTRAINT sal_cont_mo_Sal_Cont_fk 
 FOREIGN KEY (SAL_CONT_ID, EMPLOYEE_ID, SAL_CONT_NO) 
 REFERENCES ASKARI.SAL_CONT_DETAIL (SAL_CONT_ID, EMPLOYEE_ID, SAL_CONT_NO);

