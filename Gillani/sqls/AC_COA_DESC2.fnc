CREATE OR REPLACE FUNCTION AC_COA_DESC2(DES VARCHAR2) RETURN VARCHAR2 IS
tmpVar NUMBER;
/******************************************************************************
   NAME:       COA_LOOKUP
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        4/10/2017          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     COA_LOOKUP
      Sysdate:         4/10/2017
      Date and Time:   4/10/2017, 1:19:37 PM, and 4/10/2017 1:19:37 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
X NUMBER;
ANS VARCHAR2(200);
BEGIN
   SELECT COUNT(*) INTO X FROM AC_COA WHERE COA_SEQ = DES;
   IF (X > 0) THEN
      SELECT DESCRIPTION INTO ANS FROM AC_COA WHERE COA_SEQ = DES;
      RETURN ANS;
   ELSE
      RETURN '-';
   END IF;      
   tmpVar := '-';
   RETURN tmpVar;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END AC_COA_DESC2;
/
        