/*
********************************************
CIS276 @PCC on cisdbor.pcc.edu PL/SQL program
AddLineItemSp.sql by Dipti Muni
This file contains stored procedures to help process a transaction. The transaction logic 
will add a new line item (INSERT) to an already existing order. 

2.	The stored procedure (AddLineItemSP) will issue an INSERT command 
that adds a new row to the ORDERITEMS table. When that INSERT is executed, 
the trigger will be "fired". The stored procedure will contain the ROLLBACK / 
COMMIT statements based upon an exception that the INSERT trigger may or may not RAISE.

    SET SERVEROUTPUT ON
    EXECUTE AddLineItemSP
 
2018.05.21 started file
********************************************
*/


CREATE OR REPLACE PROCEDURE AddLineItemSP 
    (inOrderID IN NUMBER, 
     inPartID IN NUMBER, 
     inQty IN NUMBER) 
AS

	BADQTY EXCEPTION;
	PRAGMA EXCEPTION_INIT (BADQTY, -20999);
    vLine			VARCHAR(100)  := ' ';
    
    
BEGIN
        
        INSERT INTO ORDERITEMS (OrderID, PartID, Qty)
        VALUES (inOrderID, inPartID, inQty);
        
        
    
EXCEPTION

    WHEN BADQTY THEN
        vLine := 'BADQTY Exception in AddLineItemSP : Not Enough Stock Quantity.';
		DBMS_OUTPUT.PUT_LINE (vLine);
		RAISE;
        
    WHEN NO_DATA_FOUND THEN
		vLine := 'NO_DATA_FOUND EXCEPTION';
		DBMS_OUTPUT.PUT_LINE(vLine);
        RAISE;
        
    WHEN OTHERS THEN
        vLine := 'OTHERS EXCEPTION in AddLineItemSp displays SQLCODE and SQLERRM';
        DBMS_OUTPUT.PUT_LINE (vLine);
        vLine := SQLCODE || ' -- ' || SQLERRM;
        DBMS_OUTPUT.PUT_LINE (vLine); 
        RAISE;

END;