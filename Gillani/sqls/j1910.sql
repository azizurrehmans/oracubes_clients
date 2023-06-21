DELETE FROM PROD_JCD WHERE JCD_ID IN (3761,4511,4512,4513,4514,4515,4516);
---------------
DELETE FROM HR_SAL_CONT_MO_DETAIL WHERE JCD_ID IN (SELECT JCD_ID FROM HR_SAL_CONT_MO_DETAIL WHERE JCD_ID NOT IN (SELECT JCD_ID FROM PROD_JCD));
---------------
SELECT COUNT(*) FROM PROD_LOT_ERRORS;

ALTER TABLE JILLANI.HR_SAL_CONT_MO_DETAIL
 ADD CONSTRAINT HR_SAL_CONT_MO_LOT_FK 
 FOREIGN KEY (JCD_ID) 
 REFERENCES JILLANI.PROD_JCD (JCD_ID);
--------------
CREATE OR REPLACE FORCE VIEW jillani.exp_cpo_detail_view (cpo_type,
                                                          our_cpo,
                                                          cpo_year,
                                                          cpo_id,
                                                          cpo_date,
                                                          mp_id,
                                                          customer_id,
                                                          sample_ins,
                                                          cpo_remarks,
                                                          POSITION,
                                                          shipment_date,
                                                          rate,
                                                          quantity,
                                                          prod_qty,
                                                          remarks,
                                                          style,
                                                          color_id,
                                                          rsize,
                                                          size_id,
                                                          orderby,
                                                          production_date,
                                                          status_id,
                                                          item_description,
                                                          unit_id,
                                                          customer_code,
                                                          prod_special_ins,
                                                          delivery_date,
                                                          fdatetime
                                                         )
AS
   SELECT cpo.cpo_type, cpo.our_cpo, cpo.cpo_year, cpo.cpo_id, cpo.cpo_date,
          cpod.mp_id, cpo.customer_id, cpo.sample_ins,
          cpo.remarks cpo_remarks, cpod.POSITION, cpod.shipment_date,
          cpod.rate, cpod.quantity, cpod.prod_qty, cpod.remarks, cpod.style,
          cpod.color_id, cpod.rsize, s.size_id, s.orderby, production_date,
          cpo.status_id, item_description, unit_id, customer_code,
          prod_special_ins, delivery_date, fdatetime
     FROM exp_cpo cpo, exp_cpo_detail cpod, exp_size s
    WHERE cpo.our_cpo = cpod.our_cpo
      AND cpo.cpo_year = cpod.cpo_year
      AND cpod.rsize = s.size_id;
----------------
CREATE OR REPLACE FORCE VIEW prod_lot_errors 
AS
   SELECT   j.cpo_year, j.our_cpo, j.POSITION, v.style, v.color_id, v.size_id,
            j.operation_id, j.operation_no, v.quantity order_qty,
            SUM (qty) issue, SUM (rec_qty) rec, v.mp_id
       FROM prod_jcd j, exp_cpo_detail_view v
      WHERE j.our_cpo = v.our_cpo
        AND j.cpo_year = v.cpo_year
        AND j.POSITION = v.POSITION
   GROUP BY j.our_cpo,
            j.cpo_year,
            j.POSITION,
            v.style,
            v.color_id,
            size_id,
            v.quantity,
            j.operation_id,
            j.operation_no,
            v.mp_id
     HAVING v.quantity < SUM (qty)
         OR v.quantity < SUM (rec_qty)
         OR SUM (qty) < SUM (rec_qty)
   ORDER BY our_cpo, POSITION;
   -------
   CREATE OR REPLACE FORCE VIEW jillani.hr_employee_view (monthly_max_late,
                                                       service_provider,
                                                       absent_rate,
                                                       english_urdu,
                                                       qualification_id,
                                                       service_age2,
                                                       age2,
                                                       ntn,
                                                       muslim,
                                                       christian,
                                                       hindu,
                                                       male,
                                                       female,
                                                       married,
                                                       SINGLE,
                                                       widow,
                                                       seperated,
                                                       teacher,
                                                       non_teacher,
                                                       service_age,
                                                       age,
                                                       cur_coa_main_id,
                                                       cur_coa_sub_id,
                                                       cur_coa_id,
                                                       employee_type,
                                                       advance_20th,
                                                       page_no,
                                                       coa_main_id,
                                                       provident_bank_ac,
                                                       coa_sub_id,
                                                       coa_id,
                                                       bank_id,
                                                       bank_account,
                                                       bank_city_id,
                                                       experience,
                                                       ot_allowed,
                                                       income_tax_amount,
                                                       ss_no,
                                                       eobi_no,
                                                       blood_group,
                                                       marital_status,
                                                       gate_employee_no,
                                                       employee_id,
                                                       NAME,
                                                       fname,
                                                       address1,
                                                       address2,
                                                       namefname,
                                                       nic,
                                                       nid_no,
                                                       religion,
                                                       salary_group,
                                                       status_id,
                                                       doj,
                                                       joining_month,
                                                       dol,
                                                       leaving_month,
                                                       REFERENCE,
                                                       address,
                                                       designation,
                                                       designation_id,
                                                       department,
                                                       department_id,
                                                       grade,
                                                       order_by,
                                                       grosssalary,
                                                       net_salary,
                                                       deduction,
                                                       dob,
                                                       city_id,
                                                       country_id,
                                                       email,
                                                       gross_salary,
                                                       doc,
                                                       gender,
                                                       old_nic,
                                                       family_code,
                                                       salary_advance_balance,
                                                       cell
                                                      )
AS
   SELECT 0 monthly_max_late, 'NO' service_provider, 0 absent_rate,
          english_name || NAME english_urdu, q.qualification_id,
          hr_service_age2 (doj) service_age2, hr_service_age2 (dob) age2,
          e.ntn, DECODE (religion, 'MUSLIM', 1, 0) muslim,
          DECODE (religion, 'CHRISTIAN', 1, 0) christian,
          DECODE (religion, 'HINDU', 1, 0) hindu,
          DECODE (gender, 'MALE', 1, 0) male,
          DECODE (gender, 'FEMALE', 1, 0) female,
          DECODE (marital_status, 'MARRIED', 1, 0) married,
          DECODE (marital_status, 'SINGLE', 1, 0) SINGLE,
          DECODE (marital_status, 'WIDOW', 1, 'WIDOWED', 1, 0) widow,
          DECODE (marital_status, 'SEPERATED', 1, 0) seperated,
          DECODE (dd.designation_id,
                  'TEACHER', 1,
                  'MUSIC TEACHER', 1,
                  'ART TEACHER', 0,
                  'COMPUTER TEACHER', 1,
                  0
                 ) teacher,
          DECODE (dd.designation_id,
                  'TEACHER', 0,
                  'MUSIC TEACHER', 0,
                  'ART TEACHER', 0,
                  'COMPUTER TEACHER', 0,
                  1
                 ) non_teacher,
          hr_service_age (doj) service_age, hr_service_age (dob) age,
          e.cur_coa_main_id, e.cur_coa_sub_id, e.cur_coa_id, e.employee_type,
          e.advance_20th, e.page_no, e.coa_main_id, e.provident_bank_ac,
          e.coa_sub_id, e.coa_id, e.bank_id, e.bank_account, e.bank_city_id,
          e.experience, ef.ot_allowed, e.income_tax_amount, e.ss_no,
          e.eobi_no, e.blood_group, e.marital_status, e.gate_employee_no,
          e.employee_id, e.NAME, e.fname, e.address1, e.address2,
          e.NAME || ' / ' || e.fname namefname, e.nid_no nic, e.nid_no,
          e.religion, ef.salary_group
-- ,e.SEX
          , e.status_id, e.doj, TO_CHAR (doj, 'MON yyyy') joining_month,
          e.dol, TO_CHAR (dol, 'MON yyyy') leaving_month
-- ,e.REMARKS
          , e.REFERENCE, e.address1 || ' ' || address2 address,
          dd.designation_id designation, dd.designation_id,
          dd.department_id department, dd.department_id, dd.grade, d.order_by,
          ef2.gross grosssalary, ef2.net_salary net_salary,
          ef2.deduction deduction, e.dob, e.city_id, e.country_id, e.email,
          ef2.earning gross_salary, doc, e.gender, e.old_nic, e.family_code,
          0 salary_advance_balance, 0 cell
     FROM hr_employee e,
          hr_emp_latest_dept_desig_view dd,
          hr_emp_latest_fin_view ef,
          hr_emp_latest_qualif_view q,
          hr_department d,
          hr_emp_fin_latest_view2 ef2
    WHERE e.employee_id = dd.employee_id(+)
      AND e.employee_id = ef.employee_id(+)
      AND dd.department_id = d.department_id(+)
      AND e.employee_id = q.employee_id(+)
      AND e.employee_id = ef2.employee_id(+);
   -----------------------
   CREATE OR REPLACE FORCE VIEW jillani.inv_sc_desc (item_code,
                                                  sub_customer,
                                                  description,
                                                  english,
                                                  abbri,
                                                  urdu_english,
                                                  l5_id,
                                                  FINISH,
                                                  customer_name,
                                                  sc_desc,
                                                  sc_code,
                                                  sc_id,
                                                  sc1_id,
                                                  uom_id,
                                                  balance
                                                 )
AS
   SELECT cc.item_code, cc.sub_customer, sc.description, english, '-' abbri,
          sc.description || '-' || english urdu_english, sc.l5_id,
          sc.l5_id FINISH, coa.description customer_name,
          item_code || ' ' || sc.item_description sc_desc, sc.sc_id sc_code,
          sc.sc_id, sc.l1 sc1_id, uom_id,
          inv_closing_qty_date (sc.sc_id, SYSDATE, 'OK') balance
     FROM inv_sc_view sc, inv_customer_code cc, ac_coa coa
    WHERE sc.sc_id = cc.sc_id(+) AND cc.customer_coa_seq = coa.coa_seq(+);   