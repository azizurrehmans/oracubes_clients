DROP TABLE INV_IR_DELETED;
DROP TABLE INV_IR_DETAIL_DELETED;
CREATE TABLE INV_IR_DELETED AS SELECT * FROM INV_IR;
CREATE TABLE INV_IR_DETAIL_DELETED AS SELECT * FROM INV_IR_DETAIL;
DELETE FROM INV_IR_DELETED;
DELETE FROM INV_IR_DETAIL_DELETED;
DELETE FROM INV_IR_DETAIL;
DELETE FROM INV_IR;
DELETE FROM INV_IGP_DETAIL;
DELETE FROM INV_IGP;
DELETE FROM INV_SC;
