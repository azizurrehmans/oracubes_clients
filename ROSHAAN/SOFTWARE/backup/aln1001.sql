select count(*) from inv_sc where coa_seq is null;
select sc_id from inv_sc where coa_seq is null;


declare
  seq number;
  oseq number;
  osc number;
  x number;
  z number;
  cursor nsc is select sc_id, description from inv_sc where coa_seq is null;--- and sc_id in (57504, 57510, 57511, 57512,57525,57730);
begin
  for r in nsc
  loop
    select count(*) into x from ac_coa where parent_id = 12 and sub_id=1 and ctrl_id = 1 and main_id = r.sc_id;
    if (x = 1) then
      select coa_seq into oseq from ac_coa where  parent_id = 12 and sub_id=1 and ctrl_id = 1 and main_id = r.sc_id;
      select count(*) into z from inv_sc where coa_seq = oseq;
      if (z = 0) then
        delete from ac_coa where coa_seq = oseq;
        commit;
      else  
        select sc_id into osc from inv_sc where coa_seq = oseq;
        update ac_coa set main_id = osc where coa_seq = oseq;
        commit;
      end if;  
    end if;
    select coa_seq.nextval into seq from dual;
    insert into ac_coa (parent_id, sub_id, ctrl_id, main_id, description, fdatetime, user_id, coa_seq) values (12,1,1,r.sc_id, r.description,sysdate,'aziz', seq);
    update inv_sc set coa_seq = seq where sc_id = r.sc_id;
    commit;
  end loop;
end;

ALTER TABLE ALNAEEM.INV_SC MODIFY(COA_SEQ  NOT NULL);

ALTER TABLE ALNAEEM.INV_SC  ADD CONSTRAINT inv_sc_coa_fk  FOREIGN KEY (COA_SEQ)  REFERENCES ALNAEEM.AC_COA (COA_SEQ);
     