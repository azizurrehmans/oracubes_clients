CREATE OR REPLACE VIEW ORACLE.VOUCHER_DETAIL_VIEW_NEW
(VOUCHER_ID, VOUCHER_TYPE_ID, VOUCHER_MONTH_ID, VOUCHER_DATE, VOUCHER_NO, 
 SHORT_VOUCHER_TYPE, CHEQUE_NO, CHEQUE_DATE, DESCRIPTION, REMARKS, 
 EMPLOYEE_ID, SALARY_ID, VOUCHER_DETAIL_DESC, VOUCHER_DETAIL_ID, COA_MAIN_ID, 
 COA_SUB_ID, COA_ID, ACC, COA, COA_MAIN_SUB_ID, 
 DR_AMOUNT, CR_AMOUNT, DR_CR_DIFF, ACCT, CHQ, 
 SUB_ACC_DESC, COA_DESC, ACC_DESC, MAIN_SUB_ACC_DESC, MAIN_ACC_DESC, 
 CATAGORY, SUBSIDARY)
AS 
SELECT
  V.VOUCHER_ID, V.VOUCHER_TYPE_ID, V.VOUCHER_MONTH_ID , V.VOUCHER_DATE,
  VT.SHORT_NAME||'/'||V.VOUCHER_ID||'/'||VD.VOUCHER_DETAIL_ID VOUCHER_NO,
  VT.SHORT_NAME SHORT_VOUCHER_TYPE,
  V.CHEQUE_NO,
  V.CHEQUE_DATE,
  V.DESCRIPTION,
  V.REMARKS, 
  v.employee_id,    
  v.salary_id,
  VD.DESCRIPTION VOUCHER_DETAIL_DESC,
  VD.VOUCHER_DETAIL_ID,
  VD.COA_MAIN_ID, VD.COA_SUB_ID, VD.COA_ID,
  TRANSLATE(
  TO_CHAR(VD.COA_MAIN_ID,'00')||'-'||TO_CHAR(VD.COA_SUB_ID,'0000')||'-'||TO_CHAR(VD.COA_ID,'00000'),
  '0123456789- ','0123456789-') ACC,
  TRANSLATE(
  TO_CHAR(VD.COA_MAIN_ID,'00')||'-'||TO_CHAR(VD.COA_SUB_ID,'0000')||'-'||TO_CHAR(VD.COA_ID,'00000'),
  '0123456789- ','0123456789-') COA,
  TRANSLATE(
  TO_CHAR(VD.COA_MAIN_ID,'00')||'-'||TO_CHAR(VD.COA_SUB_ID,'0000'),
  '0123456789- ','0123456789-') COA_MAIN_SUB_ID,
  VD.DR_AMOUNT,
  VD.CR_AMOUNT,
  VD.DR_AMOUNT - VD.CR_AMOUNT DR_CR_DIFF,
  VD.ACCOUNT_NO ACCT,
  VD.CHEQUE_NO CHQ,
  -----DRCR,
  SAC.DESCRIPTION SUB_ACC_DESC,
  COA.DESCRIPTION COA_DESC,
  MAC.DESCRIPTION||'-'||SAC.DESCRIPTION||COA.DESCRIPTION ACC_DESC,
  MAC.DESCRIPTION||'-'||SAC.DESCRIPTION MAIN_SUB_ACC_DESC,
  MAC.DESCRIPTION MAIN_ACC_DESC,
  MAC.CATAGORY,
  MAC.SUBSIDARY
FROM
  VOUCHER V,
 VOUCHER_DETAIL_NEW VD,
  COA,
  COA_MAIN MAC,
  COA_SUB SAC,
  VOUCHER_TYPE VT
WHERE
    V.VOUCHER_ID       = VD.VOUCHER_ID
AND V.VOUCHER_TYPE_ID  = VD.VOUCHER_TYPE_ID
AND V.VOUCHER_MONTH_ID = VD.VOUCHER_MONTH_ID
---
AND VD.COA_MAIN_ID = COA.COA_MAIN_ID
AND VD.COA_SUB_ID  = COA.COA_SUB_ID
AND VD.COA_ID  = COA.COA_ID
---
AND VD.COA_MAIN_ID = SAC.COA_MAIN_ID
AND VD.COA_SUB_ID  = SAC.COA_SUB_ID
---
AND VD.COA_MAIN_ID = MAC.COA_MAIN_ID
---
AND V.VOUCHER_TYPE_ID = VT.VOUCHER_TYPE_ID;

