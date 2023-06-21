DROP VIEW ADDOS.HR_EMPLOYEE_LATEST_SHIFT;

/* Formatted on 2021/11/03 16:43 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW addos.hr_employee_latest_shift (employee_id,
                                                             hr_shift_id,
                                                             in_time,
                                                             out_time,
                                                             rest_day
                                                            )
AS
   SELECT e.employee_id, NVL (l.hr_shift_id, 'GENERAL') hr_shift_id,
          sf.in_time, sf.out_time, sf.rest_day
     FROM hr_employee_shift l,
          hr_employee e,
          (SELECT   employee_id, MAX (fdatetime) fdatetime
               FROM hr_employee_shift
           GROUP BY employee_id) dt,
          hr_shift sf
    WHERE l.fdatetime = dt.fdatetime(+)
      AND l.employee_id = dt.employee_id(+)
      AND l.hr_shift_id = sf.hr_shift_id(+)
      AND e.employee_id = l.employee_id(+);


