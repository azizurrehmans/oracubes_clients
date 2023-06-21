DROP VIEW ADDOS.INV_IGP_EXPENSE_VIEW;

/* Formatted on 2022/04/07 16:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW addos.inv_igp_expense_view (amount,
                                                         expense_id,
                                                         igp_id,
                                                         description
                                                        )
AS
   SELECT e.amount, e.expense_id, e.igp_id, ed.description
     FROM inv_igp_expense e, inv_expense ed
    WHERE e.expense_id = ed.inv_expense_id;


