CREATE USER mughal IDENTIFIED BY "one"  DEFAULT TABLESPACE "ORACUBES"  QUOTA UNLIMITED ON "ORACUBES";
GRANT "DBA" TO mughal WITH ADMIN OPTION;
ALTER USER mughal DEFAULT ROLE "DBA";