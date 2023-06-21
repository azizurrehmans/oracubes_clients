ALTER TABLE AC_COA_OPENING DROP CONSTRAINT AC_COA_OPENING_PK;
ALTER TABLE AC_COA_OPENING DROP COLUMN YEAR_ID;
ALTER TABLE AC_COA_OPENING ADD CONSTRAINT AC_COA_OPENING_PK  PRIMARY KEY (COA_SEQ);
CREATE OR REPLACE FUNCTION "COUNTCHAR" (c1 varchar2,c2 varchar2) RETURN number IS
x number;
v varchar2(50);
thisc char(1);
y number;
BEGIN
    y := 0;
  x := length(c1);
  for a in 1 .. x
  loop
      thisc := substr(c1,a,1);
      if (thisc = c2 ) then
          y := y + 1;
      end if;    
  end loop;
  
  return y;
END;

