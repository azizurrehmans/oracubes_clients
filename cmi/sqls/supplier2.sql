ALTER TABLE ASKARI.SUPPLIER
 ADD CONSTRAINT suppliers_user_fk 
 FOREIGN KEY (USER_ID) 
 REFERENCES ASKARI.USERS (USER_ID);
