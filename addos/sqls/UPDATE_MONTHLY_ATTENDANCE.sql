insert into hr_monthly_attendance 
     (employee_id   , month,              days,                   ot_hours,                                 DEPARTMENT, DESIGNATION, MONTH_DAYS, NAME, LATE_HOURS)

select v.employee_id,  '01-OCT-2021 ', sum( v.ABSENT), min_to_hour( sum( v.OT_MIN)),  department,      designation      , 31                  , v.name, min_to_hour(sum( v.LATE_MINUTES)) 
from hr_attendance_view v
WHERE ATTENDANCE_MONTH = '01-OCT-2021'
group by v.employee_id, v.name, attendance_month, department, designation;

DELETE FROM HR_MONTHLY_ATTENDANCE;
SELECT * FROM HR_MONTHLY_ATTENDANCE;
COMMIT;
select last_day('12-oct-2021') from dual;