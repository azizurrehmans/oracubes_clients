CREATE TABLE GILLANI.EXP_CSC_SPECIAL_INS
(
  CSC_ID       NUMBER,
  SPECIAL_INS  VARCHAR2(4000 BYTE)
)
TABLESPACE ORACUBES
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
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


CREATE UNIQUE INDEX GILLANI.EXP_CSC_SPECIAL_INS_PK ON GILLANI.EXP_CSC_SPECIAL_INS
(CSC_ID)
LOGGING
TABLESPACE ORACUBES
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE GILLANI.EXP_CSC_SPECIAL_INS ADD (
  CONSTRAINT EXP_CSC_SPECIAL_INS_PK
 PRIMARY KEY
 (CSC_ID)
    USING INDEX 
    TABLESPACE ORACUBES
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE GILLANI.EXP_CSC_SPECIAL_INS ADD (
  CONSTRAINT EXP_CSC_SPCS_INS_FK 
 FOREIGN KEY (CSC_ID) 
 REFERENCES GILLANI.EXP_CSC_SPECIAL_INS (CSC_ID));