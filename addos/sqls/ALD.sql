create table stu_student_previous_data as select * from stu_student;
select max(student_id) from stu_student;
update stu_student set student_id = student_id + 10000;
select s.OLD_STUDENT_ID from stu_student s order  by s.old_student_id;

declare
  x number:= 0;
  cursor stu_cur is select old_student_id, student_id from stu_student order by old_student_id for update;  
begin
  for r in stu_cur
  loop
     x := x + 1;
     update stu_student set student_id = x where current of stu_cur;
  end loop;
end;  


select student_id, old_student_id from stu_student order  by old_student_id;

ALTER TABLE ALLIED.STU_MONTHLY_CHALLAN_NO DROP PRIMARY KEY CASCADE;
ALTER TABLE ALLIED.STU_MONTHLY_CHALLAN_NO ADD (CHALLAN_TYPE  VARCHAR2(10));
ALTER TABLE ALLIED.STU_MONTHLY_CHALLAN_NO ADD (CHALLAN_YEAR  DATE);
ALTER TABLE ALLIED.STU_MONTHLY_CHALLAN_NO ADD CONSTRAINT STU_MONTHLY_CHALLAN_NO_PK PRIMARY KEY (STUDENT_ID, FEE_MONTH, CHALLAN_TYPE);

create or replace function create_challan(stu number, challan_type varchar2, from_month date, to_date date, user_id varchar2)
return varchar2
IS
 X NUMBER;
 CH_SEQ NUMBER;
 stu_class varchar2(10);
 stu_section varchar2(5);
 sts varchar2(10);
BEGIN
--	aziz.msg(:inquiry.class_id);
	SELECT STU_CHALLAN_SEQ.NEXTVAL INTO CH_SEQ FROM DUAL;
    
    select status_id, class, section into sts, stu_class, stu_section from stu_student_view where student_id = stu;
    
    
  
  
  insert into stu_fee (fdatetime, due_date, challan_id, fee_month, user_id, status_id, inquiry_id, class, section, challan_type)
  values (sysdate, trunc(sysdate)+5 , ch_seq, from_month, user_id, 'HOLD',null, stu_class, stu_section, challan_type);
  
  insert into stu_fee_det (FDATETIME, FEE_HEAD_ID, AMOUNT, CHALLAN_ID, FEE_HEAD_DESC)
  select SYSDATE, FEE_HEAD_ID, ADM_AMOUNT, CH_SEQ, FEE_HEAD_DESC
  from stu_fee_stru_class_det_view where class_id = stu_class;
  
 -- AZIZ.MSG('***CHALLAN '||CH_SEQ||' GENERATED SUCCESSFULLY');
  insert into stu_monthly_challan_no (student_id, fee_month, challan_type, challan_id)
  values (stu, from_month, challan_type, ch_seq);
  return 'successfull';
  return ch_seq;
END;
----
---ALTER TABLE ALLIED.STU_FEE  DROP PRIMARY KEY CASCADE;