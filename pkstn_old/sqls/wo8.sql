ALTER TABLE ASKARI.WO_DETAIL
 ADD (sc_main_id  NUMBER(3)                         NOT NULL);

ALTER TABLE ASKARI.WO_DETAIL
 ADD (sc_sub_id  NUMBER(4)                          NOT NULL);

ALTER TABLE ASKARI.WO_DETAIL
 ADD (sc_id  NUMBER(4)                              NOT NULL);

ALTER TABLE ASKARI.WO_DETAIL
 ADD (in_out  VARCHAR2(1)                           NOT NULL);

