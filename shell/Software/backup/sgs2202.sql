select trans_type, sc_id, mis_ref, count(*) from inv_trans where mis_ref is not null group by trans_type, sc_id, mis_ref having count(*) > 1;

select ir_id, ir_yearly_id from inv_ir where ir_id in (4920,4813);

update inv_trans set mis_ref=trans_type||'#'||nvl(eci_id,ecr_id) where mis_ref is null;

ALTER TABLE SGS1.INV_TRANS ADD CONSTRAINT inv_trans_mis_ref_sc_uq UNIQUE (MIS_REF, SC_ID);
ALTER TABLE SGS1.INV_TRANS MODIFY(MIS_REF  NOT NULL);

