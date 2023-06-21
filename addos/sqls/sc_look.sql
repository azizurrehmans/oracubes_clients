CREATE OR REPLACE FUNCTION ADDOS.inv_sc_lookup(sc number, fld varchar2) RETURN varchar2 IS
  answer varchar2(500);
  x number;
BEGIN
  select count(*) into x from inv_sc where sc_id = sc;
  if (x > 0) then
    if (fld = 'desc') then
      select description into answer from inv_sc where sc_id = sc;
      return answer;
    elsif (fld = 'unit') then
      select uom_id into answer from inv_sc where sc_id = sc;
      return answer;    
    end if;  
  end if;
  return sc||' is an Invalid Item Code';
END;
/
