CREATE TABLE CLASSIC1.CLASS
(
  CLASS_ID   VARCHAR2(15 BYTE),
  USER_ID    VARCHAR2(20 BYTE)                  NOT NULL,
  STATUS_ID  VARCHAR2(10 BYTE)                  NOT NULL,
  FDATETIME  DATE                               NOT NULL,
  CONSTRAINT CLASS_PK PRIMARY KEY (CLASS_ID)
);