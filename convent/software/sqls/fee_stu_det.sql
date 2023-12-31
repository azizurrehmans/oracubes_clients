CREATE TABLE CLASSIC1.FEE_STRUCTURE_DET
(
  FDATETIME     DATE,
  CLASS_ID      VARCHAR2(50 BYTE),
  REGISTRATION  NUMBER(8)                       DEFAULT 0,
  ADMISSION     NUMBER(8)                       DEFAULT 0,
  SECURITY      NUMBER(8)                       DEFAULT 0,
  TUTION        NUMBER(8)                       DEFAULT 0,
  COMPUTER      NUMBER(8)                       DEFAULT 0,
  LABORTARY     NUMBER(8)                       DEFAULT 0,
  LIBRARY       NUMBER(8)                       DEFAULT 0,
  PE            NUMBER(8)                       DEFAULT 0,
  OTHERS        NUMBER(8)                       DEFAULT 0,
  LATE          NUMBER(8)                       DEFAULT 0,
  STATUS_ID     VARCHAR2(10 BYTE),
  USER_ID       VARCHAR2(20 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX CLASSIC1.FEE_STRUTURE_DET_PK ON CLASSIC1.FEE_STRUCTURE_DET
(FDATETIME, CLASS_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE CLASSIC1.FEE_STRUCTURE_DET ADD (
  CONSTRAINT FEE_STRUCTURE_STATUS_FK
 CHECK (status_id in ('HOLD','RELEASE')),
  CONSTRAINT FEE_STRUTURE_DET_PK
 PRIMARY KEY
 (FDATETIME, CLASS_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE CLASSIC1.FEE_STRUCTURE_DET ADD (
  CONSTRAINT FEE_STRUCTURE_CLASS_FK 
 FOREIGN KEY (CLASS_ID) 
 REFERENCES CLASSIC1.CLASS (CLASS_ID),
  CONSTRAINT FEE_STRUCTURE_USER_FK 
 FOREIGN KEY (USER_ID) 
 REFERENCES CLASSIC1.USERS (USER_ID),
  CONSTRAINT FEE_STU_DET_FDATETIME_FK 
 FOREIGN KEY (FDATETIME) 
 REFERENCES CLASSIC1.FEE_STRUCTURE (FDATETIME));
