DROP VIEW ADDOS.HR_SALARY_DETAIL_VIEW;

/* Formatted on 2022/03/16 09:29 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW addos.hr_salary_detail_view (days,
                                                          employee_id,
                                                          salary_id,
                                                          NAME,
                                                          department_id,
                                                          department,
                                                          designation,
                                                          status_id,
                                                          doj,
                                                          sd_status_id,
                                                          salary_detail_status_id,
                                                          employee_status_id,
                                                          actual_pay,
                                                          loan_ded,
                                                          salary_advance,
                                                          advance_20th,
                                                          voucher_seq,
                                                          ot_amount,
                                                          late_amount,
                                                          basic_salary,
                                                          other_earning,
                                                          other_deduction,
                                                          short_amount,
                                                          absent_amount,
                                                          gross_salary,
                                                          earned_sal,
                                                          other_ear,
                                                          other_ded,
                                                          allowances,
                                                          total_ot_amount,
                                                          fixed_ot
                                                         )
AS
   SELECT   sde.days days, e.employee_id, sd.salary_id, e.NAME,
            e.department_id, e.department, e.designation, e.status_id, e.doj,
            sd.status_id sd_status_id, sd.status_id salary_detail_status_id,
            e.status_id employee_status_id, NULL actual_pay,
            ROUND (hr_emp_sal_alow_paid (e.employee_id, sd.salary_id, 'LOAN')
                  ) loan_ded,
            hr_emp_sal_alow_paid (e.employee_id,
                                  sd.salary_id,
                                  'ADVANCE'
                                 ) salary_advance,
            hr_emp_sal_alow_paid (e.employee_id,
                                  sd.salary_id,
                                  'ADVANCE'
                                 ) advance_20th,
            voucher_seq,
            ROUND (hr_emp_sal_alow_paid (e.employee_id, sd.salary_id,
                                         'OT AMT')
                  ) ot_amount,
            ROUND (hr_emp_sal_alow_paid (e.employee_id,
                                         sd.salary_id,
                                         'LATE AMT'
                                        )
                  ) late_amount,
            ROUND (hr_emp_sal_alow_paid (e.employee_id,
                                         sd.salary_id,
                                         'BASIC SALARY'
                                        )
                  ) basic_salary,
            ROUND (hr_emp_sal_alow_paid (e.employee_id,
                                         sd.salary_id,
                                         'OTHER EARNING'
                                        )
                  ) other_earning,
            ROUND (hr_emp_sal_alow_paid (e.employee_id,
                                         sd.salary_id,
                                         'OTHER DEDUCTION'
                                        )
                  ) other_deduction,
            ROUND (hr_emp_sal_alow_paid (e.employee_id,
                                         sd.salary_id,
                                         'SHORT AMT'
                                        )
                  ) short_amount,
            ROUND (hr_emp_sal_alow_paid (e.employee_id,
                                         sd.salary_id,
                                         'SHORT AMT'
                                        )
                  ) absent_amount,
            ROUND (hr_emp_sal_alow_paid (e.employee_id, sd.salary_id, 'GROSS')
                  ) gross_salary,
            NULL earned_sal, NULL other_ear, NULL other_ded, NULL allowances,
            NULL total_ot_amount, NULL fixed_ot
       FROM hr_employee_view e,
            hr_salary_detail sd,
            hr_salary s,
            (SELECT DISTINCT employee_id, salary_id, days
                        FROM hr_salary_detail_emp
                    GROUP BY employee_id, salary_id, days) sde
      WHERE e.employee_id = sd.employee_id
        AND s.salary_id = sd.salary_id
        AND sd.employee_id = sde.employee_id
        AND sd.salary_id = sde.salary_id
   GROUP BY e.employee_id,
            sd.days,
            sd.salary_id,
            e.NAME,
            e.department_id,
            e.designation,
            e.status_id,
            e.doj,
            sd.status_id,
            sde.days,
            voucher_seq;


