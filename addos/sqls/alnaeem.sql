select inv_sc_avg_rate(29576,sysdate) from dual;
select distinct oyear from inv_sc_opening;

select o.sc_id, o.oqty from inv_sc_opening o;

update inv_sc_opening ovalue= p

select sc_id, sum(rec_qty) rec_qty,
case  when sum(rec_qty) > 0 then trunc(sum(rec_value)/sum(rec_qty)) else 0 end avg_value from inv_trans group by sc_id;


declare
  av number;
  cursor op_cur is select sc_id, oqty, ovalue from inv_sc_opening where oqty > 0 and ovalue = 0 for update;
begin
  for r in op_cur
  loop
  
    select  case  when sum(rec_qty) > 0 then trunc(sum(rec_value)/sum(rec_qty)) else 0 end into av 
    from inv_trans where sc_id = r.sc_id;
    
    update inv_sc_opening set ovalue=av where current of op_cur;
    
  end loop;
end;  

commit;  
   
update inv_sc_opening a set ovalue = (select  case when sum(rec_qty) > 0 then trunc(sum(rec_value)/sum(rec_qty)) else 0 end into av 
    from inv_trans where sc_id = a.sc_id)
    where oqty > 0 and ovalue = 0;