create user sahi identified by one default tablespace ORACUBES QUOTA UNLIMITED ON ORACUBES;
GRANT DBA TO SaHI WITH ADMIN OPTION;
ALTER USER SAHI DEFAULT ROLE DBA;