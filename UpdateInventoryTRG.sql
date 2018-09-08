/*
********************************************
CIS276 @PCC on cisdbor.pcc.edu PL/SQL program
UpdateInventoryTRG.sql by Dipti Muni
This file contains INSERT Trigger to help process a transaction. The transaction logic 
will add a new line item (Update) to an already existing order. 

4.	Inside the UPDATE trigger (UpdateInventoryTRG) you will check to see if 
the Stockqty is enough for this new lineitem and if it isn't, you will RAISE an 
exception. The exception from the UPDATE trigger goes to the INSERT trigger 
(and then to the stored procedure where the transaction is halted and a 
ROLLBACK is issued).

EXECUTE UpdateInventoryTRG.sql
 
2018.05.21 started file
********************************************
*/

CREATE OR REPLACE TRIGGER UnpdateInventoryTRG
    BEFORE UPDATE ON INVENTORY
    FOR EACH ROW

DECLARE 

	BADQTY EXCEPTION;
	PRAGMA EXCEPTION_INIT (BADQTY, -20999);


BEGIN
	

		IF :NEW.Stockqty < 0 THEN
		RAISE BADQTY;
		END IF;
		
EXCEPTION
	WHEN BADQTY THEN
		DBMS_OUTPUT.PUT_LINE ('BADQTY Exception in UpdateInventoryTRG :  Not enough quantity in Stock.');
		RAISE;
	WHEN OTHERS THEN
		RAISE;
		
END;