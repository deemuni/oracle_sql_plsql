/*
********************************************
CIS276 @PCC on cisdbor.pcc.edu PL/SQL program
InsertOrderitemsTRG.sql by Dipti Muni
This file contains INSERT Trigger to help process a transaction. The transaction logic 
will add a new line item (INSERT) to an already existing order. 

3.	Inside the INSERT trigger (InsertOrderitemsTRG), the value of the new Detail 
column will be assigned and an UPDATE command will be issued to the INVENTORY table 
that reduces the quantity on hand (Stockqty) by the amount in the new lineitem. 
This, in turn will "fire" the UPDATE trigger. Should the UPDATE trigger generate an 
exception, the INSERT trigger will need to RAISE an exception so that AddLineItemSP 
knows to ROLLBACK.
 
EXECUTE InsertOrderitemsTRG.sql
2018.05.21 started file
********************************************
*/

CREATE OR REPLACE TRIGGER InsertOrderitemsTRG
BEFORE INSERT OR UPDATE ON ORDERITEMS
FOR EACH ROW

DECLARE 

	BADQTY EXCEPTION;
	PRAGMA EXCEPTION_INIT (BADQTY, -20999);
  /*  trg_Detail  ORDERITEMS.Detail%TYPE;
    trg_OrderID ORDERITEMS.OrderID%TYPE;
    trg_Stockqty INVENTORY.Stockqty%TYPE;
    trg_PartID   INVENTORY.PartID%TYPE; */
    
BEGIN
	
	
    SELECT  NVL(MAX(Detail)+1, 1)
    INTO    :NEW.Detail
    FROM    ORDERITEMS 
    WHERE   OrderID = :NEW.OrderID;
        
            
    UPDATE 	INVENTORY
    SET 	Stockqty = Stockqty - :NEW.Qty
    WHERE 	PartID = :NEW.PartID; 
    
    
EXCEPTION
	WHEN BADQTY THEN
		DBMS_OUTPUT.PUT_LINE ('BADQTY Exception in InsertOrderitemsTRG :  Not enough quantity in Stock.');
		RAISE;
	WHEN OTHERS THEN
		RAISE;
		
END;