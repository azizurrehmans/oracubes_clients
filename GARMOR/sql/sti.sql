update jcd set rec_date=null, issue_date=null, rec_user_id=null, issue_user_id=null, rec_qty=null,
payment_status_id=null, employee_id=0
where lot_id=4273 and stage=2;

insert into jcd(JCD_ID,  STAGE, OPERATION_NO, 
    EMPLOYEE_ID, 
    STATUS_ID,  QTY,  OUR_CPO,  CPO_YEAR, 
    POSITION,  USER_ID,  FDATETIME, 
    QTY_PACKS,  LOT_ID,  LOT_SUB_ID)
select  JC_seq.nextval,  STAGE,  4, 
    EMPLOYEE_ID, 
    STATUS_ID,  QTY,  OUR_CPO,  CPO_YEAR, 
    POSITION,  USER_ID,  FDATETIME, 
    QTY_PACKS,  LOT_ID,  LOT_SUB_ID from jcd
where lot_id=4273 and stage=2
and operation_no=1;