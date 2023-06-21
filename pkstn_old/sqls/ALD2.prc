create or replace procedure stu_create_challan(stu number, challan_type varchar2, from_month date, to_date date, user_id varchar2, challan_no number)
--return varchar2
IS
 X NUMBER;
 CH_SEQ NUMBER;
 stu_class varchar2(10);
 stu_section varchar2(5);
 sts varchar2(10);
BEGIN
--    aziz.msg(:inquiry.class_id);
  
  
  ---result := 'Challan for this student for this month is already created';
     
  select status_id, class, section into sts, stu_class, stu_section from stu_student_view where student_id = stu;  
          
  insert into stu_fee (student_id, fdatetime, due_date, challan_id, fee_month, user_id, status_id, inquiry_id, class, section, challan_type, total_late, total)
  values (stu,sysdate, trunc(sysdate)+5 , challan_no, from_month, user_id, 'HOLD',0, stu_class, stu_section, challan_type,0,0);
   
  if (challan_type = 'MON') then       
    insert into stu_fee_det (FDATETIME, FEE_HEAD_ID, AMOUNT, CHALLAN_ID, FEE_HEAD_DESC)
    select SYSDATE, FEE_HEAD_ID, MON_AMOUNT, challan_no, FEE_HEAD_DESC
    from stu_fee_stru_class_det_view where class_id = stu_class AND MON_AMOUNT > 0; 
  elsif (challan_type = 'ANU') then
    insert into stu_fee_det (FDATETIME, FEE_HEAD_ID, AMOUNT, CHALLAN_ID, FEE_HEAD_DESC)
    select SYSDATE, FEE_HEAD_ID, ANU_AMOUNT, challan_no, FEE_HEAD_DESC
    from stu_fee_stru_class_det_view where class_id = stu_class AND ANU_AMOUNT > 0;   
end if;  
 -- AZIZ.MSG('***CHALLAN '||CH_SEQ||' GENERATED SUCCESSFULLY');
  insert into stu_monthly_challan_no (student_id, fee_month, challan_type, challan_id)
  values (stu, from_month, challan_type, challan_no);
  commit;
  ---result := 'created successfully';

end;

ALTER TABLE ALLIED.STU_FEE MODIFY(CHALLAN_TYPE VARCHAR2(10 BYTE));

select stu_create_challan(1,'MONTHLY','01-MAR-2022','01-MAR-2022','aziz', :result) from dual;

SET SERVEROUTPUT ON;

DECLARE
    v_f_name  varchar2(100);
BEGIN
    stu_create_challan(1,'MONTHLY','01-MAR-2022','01-MAR-2022','aziz', v_f_name)
    --proc_getempdetails(100, v_f_name, v_l_name);
    dbms_output.put_line(v_f_name);
END;

