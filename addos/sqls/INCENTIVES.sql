select * from exp_bank_pi;
alter table exp_bank_pi add (pi_no_old number);
alter table exp_bank_pi modify( pi_no number null);
update exp_bank_pi set pi_no_old = pi_no;
alter table exp_bank_pi modify( pi_no varchar2(100));
update exp_bank_pi set pi_no = null;
alter table exp_bank_pi modify (pi_no varchar2(100));
update exp_bank_pi set pi_no = pi_no_old;
commit;

SELECT BANK_ID, ACCOUNT_NO, ACCOUNT_TYPE, COA_SEQ FROM AC_BANK_ACCOUNT;


--------------------------------------------------------
--  DDL for Table HR_SAL_ADV_CONT
--------------------------------------------------------
  DROP TABLE HR_SAL_CONT_INCENTIVE;
  CREATE TABLE "HR_SAL_CONT_INCENTIVE" 
   (	"AMOUNT" NUMBER(10,0) NOT NULL, 
		"EMPLOYEE_ID" NUMBER(6,0) NOT NULL, 
        STATUS_ID VARCHAR2(10) NOT NULL,
		"SAL_CONT_ID" DATE, 
        INCENTIVE_TYPE VARCHAR2(10),
	"USER_ID" VARCHAR2(20 BYTE), 
	"FDATETIME" DATE, 
	"REASON" VARCHAR2(100 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Index SAL_CONT_ADV_PK
--------------------------------------------------------

    ALTER TABLE "HR_SAL_CONT_INCENTIVE" ADD CONSTRAINT "SALCONT_INCENTIVE_STS_CHK" CHECK (status_id in ('HOLD','RELEASE')) ENABLE;
 
--------------------------------------------------------
--  Ref Constraints for Table HR_SAL_ADV_CONT
--------------------------------------------------------

  ALTER TABLE "ADDOS"."HR_SAL_CONT_INCENTIVE" ADD CONSTRAINT "SALCONT_INCENTIVE_EMP_FK" FOREIGN KEY ("EMPLOYEE_ID")
	  REFERENCES "ADDOS"."HR_EMPLOYEE" ("EMPLOYEE_ID") ENABLE;
 
  ALTER TABLE "ADDOS"."HR_SAL_CONT_INCENTIVE" ADD CONSTRAINT "SALCONT_INCENTIVE_USER_FK" FOREIGN KEY ("USER_ID")
	  REFERENCES "ADDOS"."ADM_USERS" ("USER_ID") ENABLE;
