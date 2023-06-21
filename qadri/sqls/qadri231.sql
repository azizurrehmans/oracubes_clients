drop table coa_opening23;
create table coa_opening23
as
select coa_seq, qadri1.ac_coa_closing_dt(coa_seq, '30-jun-2022') dr_amount, qadri1.ac_coa_closing_dt(coa_seq, '30-jun-2022') cr_amount, 'aziz' user_id, sysdate fdatetime
from ac_coa;

drop table ac_coa_opening;
create table ac_coa_opening as select * from coa_opening23;

select * from ac_coa_opening;
update ac_coa_opening set dr_amount = 0 where dr_amount < 0;
update ac_coa_opening set cr_amount = 0 where cr_amount > 0;
update ac_coa_opening set cr_amount = abs(cr_amount) where cr_amount < 0;


ALTER TABLE QADRI23.AC_COA_OPENING
MODIFY(DR_AMOUNT  NOT NULL);


ALTER TABLE QADRI23.AC_COA_OPENING
MODIFY(CR_AMOUNT  NOT NULL);


ALTER TABLE QADRI23.AC_COA_OPENING
MODIFY(USER_ID  NOT NULL);


ALTER TABLE QADRI23.AC_COA_OPENING
MODIFY(FDATETIME  NOT NULL);


ALTER TABLE QADRI23.AC_COA_OPENING
 ADD CONSTRAINT AC_COA_OPENING_PK
 PRIMARY KEY
 (COA_SEQ);

CREATE OR REPLACE FUNCTION QADRI23."AC_COA_OPENING_DT" (m NUMBER, d DATE)
   RETURN NUMBER
IS
   x   NUMBER;
   z   NUMBER;
   y   VARCHAR2 (5);
   o   NUMBER;
BEGIN
   

   ----
   SELECT COUNT (*)
     INTO x
     FROM AC_coa_opening
    WHERE coa_seq = m;--- AND year_id = y;

   IF (x > 0)
   THEN
      SELECT NVL (dr_amount, 0) - NVL (cr_amount, 0)
        INTO x
        FROM AC_coa_opening
       WHERE coa_seq = m;-- AND year_id = y;
   END IF;

   ----
   SELECT SUM (vd.dr_amount) - SUM (vd.cr_amount)
     INTO z
     FROM AC_voucher v, AC_voucher_detail vd
    WHERE v.voucher_seq = vd.voucher_seq
      AND vd.coa_seq = m
      AND v.voucher_date < d
      ---AND fisical_year (v.voucher_date) = y
      AND v.status_id = 'RELEASE';

   ----
   o := x + NVL (z, 0);
   RETURN NVL (o, 0);
END;

delete from ac_voucher_detail;

delete from inv_trans;
delete from inv_ir_detail;
delete from inv_ir;
select count(*) from QADRI1.inv_ir where status_id = 'UN-POSTED';
INSERT INTO INV_IR SELECT * from QADRI1.inv_ir where status_id = 'UN-POSTED';
INSERT INTO INV_IR_DETAIL SELECT * FROM QADRI1.INV_IR_DETAIL WHERE IR_ID IN (SELECT IR_ID FROM QADRI1.INV_IR WHERE STATUS_ID = 'UN-POSTED');


delete from inv_igp_detail where igp_id in (select igp_id from inv_igp where status_id = 'POSTED')   ;
delete from inv_igp inv_igp where status_id = 'POSTED';

delete from inv_pr_detail;
delete from inv_pr;


delete from inv_btn;

delete from ac_voucher;

delete from inv_sc where status_id = 'HOLD';

drop table inv_sc_opening23;

create table inv_sc_opening23 as 
  select sc_id, qadri1.inv_opening_qty_date(sc_id, sysdate,'OK') oqty, qadri1.inv_opening_value_date(sc_id, sysdate,'OK') ovalue, 'aziz' user_id, 'OK' item_status from qadri1.inv_sc;

alter table inv_sc_opening23 modify (item_status varchar2(10) );
  
insert into inv_sc_opening23  
  select sc_id, inv_opening_qty_date(sc_id, '30-jun-2022','FAULTY') oqty, inv_opening_value_date(sc_id, '30-jun-2022','FAULTY') ovalue, 'aziz' user_id, 'FAULTY' item_status 
  from qadri1.inv_sc;
insert into inv_sc_opening23  
  select sc_id, inv_opening_qty_date(sc_id, '30-jun-2022','DAMAGE') oqty, inv_opening_value_date(sc_id, '30-jun-2022','DAMAGE') ovalue, 'aziz' user_id, 'DAMAGE' item_status 
  from qadri1.inv_sc;
  
rename inv_sc_opening to inv_sc_opening_old;
rename inv_sc_opening23 to inv_sc_opening;
alter table inv_sc_opening add (orate number);
update inv_sc_opening set orate = ovalue / oqty where ovalue > 0 and oqty > 0;

ALTER TABLE QADRI23.INV_SC_OPENING
MODIFY(OQTY  NOT NULL);

ALTER TABLE QADRI23.INV_SC_OPENING
MODIFY(OQTY  DEFAULT 0);

ALTER TABLE QADRI23.INV_SC_OPENING
MODIFY(OVALUE  NOT NULL);

ALTER TABLE QADRI23.INV_SC_OPENING
MODIFY(OVALUE  DEFAULT 0);

ALTER TABLE QADRI23.INV_SC_OPENING
MODIFY(USER_ID  NOT NULL);


ALTER TABLE QADRI23.INV_SC_OPENING
MODIFY(ITEM_STATUS  NOT NULL);


ALTER TABLE QADRI23.INV_SC_OPENING
 ADD CONSTRAINT INV_SC_OPENING_PK23
 PRIMARY KEY
 (SC_ID,ITEM_STATUS);
 
-------------------
CREATE OR REPLACE FUNCTION QADRI23.inv_trx_avg_rate (s NUMBER, seq NUMBER)
   RETURN NUMBER
IS
   tmpvar   NUMBER;
/******************************************************************************
   NAME:       INV_TRX_AVG_RATE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/12/2017          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     INV_TRX_AVG_RATE
      Sysdate:         6/12/2017
      Date and Time:   6/12/2017, 6:44:03 PM, and 6/12/2017 6:44:03 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
   iq       NUMBER        := 0;
   iv       NUMBER        := 0;
   rq       NUMBER        := 0;
   rv       NUMBER        := 0;
   fy       VARCHAR2 (5);
   oq       NUMBER        := 0;
   ov       NUMBER        := 0;
   v        NUMBER        := 0;
   q        NUMBER        := 0;
   tt       VARCHAR2 (10);
   x        NUMBER        := 0;
BEGIN
   ---fy := ac_fisical_year (SYSDATE);

   SELECT COUNT (*)
     INTO x
     FROM inv_sc_opening
    WHERE sc_id = s ---AND oyear = fy 
    and item_status = 'OK';

   IF (x > 0)
   THEN
      SELECT oqty, oqty * orate
        INTO oq, ov
        FROM inv_sc_opening
       WHERE sc_id = s ---AND oyear = fy 
       and item_status = 'OK';
   END IF;

   --return 1;
   SELECT COUNT (*)
     INTO x
     FROM inv_trans
    WHERE trans_id = seq;

   IF (x > 0)
   THEN
      SELECT trans_type
        INTO tt
        FROM inv_trans
       WHERE trans_id = seq;

      --RETURN 2;
      IF (tt = 'IR')
      THEN
         SELECT NVL (SUM (rec_qty), 0), NVL (SUM (rec_value), 0),
                NVL (SUM (issue_qty), 0), NVL (SUM (issue_value), 0)
           INTO rq, rv,
                iq, iv
           FROM inv_trans
          WHERE sc_id = s AND trans_id < seq;
      ELSIF (tt = 'GIR')
      THEN
         SELECT NVL (SUM (rec_qty), 0), NVL (SUM (rec_value), 0),
                NVL (SUM (issue_qty), 0), NVL (SUM (issue_value), 0)
           INTO rq, rv,
                iq, iv
           FROM inv_trans
          WHERE sc_id = s AND trans_id <= seq;
      END IF;
   END IF;

   --RETURN 3;
   v := (NVL (ov, 0) + NVL (rv, 0) - NVL (iv, 0));
                                                 -- / (nvl(RQ,0) - nvl(IQ,0));
   --RETURN 4;
   q := (NVL (oq, 0) + NVL (rq, 0) - NVL (iq, 0));

   --return Q;
   --tmpVar := 0;
   IF (v = 0 OR q = 0)
   THEN
      RETURN 0;
   END IF;

   RETURN v / q;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE;
END inv_trx_avg_rate; 

drop SEQUENCE INV_BTN_SEQ; 
drop SEQUENCE INV_IGP_DETAIL_SEQ;
drop SEQUENCE INV_IGP_SEQ;
drop SEQUENCE INV_IR_DETAIL_SEQ;
drop SEQUENCE INV_IR_SEQ;
drop SEQUENCE INV_IR_YEARLY_SEQ;
drop SEQUENCE INV_PR_DETAIL_SEQ;
drop SEQUENCE INV_PR_SEQ;
drop SEQUENCE INV_PR1_DETAIL_SEQ;
drop SEQUENCE TRANS_SEQ;
drop SEQUENCE VOUCHER_SEQ;

CREATE SEQUENCE INV_BTN_SEQ; 
CREATE SEQUENCE INV_IGP_DETAIL_SEQ;
CREATE SEQUENCE INV_IGP_SEQ;
CREATE SEQUENCE INV_IR_DETAIL_SEQ;
CREATE SEQUENCE INV_IR_SEQ;
CREATE SEQUENCE INV_IR_YEARLY_SEQ;
CREATE SEQUENCE INV_PR_DETAIL_SEQ;
CREATE SEQUENCE INV_PR_SEQ;
CREATE SEQUENCE INV_PR1_DETAIL_SEQ;
CREATE SEQUENCE TRANS_SEQ;
CREATE SEQUENCE VOUCHER_SEQ;


CREATE OR REPLACE FUNCTION QADRI23."INV_OPENING_QTY_DATE" (s NUMBER, d DATE, sts varchar2)
   RETURN NUMBER
IS
   o    NUMBER;
   t    NUMBER;
   x    NUMBER;
   iq   NUMBER;
   oq   NUMBER;
   ---yr   VARCHAR2 (5) := fisical_year (d);
BEGIN
   x := 0;
   o := 0;
   iq := 0;
   oq := 0;
   
   SELECT COUNT (*)
     INTO x
     FROM inv_sc_opening
    WHERE sc_id = s ---AND oyear = yr 
    and item_status = sts;

   IF (x > 0)
   THEN
      SELECT NVL (SUM(oqty), 0)
        INTO o
        FROM inv_sc_opening
       WHERE sc_id = s ---AND oyear = yr 
       and item_status = sts;
   ELSE
      o := 0;
   END IF;

   SELECT COUNT (*)
     INTO x
     FROM inv_trans
    WHERE sc_id = s
         --- AND fisical_year (trans_date) = yr 
          AND trans_date < d 
          and item_status = sts;

   IF (x > 0)
   THEN
      SELECT SUM (NVL (rec_qty, 0)) - SUM (NVL (issue_qty, 0))
        INTO iq
        FROM inv_trans
       WHERE sc_id = s
           ---  AND fisical_year (trans_date) = yr 
             AND trans_date < d 
             and item_status = sts;
   ELSE
      iq := 0;
   END IF;

   oq := NVL (o, 0) + NVL (iq, 0);
   RETURN oq;
END;
------
CREATE OR REPLACE FUNCTION QADRI23.inv_sc_avg_rate (s NUMBER, d DATE)
   RETURN NUMBER
IS
   tmpvar   NUMBER;
/******************************************************************************
   NAME:       INV_TRX_AVG_RATE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/12/2017          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     INV_TRX_AVG_RATE
      Sysdate:         6/12/2017
      Date and Time:   6/12/2017, 6:44:03 PM, and 6/12/2017 6:44:03 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
   iq       NUMBER;
   iv       NUMBER;
   rq       NUMBER;
   rv       NUMBER;
   fy       VARCHAR2 (5);
   oq       NUMBER;
   ov       NUMBER;
   v        NUMBER;
   q        NUMBER;
   tt       VARCHAR2 (10);
   x        NUMBER;
BEGIN
   ---fy := ac_fisical_year (d);

   SELECT COUNT (*)
     INTO x
     FROM inv_sc_opening
    WHERE sc_id = s ---AND oyear = fy 
    and item_status = 'OK';

   IF (x > 0)
   THEN
      SELECT oqty, oqty * orate
        INTO oq, ov
        FROM inv_sc_opening
       WHERE sc_id = s ---AND oyear = fy 
       and item_status = 'OK';
   END IF;

 --  return ov;
   SELECT NVL (SUM (rec_qty), 0), NVL (SUM (rec_value), 0),
          NVL (SUM (issue_qty), 0), NVL (SUM (issue_value), 0)
     INTO rq, rv,
          iq, iv
     FROM inv_trans
    WHERE sc_id = s AND trans_date < d  and item_status = 'OK';--- and ac_fisical_year(trans_date) = fy;

   --RETURN 3;
   v := (NVL (ov, 0) + NVL (rv, 0) - NVL (iv, 0));
                                                 -- / (nvl(RQ,0) - nvl(IQ,0));
   --RETURN 4;
   q := (NVL (oq, 0) + NVL (rq, 0) - NVL (iq, 0));

   --return Q;
   --tmpVar := 0;
   IF (v = 0 OR q = 0)
   THEN
      RETURN 0;
   END IF;

   RETURN v / q;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE;
END inv_sc_avg_rate;
-----------------------------
create or replace view sc_view
as
SELECT s.profitable, s.consumeable, coa_seq, coa, s.sc_id, l1, l2, l3, l4,
          l5, LEVELS, description, SPECIFICATION, uom_id, uom_id unit_id,
          rate, r.hrate, s.status_id,
          inv_opening_qty_date (s.sc_id, SYSDATE, 'OK') ok_balance,
          inv_opening_qty_date (s.sc_id, SYSDATE, 'DAMAGE') damage_balance,
          inv_opening_qty_date (s.sc_id, SYSDATE, 'FAULTY') faulty_balance,
          inv_opening_qty_date (s.sc_id, SYSDATE, 'OK') balance,
          ROUND (inv_sc_avg_rate (s.sc_id, SYSDATE)) avg_rate,
          ROUND (inv_last_purchase_rate (s.sc_id, SYSDATE))
                                                           last_purchase_rate,
          LEVELS || ' ' || description || ' '
          || SPECIFICATION item_description,
          LEVELS || ' ' || description || ' ' || SPECIFICATION sc_desc,
          r.sc_id sc_code
     FROM (SELECT sc_id, l1, l2, l3, l4, l5, sc.status_id, profitable,
                  consumeable,
                  CASE
                     WHEN l1 IS NOT NULL
                     AND l2 IS NULL
                     AND l3 IS NULL
                     AND l4 IS NULL
                     AND l5 IS NULL
                        THEN l1
                     WHEN l1 IS NOT NULL
                     AND l2 IS NOT NULL
                     AND l3 IS NULL
                     AND l4 IS NULL
                     AND l5 IS NULL
                        THEN l1 || '-' || l2
                     WHEN l1 IS NOT NULL
                     AND l2 IS NOT NULL
                     AND l3 IS NOT NULL
                     AND l4 IS NULL
                     AND l5 IS NULL
                        THEN l1 || '-' || l2 || '-' || l3
                     WHEN l1 IS NOT NULL
                     AND l2 IS NOT NULL
                     AND l3 IS NOT NULL
                     AND l4 IS NOT NULL
                     AND l5 IS NULL
                        THEN l1 || '-' || l2 || '-' || l3 || '-' || l4
                     WHEN l1 IS NOT NULL
                     AND l2 IS NOT NULL
                     AND l3 IS NOT NULL
                     AND l4 IS NOT NULL
                     AND l5 IS NOT NULL
                        THEN l1 || '-' || l2 || '-' || l3 || '-' || l4 || '-'
                             || l5
                  END LEVELS,
                  sc.description, SPECIFICATION, uom_id, sc.coa_seq, coa
             FROM inv_sc sc, ac_coa_view c
            WHERE sc.coa_seq = c.coa_seq(+)) s,
          inv_latest_sc_retail_rate_view r
    WHERE s.sc_id = r.sc_id(+);
------------
create or replace view inv_igp_view
as
SELECT i.igp_yearly_id || '/' || i.igp_year igp, gst, s.currency,
          i.igp_yearly_id, i.bill_date, i.voucher_seq, i.payment_mode,
          NVL (igd.amount, 0) + NVL (ige.amount, 0) total_amount,
          supp_qty - reject_qty - short_qty accepted_qty,
          NVL (igd.amount, 0) amount, 
          NVL (ige.amount, 0) expense_amount,
          i.bill_no, i.fdatetime, i.igp_date, i.igp_id, i.igp_type,
          i.igp_year, i.payment_status, i.remarks, i.status_id, i.supplier_id,
          s.description supplier, i.taken_in_by, i.taken_in_datetime,
          i.user_id, i.vehicle_no, i.vehicle_type
     FROM qadri23.inv_igp i,
          ac_coa s ,
          (SELECT   SUM (supp_qty) supp_qty,
                    SUM (reject_qty) reject_qty, SUM (short_qty) short_qty,
                    sum( NVL (rate, 0) * DECODE (rate, NULL, supp_qty, supp_qty - short_qty - reject_qty )) amount,
                    igp_id
               FROM inv_igp_detail
           GROUP BY igp_id) igd ,
          (SELECT   SUM (amount) amount, igp_id
               FROM inv_igp_expense
           GROUP BY igp_id) ige
    WHERE i.supplier_id = s.coa_seq(+) 
      AND i.igp_id = igd.igp_id(+)
          AND i.igp_id = ige.igp_id(+) ;
------------------
cREATE OR REPLACE FORCE VIEW qadri23.inv_igp_view (igp,
                                                   gst,
                                                   currency,
                                                   igp_yearly_id,
                                                   bill_date,
                                                   voucher_seq,
                                                   payment_mode,
                                                   total_amount,
                                                   accepted_qty,
                                                   amount,
                                                   expense_amount,
                                                   bill_no,
                                                   fdatetime,
                                                   igp_date,
                                                   igp_id,
                                                   igp_type,
                                                   igp_year,
                                                   payment_status,
                                                   remarks,
                                                   status_id,
                                                   supplier_id,
                                                   supplier,
                                                   taken_in_by,
                                                   taken_in_datetime,
                                                   user_id,
                                                   vehicle_no,
                                                   vehicle_type
                                                  )
AS
   SELECT i.igp_yearly_id || '/' || i.igp_year igp, gst, s.currency,
          i.igp_yearly_id, i.bill_date, i.voucher_seq, i.payment_mode,
          NVL (igd.amount, 0) + NVL (ige.amount, 0) total_amount,
          supp_qty - reject_qty - short_qty accepted_qty,
          NVL (igd.amount, 0) amount, NVL (ige.amount, 0) expense_amount,
          i.bill_no, i.fdatetime, i.igp_date, i.igp_id, i.igp_type,
          i.igp_year, i.payment_status, i.remarks, i.status_id, i.supplier_id,
          s.description supplier, i.taken_in_by, i.taken_in_datetime,
          i.user_id, i.vehicle_no, i.vehicle_type
     FROM qadri23.inv_igp i,
          ac_coa s,
          (SELECT   SUM (supp_qty) supp_qty, SUM (reject_qty) reject_qty,
                    SUM (short_qty) short_qty,
                    SUM (  NVL (rate, 0)
                         * DECODE (rate,
                                   NULL, supp_qty,
                                   supp_qty - short_qty - reject_qty
                                  )
                        ) amount,
                    igp_id
               FROM inv_igp_detail
           GROUP BY igp_id) igd,
          (SELECT   SUM (amount) amount, igp_id
               FROM inv_igp_expense
           GROUP BY igp_id) ige
    WHERE i.supplier_id = s.coa_seq(+) AND i.igp_id = igd.igp_id(+)
          AND i.igp_id = ige.igp_id(+);
          ----------------------
CREATE OR REPLACE FUNCTION QADRI23."INV_LAST_PURCHASE_RATE" (s NUMBER, d DATE)
   RETURN NUMBER
IS
   o     NUMBER;
   q     NUMBER;
   t     NUMBER;
   x     NUMBER;
   iq    NUMBER;
   oq    NUMBER;
   ov    NUMBER;
   v     NUMBER;
   yr    VARCHAR2 (5) := fisical_year (d);
   mtx   NUMBER;
   mdt   date;
BEGIN
   x := 0;
   o := 0;
   q := 0;
   iq := 0;
   oq := 0;
   ov := 0;

   SELECT COUNT (*)
     INTO x
     FROM inv_sc_opening
    WHERE sc_id = s ---AND oyear = yr 
    and item_status = 'OK';

   IF (x > 0)
   THEN
      SELECT NVL (orate, 0), NVL (oqty, 0)
        INTO o, q
        FROM inv_sc_opening
       WHERE sc_id = s ---AND oyear = yr 
       and item_status = 'OK';

      ov := o;
   ELSE
      o := 0;
      ov := 0;
   END IF;
   ---return ov;
    
   SELECT COUNT (*)
     INTO x
     FROM inv_trans
    WHERE sc_id = s
      AND trans_type = 'IGP'
      --AND fisical_year (trans_date) = yr
      AND trans_date < d;

   IF (x > 0)
   THEN
   
      SELECT MAX (trans_date)
        INTO mdt
        FROM inv_trans
       WHERE sc_id = s
         AND trans_type = 'IGP'
         --AND fisical_year (trans_date) = yr
         AND trans_date < d;
            
      SELECT MAX (trans_id)
        INTO mtx
        FROM inv_trans
       WHERE sc_id = s
         AND trans_type = 'IGP'
         --AND fisical_year (trans_date) = yr
         AND trans_date = mdt;

      SELECT NVL (rec_value, 0), NVL (rec_qty, 0)
        INTO v, q
        FROM inv_trans
       WHERE trans_id = mtx;

      IF (v <= 0)
      THEN
         RETURN 0;
      END IF;

      RETURN v / q;
   ELSE
      iq := 0;
   END IF;

   IF (iq = 0)
   THEN
      oq := NVL (ov, 0);
   END IF;

   RETURN oq;
END;
----------------------

  
select * from inv_sc_opening23;




select * from inv_sc;

select count(*) from ac_voucher;
select  count(*) from inv_trans;
select count(*) from qadri1.inv_trans;
select btn_id, btn_date from inv_btn where btn_id in (select btn_id from inv_trans where trans_date <= '30-jun-2021' and trans_type='BTN');
select pr_id, pr_date from inv_pr where pr_id in (select pr_id from inv_trans where trunc(trans_date) <= '30-jun-2021' and trans_type='PR');
select trans_type, pr_id, trans_date from inv_trans where trans_type = 'PR' and trans_date <= '30-jun-2021';