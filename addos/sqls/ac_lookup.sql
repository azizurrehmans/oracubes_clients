CREATE OR REPLACE FUNCTION ADDOS.ac_coa_lookup(sc number) RETURN varchar2 IS
  answer varchar2(500);
  x number;
BEGIN
    select count(*) into x from ac_coa where coa_seq = sc;
  if (x > 0) then
      select description into answer from ac_coa where coa_seq = sc;
      return answer;
  end if;
  return sc||' is an invalid COA';
END;
/
