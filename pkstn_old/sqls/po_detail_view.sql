CREATE OR REPLACE VIEW ASKARI.PO_DETAIL_VIEW
(POD, PO, CPO, CPO_TYPE, OUR_CPO, 
 CPO_YEAR, DEMANDEDBY, PURPOSE, CATALOG_COPY, SAMPLE, 
 GUAGE, DRAWING, PO_DET_STATUS_ID, PO_ID, PO_YEAR, 
 PO_DATE, PO_TYPE, DELIVERY_DATE, BILL, STATUS_ID, 
 PO_DETAIL_ID, POSITION, CUSTOMER_ITEM_CODE, PO_STORE_CODE, STORE_CODE, 
 ITEM_DESCRIPTION, UNIT_ID, SC_MAIN_ID, SC_SUB_ID, SC_ID, 
 SC_MAIN_DESC, PO_QUANTITY, EXCESS_QTY, EXCESS_PER, RATE, 
 AMOUNT, SALES_TAX, ADD_SPECS, SC_FINISH_ID, SUPPLIER_ID, 
 SUPPLIER_NAME, SUPPLIER_ADDRESS, SUPPLIER_PHONE1, SUPPLIER_PHONE2)
AS 
select
  decode(po.po_type,'CASH','PO-CS','CREDIT','PO-CR')||'/'||PO.PO_ID||'/'||PO.PO_YEAR||'/'||PD.PO_DETAIL_ID POD,
  decode(po.po_type,'CASH','PO-CS','CREDIT','PO-CR')||'/'||PO.PO_ID||'/'||PO.PO_YEAR PO,
  cpo.cpo_type||'/'||po.our_cpo||'/'||po.cpo_year cpo,
  cpo.cpo_type,
  po.our_cpo,
  po.cpo_year, 
  po.demandedby,
  po.purpose, 
  po.user_id,
  pd.catalog_copy,
  pd.sample,pd.guage,pd.drawing,
  pd.status_id po_det_status_id,
  pd.po_id,
  pd.po_year,
  po.po_date,
  po.po_type,
  --po.supplier_id,
  pd.delivery_date,
  po.bill,
  po.status_id,
  pd.po_detail_id,
  pd.position,
 cc.item_code customer_item_code,
  translate(to_char(pd.sc_main_id,'000')||'-'||to_char(pd.sc_sub_id,'0000')||'-'||to_char(pd.sc_id,'00'),'0123456789- ','0123456789-') po_store_code,
  translate(to_char(pd.sc_main_id,'000')||'-'||to_char(pd.sc_sub_id,'0000')||'-'||to_char(pd.sc_id,'00'),'0123456789- ','0123456789-') store_code,
  store_code_desc.store_code(pd.sc_main_id,pd.sc_sub_id,pd.sc_id) item_description,
  store_code_desc.store_code_unit(pd.sc_main_id, pd.sc_sub_id, pd.sc_id) unit_id,
  pd.sc_main_id sc_main_id,
  pd.sc_sub_id sc_sub_id,
  pd.sc_id sc_id,
  store_code_desc.store_code(pd.sc_main_id) sc_main_desc,
  pd.po_quantity,
  pd.excess_qty,
  pd.excess_per,
  pd.rate,
  pd.po_quantity * pd.rate amount,
  pd.sales_tax,
  pd.add_specs,
  pd.sc_finish_id,
  po.supplier_id,
  s.description supplier_name,
  s.address supplier_address,
  s.phone supplier_phone1,
  s.phone2 supplier_phone2
from
 po,
 po_detail pd,
 cpo,
 customer_code cc,
 supplier s
where
   po.po_id   = pd.po_id
and po.po_year = pd.po_year
and po.po_type = pd.po_type
------
and po.our_cpo = cpo.our_cpo(+)
and po.cpo_year=cpo.cpo_year(+)
------
and po.supplier_id = s.supplier_id;

