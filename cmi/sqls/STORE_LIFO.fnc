CREATE OR REPLACE function ORACLE.store_lifo
	(trx_id number, 
	 trx_year varchar2,
	 trx_date date, 
	 M NUMBER, 
	 S NUMBER, 
	 C NUMBER, 
	 q number,
	 y varchar2)
return varchar2 
IS
	tmpVar NUMBER;
	tif_trx_id number;
	tif_trx_year number;
	tif_trx_date date;
	tif_trx_type varchar2(10);
	tif_gir number;
	tif_gir_year varchar2(5);
	tif_gir_detail number;
	tif_btn number;
	tif_btn_year varchar2(5);
	tif_btn_detail varchar2(2);
	tif_san number;
	tif_san_year varchar2(5);
	tif_qty number;
	tif_value number;
	tif_rec_qty number;
	tif_rec_value number;
	tif_update_value number;
	rate number;
	x number;
	tif_update_qty number;
	loop_qty number;
	loop_value number;
	bal_qty number;
	answer varchar2(50);
/******************************************************************************
   NAME:       store_lifo_valuation
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        1/10/2013          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     store_lifo_valuation
      Sysdate:         1/10/2013
      Date and Time:   1/10/2013, 5:16:40 PM, and 1/10/2013 5:16:40 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
function already_valuated
return number
is 
T NUMBER;
X NUMBER;
BEGIN
       ----aziz.msg('going to check '||tid||'-'||tyr);
      SELECT COUNT(*) INTO T FROM TIF_detail
      WHERE TRANS_ID = Trx_ID AND TRANS_YEAR = TRX_YEAR;
    
     IF (T > 0) THEN 
        --AZIZ.MSG(TID||'/'||TYR||' IS ALREADY VALUATED');
        X := 1;
     ELSE
           X := 0;
           --RAISE FORM_TRIGGER_FAILURE;
     END IF;
    
     RETURN X;
END;
/******************************************************************************/
function tif_rate
return number
is
x number;
begin

  select count(*) into x  
  from        tif_detail_view
     where       rec_trans_id = (select max(rec_trans_id) from tif_detail_view 
                  where rec_sc_main_id=m and rec_sc_sub_id=s and rec_sc_id=c
                  and tif_bal_qty > 0
                  and rec_trans_date <= trx_date);
  if (x > 0) then                
     select 
        rec_trans_type, rec_trans_id,rec_trans_year, rec_trans_date,
        rec_gir_id, rec_gir_year, rec_gir_detail_id,
        rec_btn_id, rec_btn_year, rec_btn_detail_id,
        rec_san_id, rec_san_year,
        rec_qty, rec_value, 
        tif_bal_qty, tif_bal_value
     into 
        tif_trx_type, tif_trx_id, tif_trx_year, tif_trx_date,
        tif_gir, tif_gir_year, tif_gir_detail,
        tif_btn, tif_btn_year, tif_btn_detail,
        tif_san, tif_san_year,
        tif_rec_qty, tif_rec_value,
        tif_qty, tif_value
     from        tif_detail_view
     where       rec_trans_id = (select max(rec_trans_id) from tif_detail_view 
                  where rec_sc_main_id=m and rec_sc_sub_id=s and rec_sc_id=c
                  and tif_bal_qty > 0
                  and rec_trans_date <= trx_date);
     --tmpvar := tif_trx_id;
     
     if (tif_value > 0) and (tif_qty > 0) then
       rate := tif_value / tif_qty;  
     else
       rate := 0;
     end if;
     
  else
    null;
    
    select count(*) into x from tif_opening_detail_view 
    where sc_main_id = m and sc_sub_id=s and sc_id = c and sc_opening_year=y
    and tif_bal_qty > 0;
    
    if (x > 0) then
      select tif_bal_qty, tif_bal_value into tif_qty, tif_value from tif_opening_detail_view
      where sc_main_id = m and sc_sub_id=s and sc_id = c and sc_opening_year=y;
      
       if (tif_value > 0) and (tif_qty > 0) then
        tif_trx_type := 'OPENING';
        --tif_trx_id := 0;
        --tif_trx_year := '-';
        rate := tif_value / tif_qty;  
      else
        rate := 0;
      end if;
    end if;
         
  end if;
  
     
     return rate;
end;
/******************************************************************************/
procedure update_tif
is
x number;
begin
  select count(*) into x from tif
  where trans_id = tif_trx_id and trans_year = tif_trx_year;
  
  if (x = 0) and (tif_trx_type <> 'OPENING') then
    insert into tif (trans_id, trans_year, trans_type,gir_id, gir_year, gir_detail_id,
                     btn_id, btn_year, btn_detail_id, san_id, san_year, 
                     qty, value)
                values
                    (tif_trx_id, tif_trx_year, tif_trx_type, 
                    tif_gir, tif_gir_year, tif_gir_detail,
                    tif_btn, tif_btn_year, tif_btn_detail, 
                    tif_san,tif_san_year, 
                    tif_rec_qty, tif_rec_value);
  end if; 
  
  select count(*) into x from tif_detail
  where trans_id = trx_id and trans_year = trx_year
  and tif_trans_id = tif_trx_id and tif_trans_id = tif_trans_year;
  
  if (x = 0) then
    insert into tif_detail 
        (trans_id, trans_year, 
        tif_trans_id, tif_trans_year, 
        qty, value,
         trans_type,sc_main_id, sc_sub_id, sc_id)
    values 
        (trx_id, trx_year, 
        decode(tif_trx_type,'GIR',tif_trx_id,'SAN',tif_trx_id,'BTM',tif_trx_id,NULL), tif_trx_year,
         tif_update_qty,tif_update_qty*rate,
         tif_trx_type,m,s,c);
  end if;       
                       
end; 
/**********************************************************************************/
procedure update_trans
is
begin
  update trans set issue_value = loop_value
  where trans_id = trx_id and trans_year = trx_year;
  answer := 'VALUATION DONE';
end;
/**********************************************************************************/

BEGIN
   
   IF (ALREADY_VALUATED = 0) THEN
    loop_qty := 0;   
    loop_value := 0;
    bal_qty := q;
    
        while loop_qty < q
        loop 
                                                                                                                     --    aziz.msg('a1');
           tmpvar := tif_rate;
                                                                                                            --    aziz.msg('a2');

           if (tif_qty >= q-loop_qty) then
             tif_update_qty := q-loop_qty;
             tif_update_value := (q-loop_qty) * rate;    
             loop_qty := q;
             loop_value := loop_value + tif_update_value;     
           else
             tif_update_qty := tif_qty;
             tif_update_value := tif_qty * rate;
             loop_qty := loop_qty + tif_qty;             
             loop_value := loop_value + tif_update_value;
           end if;
                                                                                                           --    aziz.msg('a3a');  
           update_tif;
                                                                                                            --    aziz.msg('a4');
           --loop_qty := loop_qty + tif_update_qty;
           --loop_value := loop_value + tif_update_qty * rate;
                                                                                                        --        aziz.msg('a5');
           
        end loop;
        
     if (loop_qty <> q) then
          ANSWER := 'Quantity is not sufficient';
     else     
       update_trans;
     end if;  
     --tmpvar := 1;           
   ELSE
     TMPVAR := 0;
     ANSWER := 'ALREADY VALUATED';  
   END IF; 
   
   
   RETURN ANSWER;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END store_lifo;
/
