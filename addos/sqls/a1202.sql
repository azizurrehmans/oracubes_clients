ALTER TABLE ADDOS.EXP_PACKING
 DROP PRIMARY KEY CASCADE;

ALTER TABLE ADDOS.EXP_PACKING DROP COLUMN INSERT_BY;

ALTER TABLE ADDOS.EXP_PACKING DROP COLUMN INSERT_DATE;

ALTER TABLE ADDOS.EXP_PACKING DROP COLUMN INSERT_TERM;

ALTER TABLE ADDOS.EXP_PACKING DROP COLUMN LAST_UPDATED_BY;

ALTER TABLE ADDOS.EXP_PACKING DROP COLUMN LAST_UPDATED_DATE;

ALTER TABLE ADDOS.EXP_PACKING DROP COLUMN LAST_UPDATED_TERM;

ALTER TABLE ADDOS.EXP_PACKING
 ADD CONSTRAINT EXP_PACKING_PK
 PRIMARY KEY
 (PACKING_ID);
 
 ALTER TABLE ADDOS.EXP_PACKING_DETAIL
MODIFY(PACKING_YEAR  NULL);


ALTER TABLE ADDOS.EXP_PACKING_DETAIL
 ADD CONSTRAINT exp_packing_detail_pk
 PRIMARY KEY
 (PACKING_ID, CPO_ID, POSITION, PARCEL_NO);
 
--------------------

CREATE OR REPLACE FORCE VIEW addos.exp_packing_detail_view (inv_no,
                                                            color_id,
                                                            rsize,
                                                            lot_no,
                                                            item_description,
                                                            style,
                                                            shipment_date,
                                                            packing_id,
                                                            packing_year,
                                                            packing_date,
                                                            despatched_to,
                                                            eform_no,
                                                            eform_date,
                                                            customer_id,
                                                            awb,
                                                            awb_date,
                                                            commision,
                                                            freight_ins,
                                                            discount,
                                                            customer_name,
                                                            item_code,
                                                            sc_main_id,
                                                            sc_sub_id,
                                                            sc_id,
                                                            qty,
                                                            breakage,
                                                            parcel_no,
                                                            sub_parcel_no,
                                                            cpo_id,
                                                            POSITION,
                                                            acc_rate,
                                                            gross_wt,
                                                            net_wt,
                                                            tc,
                                                            milled,
                                                            rd,
                                                            high_polish,
                                                            ncr,
                                                            SAMPLE,
                                                            order_qty,
                                                            forging_type,
                                                            parent_cpo,
                                                            sub_customer_id,
                                                            finish_id,
                                                            remarks,
                                                            rate,
                                                            milling_per,
                                                            hi_polish_per,
                                                            currency_id,
                                                            tot_parcel,
                                                            from_parcel,
                                                            to_parcel,
                                                            tot_breakage,
                                                            pi_no,
                                                            our_cpo,
                                                            cpo_year,
                                                            customs_item_desc
                                                           )
AS
   SELECT
          --pd.material,
          company_prefix || '/' || pd.packing_id || '/'
          || pd.packing_year inv_no,
          pd.color_id, pd.rsize, pd.lot_no, pd.item_description, pd.style,
          cdv.shipment_date,
                            --cc.alternative_code,
                            ---cc.alternative_desc,
                            p.packing_id, p.packing_year, p.packing_date,
          p.despatched_to, p.eform_no, p.eform_date, p.customer_id, p.awb,
          p.awb_date, p.commision, p.freight_ins, p.discount,
          c.description customer_name, 
                                       ---cc.item_code customer_store_code,
          '-' item_code, '-' sc_main_id, '-' sc_sub_id, '-' sc_id, pd.qty,
          '-' breakage, pd.parcel_no, '-' sub_parcel_no, pd.cpo_id,
          pd.POSITION, pd.rate acc_rate, pd.gross_wt, pd.net_wt, '-' tc,
          '-' milled, '-' rd, '-' high_polish, '-' ncr, '-' SAMPLE,
          cdv.quantity order_qty, '-' forging_type, '-' parent_cpo,
          '-' sub_customer_id, '-' finish_id, pd.remarks, 0 rate,
          c.milling_per, c.hi_polish_per, NVL (c.currency_id,
                                               '-') currency_id,
          ps.tot_parcel, ps.from_parcel, ps.to_parcel, ps.tot_breakage,
          cpo.pi_no, cpo.our_cpo, cpo.cpo_year, cdv.customs_item_desc
     FROM exp_packing p,
          exp_packing_detail pd,
          exp_customer c,
          exp_cpo cpo,
          exp_cpo_detail cdv,
          (SELECT   customer_id, packing_id, packing_year,
                    COUNT (DISTINCT parcel_no) tot_parcel,
                    MIN (parcel_no) from_parcel, MAX (parcel_no) to_parcel,
                    0 tot_breakage
               FROM exp_packing_detail
           GROUP BY customer_id, packing_id, packing_year) ps
    WHERE p.packing_id = pd.packing_id
      AND p.customer_id = pd.customer_id
      -------
      AND p.customer_id = c.customer_id(+)
      -------
      AND pd.cpo_id = cpo.cpo_id(+)
      -------
      AND pd.cpo_id = cdv.cpo_id(+)
      AND pd.POSITION = cdv.POSITION(+)
      -------
      AND p.packing_id = ps.packing_id(+)
      AND p.customer_id = ps.customer_id(+); 
-------------------------