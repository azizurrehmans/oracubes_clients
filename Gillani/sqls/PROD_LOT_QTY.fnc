CREATE OR REPLACE FUNCTION prod_lot_qty 
(a varchar2, b varchar2, c number, d number, e number, f date, t date) 
RETURN number IS
x number;
BEGIN
  select sum(rec_qty) into x from prod_jcd
  where our_cpo=a
    and POSITION=c
    and operation_no=d
    and stage=e
    and trunc(rec_Date) between trunc(f) and trunc(t);
    
    return nvl(x,0);
END;