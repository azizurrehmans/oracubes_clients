ALTER TABLE CMI1.ADM_COMPANY_SETUP
MODIFY(ADDRESS VARCHAR2(300 BYTE));


ALTER TABLE CMI1.ADM_COMPANY_SETUP
 ADD (address2  VARCHAR2(300));
 
 
 CREATE OR REPLACE FUNCTION CMI1."COMPANY_ADDRESS"  RETURN varchar2 IS 
  x varchar2(500); 
BEGIN 
  select ADDRESS into x from adm_company_setup 
  where company_id=1;  
  return x; 
END;
/

