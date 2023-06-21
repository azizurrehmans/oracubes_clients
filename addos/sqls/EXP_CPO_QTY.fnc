CREATE OR REPLACE FUNCTION ADDOS.exp_cpo_qty(c varchar2)
RETURN NUMBER IS
tmpVar NUMBER;
x number;
o number;
/******************************************************************************
   NAME:       cpo_balance_qty
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/19/2012          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     cpo_balance_qty
      Sysdate:         10/19/2012
      Date and Time:   10/19/2012, 5:13:25 PM, and 10/19/2012 5:13:25 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
  tmpVar := 0;
  select nvl(sum(quantity),0) into o from exp_cpo_detail where cpo_id = c; 
   
  --tempVar := o - x;
  return nvl(o,0);
   
END;