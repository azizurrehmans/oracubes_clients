drop table inv_ir_deleted;
create table inv_ir_deleted as select * from inv_ir;
delete from inv_ir_deleted;