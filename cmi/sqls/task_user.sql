CREATE TABLE ASKARI.task_user
(
  task_id  VARCHAR2(50),
  user_id  VARCHAR2(20)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
NOMONITORING;


ALTER TABLE ASKARI.task_user ADD (
  CONSTRAINT task_user_PK
 PRIMARY KEY
 (task_id, user_id));

ALTER TABLE ASKARI.task_user ADD (
  CONSTRAINT task_task_fk 
 FOREIGN KEY (task_id) 
 REFERENCES ASKARI.TASK (task_id),
  CONSTRAINT task_user_fk 
 FOREIGN KEY (user_id) 
 REFERENCES ASKARI.USERS (user_id));

