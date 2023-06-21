CREATE OR REPLACE function ADDOS.exp_carton_item_counter(ctn number, n1 number, n2 number)
return char
is
  ans varchar2(500);
  x number := 0;
  cursor items is select item_id from exp_carton where carton_id = ctn
  order by item_id;
begin
  ans := null;
  for r in items
  loop
    x := x + 1;
    if (x >= n1) and (x <= n2 ) 
    then
        if (ans is null) then ans := '('||r.item_id;
        else ans := ans || ','|| r.item_id;
        end if;
    end if;
  end loop;
  
  return ans||')';
end;
/
