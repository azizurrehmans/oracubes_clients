ALTER TABLE EMPLOYEE ADD (INACITVE_DATE  DATE);
ALTER TABLE EMPLOYEE ADD (INACTIVE_REASON  VARCHAR2(100));
ALTER TABLE EMPLOYEE ADD (INACTIVE_USER_ID  VARCHAR2(20));
ALTER TABLE EMPLOYEE ADD CONSTRAINT INACTIVE_USER_FK FOREIGN KEY (INACTIVE_USER_ID) REFERENCES ASKARI.USERS (USER_ID);
/
