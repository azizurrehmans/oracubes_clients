ALTER TABLE GILLANI.EXP_PACKING  ADD (payment_terms  VARCHAR2(100));
ALTER TABLE GILLANI.EXP_PACKING  ADD (delivery_terms  VARCHAR2(100));
ALTER TABLE GILLANI.EXP_PACKING_DETAIL ADD (cbm  VARCHAR2(50));
ALTER TABLE GILLANI.EXP_PACKING  ADD (tot_gross_wt  NUMBER);

