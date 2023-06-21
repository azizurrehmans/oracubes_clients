CREATE TABLE ORACLE4.FIREWALL
(
  FIREWALL_ID  NUMBER,
  DESCRIPTION  VARCHAR2(100),
  PASSO        VARCHAR2(20)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
NOMONITORING;


ALTER TABLE ORACLE4.FIREWALL ADD (
  CONSTRAINT FIREWALL_PK
 PRIMARY KEY
 (FIREWALL_ID));

