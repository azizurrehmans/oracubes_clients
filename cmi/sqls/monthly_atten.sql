ALTER TABLE ASKARI3.MONTHLY_ATTENDANCE
 ADD (employee_name  VARCHAR2(100));

ALTER TABLE ASKARI3.MONTHLY_ATTENDANCE DROP COLUMN INSERT_BY;

ALTER TABLE ASKARI3.MONTHLY_ATTENDANCE DROP COLUMN INSERT_DATE;

ALTER TABLE ASKARI3.MONTHLY_ATTENDANCE DROP COLUMN INSERT_TERM;

ALTER TABLE ASKARI3.MONTHLY_ATTENDANCE DROP COLUMN LAST_UPDATED_BY;

ALTER TABLE ASKARI3.MONTHLY_ATTENDANCE DROP COLUMN LAST_UPDATED_DATE;

ALTER TABLE ASKARI3.MONTHLY_ATTENDANCE DROP COLUMN LAST_UPDATED_TERM;

