select sc_id, issue_qty, issue_value, inv_sc_avg_rate(sc_id, sysdate) avg_rate, issue_qty*inv_sc_avg_rate(sc_id, sysdate) avg_cost, rate, issue_qty*rate sale_value,
issue_qty*rate - issue_qty*inv_sc_avg_rate(sc_id, sysdate) pf
from inv_ir_detail where ir_id = 220111;

select sum(rec_qty), sum(rec_value), sum(rec_value)/sum(rec_qty) from inv_trans where sc_id = 1336;
select sum(rec_qty), sum(rec_value), sum(rec_value)/sum(rec_qty) from inv_trans where sc_id = 57245;

select sc_id, oyear, oqty, ovalue, orate from inv_sc_opening where sc_id in (select sc_id from inv_ir_detail where ir_id = 220180) and oyear = '18-19';

update inv_sc_opening a set orate = (select  case when sum(rec_qty) > 0 then trunc(sum(rec_value)/sum(rec_qty)) else 0 end
    from inv_trans t where t.sc_id = a.sc_id),
    ovalue = oqty*(select  case when sum(rec_qty) > 0 then trunc(sum(rec_value)/sum(rec_qty)) else 0 end
    from inv_trans t where t.sc_id = a.sc_id)
    where oqty > 0 and ovalue = 0 and sc_id in (select sc_id from inv_ir_detail where ir_id = 220180) and oyear = '18-19';