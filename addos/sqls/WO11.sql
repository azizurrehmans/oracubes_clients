ALTER TABLE ASKARI.WO
 ADD CONSTRAINT WO_TYPE_CHECK
 CHECK (WO_TYPE IN ('CASH','CREDIT'));

