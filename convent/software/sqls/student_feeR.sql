ALTER TABLE CLASSIC.STUDENT_FEE
MODIFY(STATUS_ID  NOT NULL);


ALTER TABLE CLASSIC.STUDENT_FEE
 ADD (DISCOUNT_AMOUNT  NUMBER                       NOT NULL);

ALTER TABLE CLASSIC.STUDENT_FEE
 ADD (FEE_CYCLE  VARCHAR2(20)                       NOT NULL);

