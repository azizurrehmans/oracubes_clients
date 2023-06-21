CREATE OR REPLACE FUNCTION prod_lOT_ISSUE_QTY 
(a varchar2, b varchar2, c number, d number, e number, f date, t date) 
RETURN number IS
x number;
BEGIN
  select sum(qty) into x from prod_jcd
  where our_cpo=a
    --and cpo_year=b
    and POSITION=c
    and operation_no=d
    and stage=e
    and trunc(ISSUE_Date) between trunc(f) and trunc(t);
    
    return nvl(x,0);
END;