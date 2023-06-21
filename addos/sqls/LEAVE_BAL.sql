ALTER TABLE ASKARI.LEAVE_BALANCE
MODIFY(OPERATOR_ID  NULL);


ALTER TABLE ASKARI.LEAVE_BALANCE
 ADD (USER_ID  VARCHAR2(20));

ALTER TABLE ASKARI.LEAVE_BALANCE DROP COLUMN INSERT_BY;

ALTER TABLE ASKARI.LEAVE_BALANCE DROP COLUMN INSERT_DATE;

ALTER TABLE ASKARI.LEAVE_BALANCE DROP COLUMN INSERT_TERM;

ALTER TABLE ASKARI.LEAVE_BALANCE DROP COLUMN LAST_UPDATED_BY;

ALTER TABLE ASKARI.LEAVE_BALANCE DROP COLUMN LAST_UPDATED_DATE;

ALTER TABLE ASKARI.LEAVE_BALANCE DROP COLUMN LAST_UPDATED_TERM;

ALTER TABLE ASKARI.LEAVE_BALANCE
 ADD CONSTRAINT LEAVE_BAL_USER_FK 
 FOREIGN KEY (USER_ID) 
 REFERENCES ASKARI.USERS (USER_ID);

