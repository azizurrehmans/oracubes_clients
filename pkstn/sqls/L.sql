ALTER TABLE LOAN
 ADD (User_id  VARCHAR2(20));
ALTER TABLE LOAN
 ADD CONSTRAINT loan_user_fk 
 FOREIGN KEY (User_id) 
 REFERENCES USERS (User_id);
/
