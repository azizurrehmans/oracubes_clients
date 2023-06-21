CREATE SEQUENCE INV_IGP_DETAIL_SEQ;
CREATE SEQUENCE INV_IGP_SEQ;
CREATE SEQUENCE INV_IR_SEQ;
CREATE SEQUENCE INV_IR_DETAIL_SEQ;
CREATE SEQUENCE INV_IR_YEARLY_SEQ;
CREATE SEQUENCE INV_BTN_SEQ;
CREATE SEQUENCE INV_PR_SEQ;
CREATE SEQUENCE INV_PR_DETAIL_SEQ;
CREATE SEQUENCE INV_PR1_SEQ;
ALTER TABLE INV_IR ADD(INCENTIVE NUMBER);
ALTER TABLE INV_IR ADD(RATE_BF_DISCOUNT NUMBER);
UPDATE "HABIB"."AC_YEAR" SET YEAR_ID = '22-23', START_PERIOD = TO_DATE('2022-07-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), END_PERIOD = TO_DATE('2023-06-30 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), YEAR_DESC = '2022-2023' WHERE ROWID = 'AAATf4AAEAAAsBjAAA' AND ORA_ROWSCN = '2091271'
-----
create or replace FUNCTION       "INV_OPENING_QTY_DATE" (s NUMBER, d DATE, sts varchar2)
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
    WHERE sc_id = s and item_status = sts;

   IF (x > 0)
   THEN
      SELECT NVL (oqty, 0)
        INTO o
        FROM inv_sc_opening
       WHERE sc_id = s AND item_status = sts;
   ELSE
      o := 0;
   END IF;

   SELECT COUNT (*)
     INTO x
     FROM inv_trans
    WHERE sc_id = s
                   ----and trans_date > '31-MAR-2006'
          AND  trans_date < d and item_status = sts;

   IF (x > 0)
   THEN
      SELECT SUM (NVL (rec_qty, 0)) - SUM (NVL (issue_qty, 0))
        INTO iq
        FROM inv_trans
       WHERE sc_id = s
                      ----and trans_date > '31-MAR-2006'
             AND trans_date < d and item_status = sts;
   ELSE
      iq := 0;
   END IF;

   oq := NVL (o, 0) + NVL (iq, 0);
   RETURN oq;
END; 