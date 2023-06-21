insert into leave_balance select e.employee_id, sysdate, 'RELEASE','14',10,8,'aziz'
from employee E where status_ID='ACTIVE'