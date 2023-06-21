CREATE OR REPLACE FUNCTION STORE.closing_valuef_date (M NUMBER,S NUMBER,C NUMBER,D DATE, F VARCHAR2)   
RETURN NUMBER  
  IS   
  O NUMBER;  
  T NUMBER;  
  X NUMBER;  
  IQ NUMBER;  
  OQ NUMBER;  
  yr varchar2(5) := accounts.fisical_year(d);  
    
BEGIN  
  X  := 0;  
  O  := 0;  
  IQ := 0;  
  OQ := 0;  
      
    select count(*) into x FROM STORE.SC_OPENING   
     WHERE SC_MAIN_ID = M AND SC_SUB_ID = S AND SC_ID = C AND SC_FINISH_ID=F  
     and sc_opening_year=yr;  
      
    if ( x > 0) then   
	    SELECT NVL(OVALUE,0) INTO O FROM STORE.SC_OPENING   
	     WHERE SC_MAIN_ID = M   
	     AND SC_SUB_ID = S   
	     AND SC_ID = C   
	     AND SC_FINISH_ID=F  
	     AND SC_OPENING_YEAR = YR;  
    else  
    	o := 0;  
    end if;  
      
    if ( m > 900) then   
	    select count(*) into x FROM STORE.TRANS  
	     WHERE SC_MAIN_ID = M AND SC_SUB_ID = S AND SC_ID = C  
	     ----and trans_date > '31-MAR-2006'  
	     and accounts.fisical_year(trans_date) = yr  
         and trans_date <= d  
         and sc_finish_id=f;  
          
        if ( x > 0) then  
            SELECT SUM(NVL(REC_VALUE,0)) - SUM(NVL(ISSUE_VALUE,0)) INTO IQ   
              FROM STORE.TRANS  
            WHERE SC_MAIN_ID = M AND SC_SUB_ID = S AND SC_ID = C  
              ----and trans_date > '31-MAR-2006'  
              and accounts.fisical_year(trans_date) = yr  
              and trans_date <= d  
              and sc_finish_id=f;  
        else  
            iq := 0;  
        end if;      
      OQ :=  nvl(O,0)+nvl(IQ,0);  
        
      elsif (m < 900) then  
              
        select count(*) into x FROM STORE.TRANS  
         WHERE SC_MAIN_ID = M AND SC_SUB_ID = S AND SC_ID = C  
         ---and trans_date > '30-JUN-2006'  
         and accounts.fisical_year(trans_date) = yr  
         and trans_date <= d  
         and sc_finish_id=f;  
          
        if ( x > 0) then  
            SELECT SUM(NVL(REC_VALUE,0)) - SUM(NVL(ISSUE_VALUE,0)) INTO IQ   
              FROM STORE.TRANS  
            WHERE SC_MAIN_ID = M AND SC_SUB_ID = S AND SC_ID = C  
              ---and trans_date > '30-JUN-2006'  
               and accounts.fisical_year(trans_date) = yr  
              and trans_date <= d  
              and sc_finish_id=f;  
        else  
            iq := 0;  
        end if;      
        OQ :=  nvl(O,0)+nvl(IQ,0);  
    end if;  	  
  	RETURN OQ;  
    
  END;
/
