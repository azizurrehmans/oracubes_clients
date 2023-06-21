delete from ac_voucher_detail where voucher_seq in (select voucher_seq from ac_voucher where voucher_date < '30-JUN-2021');
delete from ac_voucher where voucher_date < '30-JUN-2021';
delete from inv_trans where trans_date <= '30-jun-2021'; 
delete from inv_ir_detail where ir_id in (select ir_id from inv_ir where ir_date <='30-jun-2021');
delete from inv_ir where ir_date <='30-jun-2021';
delete from inv_igp_detail where igp_id in (select igp_id from inv_igp where igp_date <= '30-jun-2021');
delete from inv_igp_expense where igp_id in (select igp_id from inv_igp where igp_date <= '30-jun-2021');
delete from inv_igp where igp_date <= '20-jun-2021'; 
delete from inv_sc_opening where oyear <> '21-22';
alter table inv_sc_opening drop constraint inv_sc_opening_pk;
alter table inv_sc_opening modify (oyear varchar2(5) null);
update inv_sc_opening set oyear=null;
alter table inv_sc_opening drop column oyear;   
-----
create or replace FUNCTION "INV_OPENING_QTY_DATE" (s NUMBER, d DATE, sts varchar2)
   RETURN NUMBER
IS
   o    NUMBER;
   t    NUMBER;
   x    NUMBER;
   iq   NUMBER;
   oq   NUMBER;
   yr   VARCHAR2 (5) := fisical_year (d);
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
          ---AND fisical_year (trans_date) = yr 
          AND trans_date < d 
          and item_status = sts;

   IF (x > 0)
   THEN
      SELECT SUM (NVL (rec_qty, 0)) - SUM (NVL (issue_qty, 0))
        INTO iq
        FROM inv_trans
       WHERE sc_id = s
             ---AND fisical_year (trans_date) = yr 
             AND trans_date < d 
             and item_status = sts;
   ELSE
      iq := 0;
   END IF;

   oq := NVL (o, 0) + NVL (iq, 0);
   RETURN oq;
END;
-------------
create or replace FUNCTION "INV_OPENING_VALUE_DATE" 
(
   s     NUMBER,
   d     DATE,
   sts   VARCHAR2
)
   RETURN NUMBER
IS
   o    NUMBER;
   q    NUMBER;
   t    NUMBER;
   x    NUMBER;
   iq   NUMBER;
   oq   NUMBER;
   ov   NUMBER;
   yr   VARCHAR2 (5) := fisical_year (d);
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
    AND item_status = sts;

   IF (x > 0)
   THEN
      SELECT NVL (orate, 0), NVL (oqty, 0)
        INTO o, q
        FROM inv_sc_opening
       WHERE sc_id = s 
       ---AND oyear = yr 
       AND item_status = sts;

      ov := o * q;
   ELSE
      o := 0;
      ov := 0;
   END IF;

   SELECT COUNT (*)
     INTO x
     FROM inv_trans
    WHERE sc_id = s
      ----and trans_date > '31-MAR-2006'
      ---AND fisical_year (trans_date) = yr
      AND trans_date < d
      AND item_status = sts;

   IF (x > 0)
   THEN
      SELECT SUM (NVL (rec_value, 0)) - SUM (NVL (issue_value, 0))
        INTO iq
        FROM inv_trans
       WHERE sc_id = s
         ----and trans_date > '31-MAR-2006'
         ----AND fisical_year (trans_date) = yr
         AND trans_date < d
         AND item_status = sts;
   ELSE
      iq := 0;
   END IF;

   oq := NVL (ov, 0) + NVL (iq, 0);
   RETURN oq;
END;
-------------
CREATE OR REPLACE FUNCTION QADRI1."INV_LAST_PURCHASE_RATE" (s NUMBER, d DATE)
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
       WHERE sc_id = s 
       ---AND oyear = yr 
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
      ---AND fisical_year (trans_date) = yr
      AND trans_date < d;

   IF (x > 0)
   THEN
   
      SELECT MAX (trans_date)
        INTO mdt
        FROM inv_trans
       WHERE sc_id = s
         AND trans_type = 'IGP'
         ---AND fisical_year (trans_date) = yr
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
--------------------- 
CREATE OR REPLACE FUNCTION QADRI1.inv_sc_avg_rate (s NUMBER, d DATE)
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
   fy := ac_fisical_year (d);

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
       WHERE sc_id = s --AND oyear = fy 
       and item_status = 'OK';
   END IF;

 --  return ov;
   SELECT NVL (SUM (rec_qty), 0), NVL (SUM (rec_value), 0),
          NVL (SUM (issue_qty), 0), NVL (SUM (issue_value), 0)
     INTO rq, rv,
          iq, iv
     FROM inv_trans
    WHERE sc_id = s AND trans_date < d  and item_status = 'OK';-- and ac_fisical_year(trans_date) = fy;

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
-----------------
CREATE OR REPLACE FUNCTION QADRI1.inv_trx_avg_rate (s NUMBER, seq NUMBER)
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
   fy := ac_fisical_year (SYSDATE);

   SELECT COUNT (*)
     INTO x
     FROM inv_sc_opening
    WHERE sc_id = s ---AND ----oyear = fy 
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

----
