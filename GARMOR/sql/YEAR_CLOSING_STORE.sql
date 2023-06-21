drop table sc_opening_2021;

create table sc_opening_2021
as
select sc_id, 
nvl(opening_qty_date(sc_id, '30-jun-2020'),0) oq,
nvl(opening_value_date(sc_id, '30-jun-2020'),0) ov, 
'RELEASE' status_id, sysdate fdatetime, '21' oyear, 'aqdas' user_id from sc5;

delete  FROM sc_opening_2021 where sc_id in (select sc_id from sc5_opening where oyear='21');

SELECT * FROM sc_opening_2021 where ov> 0 AND OQ=0;

update sc_opening_2021 set oq=0 where oq< 0;
update sc_opening_2021 set ov=0 where ov< 0;
update sc_opening_2021 set ov=0 where ov> 0 AND OQ=0;

insert into sc5_opening (sc_id, oqty, orate, status_id, fdatetime, oyear, user_id)
select sc_id, oq, ov/oq, status_id, fdatetime, oyear, user_id from sc_opening_2021
where oq>0;