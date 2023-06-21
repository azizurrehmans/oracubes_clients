CREATE OR REPLACE VIEW ASKARI.BTN_VIEW
(BTN_ID, BTN_YEAR, BTN_NO, BTN_DATE, JUSTIFICATION, 
 REMARKS, DEPARTMENT_ID, STATUS_ID, FROM_SC_MAIN_ID, FROM_SC_SUB_ID, 
 FROM_SC_ID, FROM_STORE_CODE, FDATETIME, USER_ID, TO_SC_MAIN_ID, 
 TO_SC_SUB_ID, TO_SC_ID, TO_STORE_CODE, FROM_QTY, TO_QTY, 
 FROM_DATE_BALANCE, TO_DATE_BALANCE, FROM_VALUE, TO_VALUE, FROM_SC_DESC, 
 TO_SC_DESC, TO_UNIT_ID, FROM_UNIT_ID)
AS 
SELECT
 BTN_ID,
 BTN_YEAR,
 'BTN/'||BTN_ID||'/'||BTN_YEAR BTN_NO,
 BTN_DATE,
 JUSTIFICATION,
 REMARKS,
 DEPARTMENT_ID,
 BTN.STATUS_ID,
 FROM_SC_MAIN_ID,
 FROM_SC_SUB_ID,
 FROM_SC_ID,
 TRANSLATE(TO_CHAR(FROM_SC_MAIN_ID,'000')||'-'||TO_CHAR(FROM_SC_SUB_ID,'0000')||'-'||TO_CHAR(FROM_SC_ID,'00'),'0123456789- ','0123456789-') FROM_STORE_CODE,

 BTN.FDATETIME,
 BTN.user_ID,
 TO_SC_MAIN_ID,
 TO_SC_SUB_ID,
 TO_SC_ID,
 TRANSLATE(TO_CHAR(TO_SC_MAIN_ID,'000')||'-'||TO_CHAR(TO_SC_SUB_ID,'0000')||'-'||TO_CHAR(TO_SC_ID,'00'),'0123456789- ','0123456789-') TO_STORE_CODE,
 
 FROM_QTY,
 TO_QTY,
 FROM_DATE_BALANCE,
 TO_DATE_BALANCE,
 from_value,
 to_value,
 store_sc_desc(from_sc_main_id, from_sc_sub_id, from_sc_id) from_sc_desc,
store_sc_desc(to_sc_main_id, to_sc_sub_id, to_sc_id) to_sc_desc,
v1.unit_id to_unit_id,
v2.unit_id from_unit_id

 
FROM 
  BTN,
  sc_view v1,
  sc_view v2
where to_sc_main_id = v1.sc_main_id and to_sc_sub_id = v1.sc_sub_id and to_sc_id = v1.sc_id
and  from_sc_main_id = v2.sc_main_id and from_sc_sub_id = v2.sc_sub_id and from_sc_id = v2.sc_id;

