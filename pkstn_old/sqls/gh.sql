ALTER TABLE ASKARI.GH
 ADD (user_id  VARCHAR2(20)                         NOT NULL);

ALTER TABLE ASKARI.GH
 ADD (fdatetime  DATE                               NOT NULL);

ALTER TABLE ASKARI.GH DROP COLUMN INSERT_BY;

ALTER TABLE ASKARI.GH DROP COLUMN INSERT_DATE;

ALTER TABLE ASKARI.GH DROP COLUMN INSERT_TERM;

ALTER TABLE ASKARI.GH DROP COLUMN LAST_UPDATED_BY;

ALTER TABLE ASKARI.GH DROP COLUMN LAST_UPDATED_DATE;

ALTER TABLE ASKARI.GH DROP COLUMN LAST_UPDATED_TERM;

