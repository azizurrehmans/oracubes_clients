ALTER TABLE ASKARI.TASK_USER
 ADD CONSTRAINT task_users_fk 
 FOREIGN KEY (USER_ID) 
 REFERENCES ASKARI.USERS (USER_ID);

ALTER TABLE ASKARI.TASK_USER
 ADD CONSTRAINT task_task_fk 
 FOREIGN KEY (TASK_ID) 
 REFERENCES ASKARI.TASK (TASK_ID);
