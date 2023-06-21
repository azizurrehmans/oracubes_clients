update sc_sub set sub1=trunc(sc_sub_id/10), sub2=mod(sc_sub_id,10)
where length(sc_sub_id) < 5 and length(sc_sub_id) > 3
