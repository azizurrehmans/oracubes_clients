ALTER TABLE ORACLE.MP
 ADD (customer_id  NUMBER                           NOT NULL);

ALTER TABLE ORACLE.MP
 ADD CONSTRAINT mp_customer_fk 
 FOREIGN KEY (customer_id) 
 REFERENCES ORACLE.CUSTOMER (customer_id);

