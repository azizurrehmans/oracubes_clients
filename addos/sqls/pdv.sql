DROP VIEW ADDOS.INV_PO_DETAIL_VIEW;

/* Formatted on 2021/09/21 15:07 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW addos.inv_po_detail_view (fcurrency,
                                                       exchange_rate,
                                                       fc_rate,
                                                       po_year,
                                                       color,
                                                       SPECIFICATION,
                                                       english,
                                                       advance,
                                                       sales_tax,
                                                       sales_tax_per,
                                                       fc_amount,
                                                       fc_amount2,
                                                       po_type,
                                                       po_type_old,
                                                       preq_id,
                                                       preq_year,
                                                       pod,
                                                       po,
                                                       cpo,
                                                       cpo_type,
                                                       our_cpo,
                                                       cpo_year,
                                                       demandedby,
                                                       purpose,
                                                       user_id,
                                                       catalog_copy,
                                                       SAMPLE,
                                                       guage,
                                                       drawing,
                                                       po_det_status_id,
                                                       po_id,
                                                       po_date,
                                                       special_ins,
                                                       po_remarks,
                                                       po_detail_remarks,
                                                       add_specs,
                                                       supplier_phone2,
                                                       ygp,
                                                       customer_code,
                                                       batch_no,
                                                       delivery_date,
                                                       bill,
                                                       status_id,
                                                       po_detail_id,
                                                       POSITION,
                                                       po_store_code,
                                                       store_code,
                                                       item_description,
                                                       unit_id,
                                                       sc_id,
                                                       po_quantity,
                                                       excess_qty,
                                                       excess_per,
                                                       rate,
                                                       amount,
                                                       sales_tax_amount,
                                                       sales_tax_1,
                                                       sc_finish_id,
                                                       supplier_id,
                                                       supplier_name,
                                                       supplier_address,
                                                       supplier_phone1,
                                                       status,
                                                       rate_status_id,
                                                       igp_balance_qty
                                                      )
AS
   SELECT po.fcurrency, po.exchange_rate, pd.fc_rate, po.po_year, sc.color,
          sc.SPECIFICATION, sc.english, po.advance, po.sales_tax,
          po.sales_tax_per, pd.fc_rate * pd.po_quantity fc_amount,
          pd.fc_rate * pd.po_quantity || po.fcurrency fc_amount2, po.po_type,
          po.po_type po_type_old, po.preq_id, po.preq_year,
             DECODE (po.po_type, 'CASH', 'PO-CS', 'CREDIT', 'PO-CR')
          || '/'
          || po.po_id
          || '/'
          || po.po_year
          || '/'
          || pd.po_detail_id pod,
             DECODE (po.po_type, 'CASH', 'PO-CS', 'CREDIT', 'PO-CR')
          || '/'
          || po.po_id
          || '/'
          || po.po_year po,
          cpo.cpo_type || '/' || po.our_cpo || '/' || po.cpo_year cpo,
          cpo.cpo_type, po.our_cpo, po.cpo_year, po.demandedby, po.purpose,
          po.user_id, pd.catalog_copy, pd.SAMPLE, pd.guage, pd.drawing,
          pd.status_id po_det_status_id, pd.po_id, po.po_date,
                                                              ---po.po_type po_type,
                                                              po.special_ins,
          po.special_ins po_remarks, pd.add_specs po_detail_remarks,
          pd.add_specs, NULL supplier_phone2, '' ygp, '' customer_code,
          '' batch_no,
                      --po.supplier_id,
                      pd.delivery_date, po.bill, po.status_id,
          pd.po_detail_id, pd.POSITION,
                                       --cc.item_code customer_item_code,
                                       sc.sc_id po_store_code,
          sc.sc_id store_code, sc.description item_description,
          sc.unit_id unit_id, pd.sc_id sc_id,
                                             --store_code_desc.store_code (pd.sc_main_id) sc_main_desc,
                                             pd.po_quantity, pd.excess_qty,
          pd.excess_per, pd.rate, pd.po_quantity * pd.rate amount,
          pd.po_quantity * pd.rate * po.sales_tax_per * 0.01 sales_tax_amount,
          pd.sales_tax,                                       ---pd.add_specs,
                       pd.sc_finish_id, po.supplier_id,
          s.description supplier_name, s.address supplier_address,
          s.phone supplier_phone1, po.status_id status, po.rate_status_id,
          inv_igp_po_balance_qty (pd.po_detail_id) igp_balance_qty
     FROM inv_po po,
          inv_po_detail pd,
          exp_cpo cpo,
          --customer_code cc,
          ac_coa_view s,
          inv_sc_view sc
    WHERE po.po_id = pd.po_id
------
      AND po.our_cpo = cpo.our_cpo(+)
      AND po.cpo_year = cpo.cpo_year(+)
------
      AND po.supplier_id = s.coa_seq(+)
-------
      AND pd.sc_id = sc.sc_id;


