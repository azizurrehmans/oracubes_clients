ALTER TABLE GILLANI.HR_EMPLOYEE  ADD (salary_adv_coa_seq  NUMBER);
ALTER TABLE GILLANI.HR_EMPLOYEE  ADD (loan_coa_seq  NUMBER);
ALTER TABLE GILLANI.HR_EMPLOYEE  ADD (salary_coa_seq  NUMBER);
ALTER TABLE GILLANI.HR_EMPLOYEE  ADD (salary_payable_coa_seq  NUMBER);
----ALTER TABLE GILLANI.HR_EMPLOYEE  ADD (English_name  VARCHAR2(100));

hr_employee_view

ALTER TABLE GILLANI.HR_SETUP  ADD (emp_loan_parent_id  NUMBER);
ALTER TABLE GILLANI.HR_SETUP  ADD (emp_loan_sub_id  NUMBER);
ALTER TABLE GILLANI.HR_SETUP ADD (emp_loan_ctrl_id  NUMBER);
ALTER TABLE GILLANI.HR_SETUP  ADD (emp_sal_adv_parent_id  NUMBER);
ALTER TABLE GILLANI.HR_SETUP  ADD (emp_sal_adv_sub_id  NUMBER);
ALTER TABLE GILLANI.HR_SETUP  ADD (emp_sal_adv_ctr_id  NUMBER);
ALTER TABLE GILLANI.HR_SETUP  ADD (cont_loan_parent_id  NUMBER);
ALTER TABLE GILLANI.HR_SETUP  ADD (cont_loan_sub_id  NUMBER);
ALTER TABLE GILLANI.HR_SETUP  ADD (CONT_LOAN_CTRL_ID  NUMBER);
ALTER TABLE GILLANI.HR_SETUP  ADD (CONT_SAL_ADV_PARENT_ID  NUMBER);
ALTER TABLE GILLANI.HR_SETUP  ADD (CONT_SAL_ADV_SUB_ID  NUMBER);
ALTER TABLE GILLANI.HR_SETUP  ADD (CONT_SAL_ADV_CTRL_ID  NUMBER);


