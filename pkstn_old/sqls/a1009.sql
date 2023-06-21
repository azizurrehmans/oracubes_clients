ALTER TABLE INV_SC ADD (opening_qty  NUMBER);
ALTER TABLE INV_SC ADD (opening_rate  NUMBER);
ALTER TABLE ADDOS.INV_SC_OPENING DROP COLUMN OYEAR;

ALTER TABLE ADDOS.INV_STORE_RACK_ROW_COL  DROP PRIMARY KEY CASCADE;

ALTER TABLE ADDOS.INV_STORE_RACK_ROW_COL ADD CONSTRAINT INV_STORE_RACK_ROW_COL_PK1  PRIMARY KEY  (STORE_ID, RACK_ID, ROW_ID, COL_ID);


----
ALTER TABLE ADDOS.INV_L4 dROP PRIMARY KEY CASCADE;
DROP TABLE ADDOS.INV_L4 CASCADE CONSTRAINTS;

CREATE TABLE ADDOS.INV_L4
(
  L1_ID   VARCHAR2(50 BYTE),
  L2_ID   VARCHAR2(50 BYTE),
  L3_ID   VARCHAR2(50 BYTE),
  L4_ID   VARCHAR2(50 BYTE)
)
TABLESPACE ORACUBES
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          320K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX ADDOS.INV_L4_PK ON ADDOS.INV_L4
(L1_ID, L2_ID, L3_ID, L4_ID)
LOGGING
TABLESPACE ORACUBES
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          384K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE ADDOS.INV_L4 ADD (
  CONSTRAINT INV_L4_PK
 PRIMARY KEY
 (L1_ID, L2_ID, L3_ID, L4_ID)
    USING INDEX 
    TABLESPACE ORACUBES
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          384K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));
------------------------------------------------
CREATE OR REPLACE FUNCTION ADDOS."INV_OPENING_QTY_DATE" (s NUMBER, d DATE, sts varchar2)
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
       WHERE sc_id = s and item_status = sts;
   ELSE
      o := 0;
   END IF;

   SELECT COUNT (*)
     INTO x
     FROM inv_trans
    WHERE sc_id = s
                   ----and trans_date > '31-MAR-2006'
          AND trans_date < d and item_status = sts;

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
-----------------------------------------
CREATE OR REPLACE FUNCTION ADDOS."INV_CLOSING_QTY_DATE" (s NUMBER, d DATE, sts varchar2)
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
       WHERE sc_id = s and item_status = sts;
   ELSE
      o := 0;
   END IF;

   SELECT COUNT (*)
     INTO x
     FROM inv_trans
    WHERE sc_id = s
                   ----and trans_date > '31-MAR-2006'
          AND trunc(trans_date) <= d and item_status = sts;

   IF (x > 0)
   THEN
      SELECT SUM (NVL (rec_qty, 0)) - SUM (NVL (issue_qty, 0))
        INTO iq
        FROM inv_trans
       WHERE sc_id = s
                      ----and trans_date > '31-MAR-2006'
             AND trunc(trans_date) <= d and item_status = sts;
   ELSE
      iq := 0;
   END IF;

   oq := NVL (o, 0) + NVL (iq, 0);
   RETURN oq;
END;
