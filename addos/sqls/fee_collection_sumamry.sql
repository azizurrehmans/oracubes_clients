select f.STUDENT_ID,f.OLD_STUDENT_ID, f.CLASS,f.SECTION, f.FIRST_NAME,f.FATHER_NAME, f.CHALLAN_NO, f.CHALLAN_TYPE, f.AMOUNT, f.ARREARS,  f.FEE_MONTH,   f.REC_BANK_DATE "Receive Date",  f.STATUS_ID, '*'||f.CHALLAN_NO||'*' barcode
from stu_fee_view f;


create or replace view stu_fee_colletion_over_view
as
select 1 typ, 'All' Month, 'Total Defaulters' description, 'All' "Challan Type", count(*) total, sum(amount) amount from stu_fee_view f where f.REC_BANK_DATE is null
union
select 2, f.FEE_MONTH , 'Monthly Defalters'          , null, count(*), sum(amount) from stu_fee_view f where f.REC_BANK_DATE is null group by fee_month
union
select 3, f.FEE_MONTH , challan_type                 , null, count(*), sum(amount) from stu_fee_view f where f.REC_BANK_DATE is null group by fee_month, challan_type
union
select 4, f.fee_month, 'Collection', 'All', nvl(counter,0), nvl(amount,0) from (select f.fee_month from stu_fee f group by f.fee_month) f,
                        (select f.FEE_MONTH , 'Monthly Collection' , null, count(*) counter, sum(amount) amount from stu_fee_view f where f.REC_BANK_DATE is not null group by fee_month) fr
where  f.fee_month = fr.fee_month(+)                       ;
