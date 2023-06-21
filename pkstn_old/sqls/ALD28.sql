INSERT INTO STU_BRANCH_CLASS 
SELECT 'SIALKOT CAMPUS', CLASS_ID, USER_ID, FDATETIME, 'RELEASE' FROM STU_BRANCH_CLASS;
SELECT * FROM STU_BRANCH_CLASS_SEC;
UPDATE STU_BRANCH_CLASS_SEC SET BRANCH_ID = 'SIALKOT CAMPUS';
UPDATE STU_HISTORY SET BRANCH = 'SIALKOT CAMPUS';
SELECT * FROM STU_HISTORY;
SELECT * FROM STU_FEE_STRUCTURE_DET;
DELETE FROM STU_BRANCH_CLASS WHERE BRANCH_ID='SIALKOT BRANCH';
DELETE FROM STU_BRANCH WHERE BRANCH_ID='SIALKOT BRANCH';

delete from stu_hist_det where student_id in (
select student_id from stu_student_view where class_admitted in ('PG','PREP','NURSERY'));
delete from stu_history where student_id in (
select student_id from stu_student_view where class_admitted in ('PG','PREP','NURSERY'));
update stu_student set status_id='HOLD' where student_id in (
select student_id from stu_student_view where class_admitted in ('PG','PREP','NURSERY'));

delete from stu_monthly_challan_no where challan_id in (select challan_id from stu_fee  where student_id in (
select student_id from stu_student_view where class_admitted in ('PG','PREP','NURSERY')));
delete from stu_fee_det where challan_id in (select challan_id from stu_fee  where student_id in (
select student_id from stu_student_view where class_admitted in ('PG','PREP','NURSERY')));
delete from stu_fee where challan_id in (select challan_id from stu_fee  where student_id in (
select student_id from stu_student_view where class_admitted in ('PG','PREP','NURSERY'))); 

UPDATE STU_HISTORY SET BRANCH = 'SIALKOT CAMPUS';
COMMIT;

ALTER TABLE ALLIED.STU_FEE ADD (arrear  NUMBER);

v stu_fee_view

