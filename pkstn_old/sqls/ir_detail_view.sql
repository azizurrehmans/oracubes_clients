CREATE OR REPLACE VIEW ASKARI.IR_DETAIL_VIEW
(CPO_TYPE, OUR_CPO, CPO_YEAR, STYLE, COLOR_ID, 
 UNIT_ID, IR_TYPE, USER_ID, CPO, IR_ID, 
 IR_YEAR, IR_DATE, FDATETIME, CPO_ID, POSITION, 
 JOB_CARD_ID, JOB_CARD, ORDER_INFO, DEPARTMENT_ID, ISSUED_TO, 
 DOC_NO, JOB_QTY, STATUS_ID, IR_DETAIL_ID, SC_MAIN_ID, 
 SC_SUB_ID, SC_ID, REQ_QTY, ISSUE_QTY, VALUE, 
 SC_FINISH_ID, SC_MAIN_DESC, SC_CODE, SC_SUB_DESC, SC_DESC, 
 SC_DESCRIPTION)
AS 
SELECT i.cpo_type, i.our_cpo, i.cpo_year, i.style, color_id, scv.unit_id,
          i.ir_type,   
          i.user_id,
          i.our_cpo || '/' || i.cpo_year || '/' || i.style || '/'
          || color_id cpo,
          ID.ir_id, ID.ir_year, i.ir_date, i.fdatetime, i.cpo_id, i.POSITION,
          i.new_jc job_card_id,
          i.cpo_id || '/' || i.POSITION || '/' || i.new_jc job_card,
             i.cpo_type
          || '/'
          || i.our_cpo
          || '/'
          || i.cpo_year
          || '/'
          || i.style
          || '/'
          || i.color_id
          || '/'
          || i.rsize order_info,
          i.department_id, i.issued_to, i.doc_no, i.job_qty, i.status_id,
          ID.ir_detail_id, ID.sc_main_id, ID.sc_sub_id, ID.sc_id, ID.req_qty,
          ID.issue_qty, ID.VALUE, ID.sc_finish_id, scv.sc_main_desc,
          scv.sc_code, scv.sc_sub_desc, scv.sc_desc,
          scv.description sc_description
     FROM ir_detail ID, sc_view scv, ir i
    WHERE ID.sc_main_id = scv.sc_main_id
      AND ID.sc_sub_id = scv.sc_sub_id
      AND ID.sc_id = scv.sc_id
      AND ID.ir_id = i.ir_id
      AND ID.ir_year = i.ir_year;

