update po po set sup_coa_seq = (select coa_seq from supplier where supplier_id = po.supplier_id)
where sup_coa_seq is null; 

select po.supplier_id, po.po_date, po.sup_coa_seq, supplier.coa_seq, supplier.description from po , supplier
where po.supplier_id = supplier.SUPPLIER_ID
and  po.sup_coa_seq is null
order by po.supplier_id;

SELECT SUPPLIER_id, sup_coa_seq from po where sup_coa_seq is null;

select supplier_id, description, status_id, coa_seq from supplier where coa_seq is null;

UPDATE SUPPLIER SET COA_SEQ = 685 WHERE COA_SEQ IS NULL;
ALTER TABLE SUPPLIER MODIFY(COA_SEQ  NOT NULL);


ALTER TABLE PO MODIFY(SUP_COA_SEQ  NOT NULL);

