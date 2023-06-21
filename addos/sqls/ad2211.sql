DROP VIEW ADDOS.HR_ATTENDANCE_VIEW;

/* Formatted on 2021/11/22 17:14 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW addos.hr_attendance_view (short_leave
,                                                      short_hours
,                                                      short_min
,                                                      department
,                                                      designation
,                                                      gate_employee_no
,                                                      employee_id
,                                                      NAME
,                                                      ot_allowed
,                                                      status_id
,                                                      lock_status
,                                                      month_days
,                                                      attendance_date
,                                                      attendance_month
,                                                      salary_id
,                                                      intime
,                                                      outtime
,                                                      std_in
,                                                      std_out
,                                                      std_in_raw
,                                                      late
,                                                      late_minutes
,                                                      ot_hours
,                                                      hours
,                                                      ot_min
,                                                      status
,                                                      error
,                                                      present
,                                                      absent
,                                                      rest
,                                                      leave
,                                                      gh
,                                                      wop
,                                                      nol
,                                                      leave_type
,                                                      leave_status
,                                                      active_status
,                                                      late_1
,                                                      shift_id
                                                      )
AS
   SELECT ALL a.short_leave
,             CASE
                 WHEN (hours (TO_DATE (TO_CHAR (outtime, 'HH24MI'), 'HH24:MI')
,                             TO_DATE (TO_CHAR (std_out), 'HH24:MI')
                             ) <= 0
                      )
                    THEN 0
                 ELSE hours (TO_DATE (TO_CHAR (outtime, 'HH24MI'), 'HH24:MI')
,                            TO_DATE (TO_CHAR (std_out), 'HH24:MI')
                            )
              END short_hours
,             number_to_min (a.short_leave) short_min, e.department
,             designation, e.gate_employee_no, a.employee_id, e.NAME
,             f.ot_allowed, a.status_id
,             DECODE (a.status_id, 0, 'OPEN', 1, 'LOCKED') lock_status
,             s.days month_days, a.attendance_date
,             TO_DATE ('01-' || TO_CHAR (a.attendance_date, 'mon-yyyy')
                      ) attendance_month
,             TO_DATE ('01-' || TO_CHAR (a.attendance_date, 'mon-yyyy')
                      ) salary_id
,             a.intime, a.outtime, e.std_in, e.std_out
,             CASE
                 WHEN a.intime IS NOT NULL
                    THEN TO_DATE ((   TO_CHAR (a.intime, 'dd-mon-yyyy')
                                   || ' '
                                   || TO_CHAR (e.std_in, '0000')
                                  )
,                                 'dd-mon-yyyy hh24:mi'
                                 )
              END std_in_raw
,             hours_diff
                 (CASE
                     WHEN a.intime IS NOT NULL
                        THEN TO_DATE ((   TO_CHAR (a.intime, 'dd-mon-yyyy')
                                       || ' '
                                       || TO_CHAR (e.std_in, '0000')
                                      )
,                                     'dd-mon-yyyy hh24:mi'
                                     )
                  END
,                 intime
                 ) late
,             number_to_min
                 (hours_diff
                     (CASE
                         WHEN a.intime IS NOT NULL
                            THEN TO_DATE ((   TO_CHAR (a.intime
,                                                      'dd-mon-yyyy')
                                           || ' '
                                           || TO_CHAR (e.std_in, '0000')
                                          )
,                                         'dd-mon-yyyy hh24:mi'
                                         )
                      END
,                     intime
                     )
                 ) late_minutes
,             a.ot_hours, a.hours, number_to_min (a.ot_hours) ot_min
,             a.status, DECODE (a.status, 'E', 1, 0) error
,               DECODE (a.status, 'P', 1, 'CL', 1, 0)
              - DECODE (a.leave_type, 'CL', a.leave_status, 0) present
,             DECODE (a.status, 'A', 1, 0) absent
,             DECODE (a.status, 'R', 1, 0) rest
,             DECODE (a.status, 'CL', 1, 'SL', a.leave_status, 0) leave
,             DECODE (a.status, 'GH', 1, 0) gh
,             DECODE (a.status, 'WOP', a.leave_status, 0) wop
,             DECODE (a.leave_type, 'CL', a.status, 0) nol, a.leave_type
,             a.leave_status, e.status_id active_status, late, shift_id
         FROM hr_attendance a
,             hr_employee_view e
,             hr_emp_latest_fin_view f
,             hr_salary s
        WHERE (a.employee_id = e.employee_id(+) AND e.employee_id = f.employee_id(+))
          AND (TO_DATE ('01-' || TO_CHAR (a.attendance_date, 'mon-yyyy')) =
                                                                           s.salary_id(+)
              );


