CREATE OR REPLACE FORCE VIEW hr_emp_fin_latest_view2 (employee_id,
                                                            earning,
                                                            gross,
                                                            deduction,
                                                            net_salary
                                                           )
AS
   SELECT ear.employee_id, NVL (earning, 0) earning, NVL (earning, 0) gross,
          NVL (ded, 0) deduction, NVL (earning, 0) - NVL (ded, 0) net_salary
     FROM (SELECT   f.employee_id, SUM (f.amount) earning
               FROM hr_emp_fin_det f,
                    (SELECT   employee_id, MAX (fdatetime) fdatetime
                         FROM hr_emp_fin
                     GROUP BY employee_id) dt,
                    hr_allowance a
              WHERE f.fdatetime = dt.fdatetime
                AND f.employee_id = dt.employee_id
                AND f.allowance_id = a.allowance_id
                AND a.effect = 'ADD'
           GROUP BY f.employee_id) ear,
          (SELECT   f.employee_id, SUM (f.amount) ded
               FROM hr_emp_fin_det f,
                    (SELECT   employee_id, MAX (fdatetime) fdatetime
                         FROM hr_emp_fin
                     GROUP BY employee_id) dt,
                    hr_allowance a
              WHERE f.fdatetime = dt.fdatetime
                AND f.employee_id = dt.employee_id
                AND f.allowance_id = a.allowance_id
                AND a.effect = 'SUB'
           GROUP BY f.employee_id) ded
    WHERE ear.employee_id = ded.employee_id(+);
    -----------------
create or replace view hr_employee_view
as    
SELECT 0 monthly_max_late, 'NO' service_provider, 0 absent_rate,
          q.qualification_id, hr_service_age2 (doj) service_age2,
          hr_service_age2 (dob) age2, e.ntn,
          DECODE (religion, 'MUSLIM', 1, 0) muslim,
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