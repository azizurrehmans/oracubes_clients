DROP USER HABIB CASCADE;
create user habib identified by one;
grant dba to habib;
alter user habib default tablespace "ORACUBES" QUOTA UNLIMITED ON "ORACUBES";