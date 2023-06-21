 CREATE OR REPLACE FUNCTION EXP_CARTON_STATUS( CARTON_NO NUMBER)
 RETURN VARCHAR2
 IS
   X NUMBER;
   Y NUMBER;
   STS1 VARCHAR2(10);
   STS VARCHAR2(20);
 BEGIN
   SELECT COUNT(*) INTO X FROM EXP_CARTON WHERE CARTON_ID = CARTON_NO;
   SELECT STATUS INTO STS1 FROM EXP_CARTON WHERE CARTON_ID = CARTON_NO GROUP BY STATUS;
   --RETURN STS1;
   IF (X = 0) THEN
     RETURN 'NOT EXIST';
   END IF;
   
   IF (STS1 = 'OPEN') THEN
      RETURN 'OPEN';
   END IF;
   
   IF (STS1 = 'CLOSED') THEN
       SELECT COUNT(*) INTO Y FROM EXP_PACKING_DETAIL WHERE CARTON_ID = CARTON_NO;
       ---RETURN Y;
       IF (Y > 0) THEN 
         RETURN 'SHIPPED'; 
       ELSIF (Y = 0) THEN 
         RETURN 'CLOSED';
       END IF;     
   END IF; 
       
 END;
 
CREATE OR REPLACE VIEW EXP_CARTON_DET_SUMMARY
AS
SELECT     count(*) qty,  customer_id,  cpo_id, position, RATE, RSIZE,  
            STYLE, ITEM_DESCRIPTION , COLOR_ID, UNIT_ID,  CARTON_ID
    FROM EXP_CARTON_DET_VIEW
                 
     group by 
                     customer_id, cpo_id, position, RATE, RSIZE, STYLE, ITEM_DESCRIPTION , COLOR_ID, UNIT_ID, CARTON_ID
     order by carton_id;