ALTER TABLE CLASSIC1.STUDENT_HISTORY
 DROP PRIMARY KEY CASCADE;
ALTER TABLE CLASSIC1.STUDENT_HISTORY
 ADD CONSTRAINT STUDENT_HISTORY_PK
 PRIMARY KEY
 (STUDENT_ID, FDATETIME);

