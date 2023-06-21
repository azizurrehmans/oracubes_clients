CREATE OR REPLACE VIEW ASKARI.SC_DESC
(DESCRIPTION, MAIN_DESC, SUB_DESC, CTRL_DESC, SC_MAIN_ID, 
 SC_SUB_ID, SC_ID, UNIT_ID, STATUS_ID)
AS 
SELECT    m.description
          || '-'
          || s.description
          || '-'
          || c.description description,
          m.description main_desc,
          s.description sub_desc,
          c.description ctrl_desc,
          c.sc_main_id, c.sc_sub_id, c.sc_id, c.unit_id, c.status_id
     FROM sc_main m, sc_sub s, sc c
    WHERE c.sc_main_id = m.sc_main_id
      AND c.sc_main_id = s.sc_main_id
      AND c.sc_sub_id = s.sc_sub_id;

