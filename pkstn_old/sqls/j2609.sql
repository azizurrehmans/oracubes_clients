ALTER TABLE GILLANI.PROD_JCD  ADD CONSTRAINT jcd_emp_jcd_uq  UNIQUE (JCD_ID, EMPLOYEE_ID);

delete from hr_sal_cont_mo_detail where employee_id = 1023;
delete from prod_jcd where employee_id = 1023;


ALTER TABLE GILLANI.HR_SAL_CONT_MO_DETAIL  ADD CONSTRAINT sal_cont_mo_jcd_emp_fk  FOREIGN KEY (JCD_ID, EMPLOYEE_ID)  REFERENCES GILLANI.PROD_JCD (JCD_ID, EMPLOYEE_ID);

select j.jcd_id, j.employee_id, j.REC_DATE, j.USER_ID, j.QTY, j.REC_QTY, j.rec_qty - d.PAIR qty_diff,  d.employee_id, d.rate, d.rate * d.PAIR amount  from prod_jcd j, hr_sal_cont_mo_detail d 
where j.jcd_id = d.jcd_id and  j.jcd_id||'-'||j.employee_id not in ( select jcd_id||'-'||employee_id from hr_sal_cont_mo_detail);

delete from hr_sal_cont_mo_detail where jcd_id in (select j.jcd_id  from prod_jcd j where  j.jcd_id||'-'||j.employee_id not in ( select jcd_id||'-'||employee_id from hr_sal_cont_mo_detail)); 


