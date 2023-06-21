/*<TOAD_FILE_CHUNK>*/
drop table inv_opening_qty_1819;
CREATE TABLE INV_OPENING_QTY_1819 AS
select sc_id, inv_closing_qty_date(sc_id, '30-jun-2019', 'OK') qty,  'OK' STATUS,   ROUND(inv_last_purchase_rate(sc_id, '30-jun-2019','OK')) rate from inv_SC;

--SELECT DISTINCT(ITEM_STATUS) FROM INV_TRANS;

--ALTER TABLE INV_OPENING_QTY_1819 MODIFY(STATUS VARCHAR2(8));

--INSERT INTO INV_OPENING_QTY_31052018 
--select sc_id, inv_opening_qty_date(sc_id, sysdate, 'OK') qty, 'OK' STATUS, ROUND(inv_last_purchase_rate(sc_id, sysdate)) rate from inv_sc;

--INSERT INTO INV_OPENING_QTY_1819 
--select sc_id, inv_closing_qty_date(sc_id, '30-jun-2019', 'FAULTY') qty, 'FAULTY' STATUS, ROUND(inv_last_purchase_rate(sc_id, '30-jun-2019','OK')) rate from inv_sc;

--INSERT INTO INV_OPENING_QTY_1819 
--select sc_id, inv_closing_qty_date(sc_id, '30-jun-2019', 'DAMAGE') qty, 'DAMAGE' STATUS, ROUND(inv_last_purchase_rate(sc_id, '30-jun-2019','OK')) rate from inv_sc;

drop table inv_sc_opening_1819_backup;
CREATE TABLE INV_SC_OPENING_1819_BACKUP AS SELECT * FROM INV_SC_OPENING;
drop table inv_trans_1819_backup;
CREATE TABLE INV_TRANS_1819_BACKUP AS SELECT * FROM INV_TRANS;

delete from inv_sc_opening where oyear='19-20';

INSERT INTO INV_SC_OPENING (SC_ID, OQTY, OVALUE, FDATETIME, OYEAR, USER_ID, ORATE, ITEM_STATUS)
SELECT SC_ID, QTY, RATE, SYSDATE,'19-20','aziz',rate,status from inv_opening_qty_1819;
