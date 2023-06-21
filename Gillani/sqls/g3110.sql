CREATE OR REPLACE FUNCTION GILLANI.exp_cpo_balance_qty(c varchar2, y varchar2)
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
  select nvl(sum(quantity),0) into o from exp_cpo_detail where cpo_id = c and cpo_year = y; 
  select nvl(sum(pd.qty),0) into x 
  from exp_packing_detail pd,
  exp_packing p
  where p.packing_id = pd.packing_id
  and p.packing_year = pd.packing_year
  and pd.cpo_id = c; 
  
  --tempVar := o - x;
  return nvl(o-x,0);
   
END;