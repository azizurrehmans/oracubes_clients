DELETE FROM AC_CHEQUE_BOOK_DET;
DELETE FROM AC_CHEQUE_BOOK;
UPDATE AC_VOUCHER SET SAN_ID = NULL, SAN_YEAR = NULL;
DELETE FROM TRANS WHERE TRANS_TYPE = 'GIR';
DELETE FROM TRANS;
DELETE FROM SAN;
DELETE FROM AC_VOUCHER;
DELETE FROM CPO;
delete from mpd;
delete from mp;
DELETE FROM GIR_DETAIL;
DELETE FROM PR_DETAIL;
DELETE FROM OGP_DETAIL;