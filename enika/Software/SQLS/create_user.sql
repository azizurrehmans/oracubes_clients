CREATE USER enika IDENTIFIED BY "one" DEFAULT TABLESPACE "ORACUBES" QUOTA UNLIMITED ON "ORACUBES";
GRANT "DBA" TO enika WITH ADMIN OPTION;
ALTER USER enika DEFAULT ROLE "DBA";