/*
********************************************
CIS276 @PCC on cisdbor.pcc.edu PL/SQL program
Lab7.sql by Dipti Muni
This contains PL/SQL program file to process a transaction. The transaction logic 
will add a new line item (INSERT) to an already existing order. 
The scenario could be that a customer has previously placed an order 
and now wishes to add another item to the order. 
This could happen by a phone call or a web connection. The input data for 
this transaction will be the CustID, the Orderid, the Partid and Quantity 
for the new lineitem (in that order). After the new lineitem has been inserted, 
the INVENTORY table must be updated to reflect the change in the Stockqty 
for the partid on the new lineitem. After that UPDATE, check the value of the stockqty. 
If it is a negative number there is not enough stock to 
sell so the transaction needs to be rolled back. 
We can leave a zero balance in stock although that puts the quantity 
under the reorder point.

We will use store procedures for adding new line and two triggers: one for INSERT
and another for UPDATE.
 
2018.05.21 started file
********************************************
*/


/*
********************************************
1.	The transaction variables (Custid, Orderid, Partid, Qty in that order PLEASE) 
will be passed to your program (Lab7)so you will assign the values &1, &2, &3, &4. 
Your program can use nested or sequential blocks to validate the Custid, Orderid, 
Custid/Orderid pairing, Partid, and ensure the quantity is greater than zero before 
calling the stored procedure where you will send the Orderid, Partid, and quantity
 values. Each validation is to be contained within one block although the Orderid and 
 Custid/Orderid validation may be in one block. 
********************************************
*/

SET SERVEROUTPUT ON
SET VERIFY OFF

DECLARE
	
    --input variables
	inCustID		CUSTOMERS.CustID%TYPE;
	inOrderID		ORDERS.OrderID%TYPE;
	inPartID		INVENTORY.PartID%TYPE;
	inQty			ORDERITEMS.Qty%TYPE;
    
    --constant
    vMsg			VARCHAR(100) := ' ';
    vErrorMsg		VARCHAR(100) := ' ';
	vName			CUSTOMERS.Cname%TYPE;
    vOrderID		ORDERS.OrderID%TYPE;
    vSalesDate		ORDERS.SalesDate%TYPE;
    vDescription    INVENTORY.Description%TYPE;
    
    --validation boolean
    custValid       CHAR(1);
    orderValid      CHAR(1);
    comboValid      CHAR(1);
    partValid       CHAR(1);
    qtyValid        CHAR(1);
    
    --exception
    BADQTY          EXCEPTION; ---user-defined exception
    BADINPUT        EXCEPTION; ---user-defined exception
	PRAGMA EXCEPTION_INIT (BADQTY, -20999);
    
    
BEGIN ---Outer block

	vMsg := 'CIS276 Lab7 by Dipti Muni';
	DBMS_OUTPUT.PUT_LINE(vMsg);
    
    ---Assignment of the sequence number for the data
	inCustID := &1;
	inOrderID := &2;
	inPartID := &3;
	inQty := &4;
    
    custValid := 'N';
    orderValid := 'N';
    comboValid := 'N';
    partValid := 'N';
    qtyValid := 'N';
    	

    ---CustId Validation
	BEGIN 
		SELECT 	CUSTOMERS.Cname
              , 'Y'
		INTO   	vName
              , custValid
		FROM 	CUSTOMERS
		WHERE 	CUSTOMERS.CustID = inCustID;
		
	---Print message if CustID valid
		vMsg := 'The CustID: ' || inCustID || ' belongs to the customer: ' || vName; 
		DBMS_OUTPUT.PUT_LINE(vMsg);
    
    --if CustID not valid or other errors
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
		vErrorMsg := 'CustID entered is invalid: ' || inCustID;
		DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND EXCEPTION: ' || vErrorMsg);
		
		WHEN OTHERS THEN 
			DBMS_OUTPUT.PUT_LINE('Lab7: CustID Validation OTHERS EXCEPTION');
			DBMS_OUTPUT.PUT_LINE(SQLCODE || '--' || SQLERRM);	
    END;
    	
    
    ---OrderID Validation
	BEGIN  
		SELECT 	ORDERS.OrderID
              , 'Y'
		INTO    vOrderID
              , orderValid
		FROM 	ORDERS
		WHERE 	ORDERS.OrderID = inOrderID;
		
	---Print message if OrderID valid
		vMsg := 'The OrderID: ' || inOrderID || ' is valid.'; 
		DBMS_OUTPUT.PUT_LINE(vMsg);
   
    --if OrderID not valid or other errors
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
		vErrorMsg := 'OrderID entered is invalid: ' || inOrderID;
		DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND EXCEPTION: ' || vErrorMsg);
		
		WHEN OTHERS THEN 
			DBMS_OUTPUT.PUT_LINE('Lab7: OrderID Validation OTHERS EXCEPTION');
			DBMS_OUTPUT.PUT_LINE(SQLCODE || '--' || SQLERRM);
	END;
    	
    
    --Customer/Order Validation
	BEGIN
		SELECT 		CUSTOMERS.Cname
				  , ORDERS.OrderID
				  , ORDERS.SalesDate
                  , 'Y'
		INTO    	vName
				  , vOrderID
				  , vSalesDate
                  , comboValid
		FROM		CUSTOMERS
		INNER JOIN 	ORDERS ON CUSTOMERS.CustID = ORDERS.CustID
		WHERE 		CUSTOMERs.CustID = inCustID
		AND			ORDERS.OrderID = inOrderID;
		
	---Print message if CustID valid
		vMsg := 'The Customer, ' || TRIM(vName) || ', has an OrderID ' || inOrderID ||  
				' that was bought on ' || vSalesdate; 
		DBMS_OUTPUT.PUT_LINE(vMsg);
        
    	--if the combination is not valid or other errors
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
		vErrorMsg := 'The combination of CustID (' || inCustID || ') and OrderID (' 
					 || inOrderID || ') is incorrect';
		DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND EXCEPTION: ' || vErrorMsg);
		
		WHEN OTHERS THEN 
			DBMS_OUTPUT.PUT_LINE('Lab7: Customer/Order Validation OTHERS EXCEPTION');
			DBMS_OUTPUT.PUT_LINE(SQLCODE || '--' || SQLERRM);
	END;
    	

    ---PartId Validation
	BEGIN 	
		SELECT INVENTORY.Description
             , 'Y'
   		INTO   vDescription
             , partValid
   		FROM  INVENTORY
  	    WHERE INVENTORY.PartID = inPartID;
		
	---Print message if PartID valid
		vMsg := 'The PartID: ' || inPartID || ' of ' || TRIM(vDescription) || ' is valid'; 
		DBMS_OUTPUT.PUT_LINE(vMsg);
    
    --if PartID not valid or other errors
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
		vErrorMsg := 'PartID entered is invalid:' || inPartID;
		DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND EXCEPTION: ' || vErrorMsg);
		
		WHEN OTHERS THEN 
			DBMS_OUTPUT.PUT_LINE('Lab7: PartID Validation OTHERS EXCEPTION');
			DBMS_OUTPUT.PUT_LINE(SQLCODE || '--' || SQLERRM);	
	END;
    	

    ---Quantity Validation
	BEGIN
		IF inQty > 0 THEN
			vMsg := 'Quantity requested is ' || inQty || ' quantity.';
            qtyValid := 'Y';
            DBMS_OUTPUT.PUT_LINE (vMsg);
        ELSE
        	vErrorMsg := 'INVALID AMOUNT: The quantity entered ' || inQty || ' is not greater than zero.';
            DBMS_OUTPUT.PUT_LINE (vErrorMsg);
        END IF;
    END;
    
    SAVEPOINT mysavepoint;
    
    IF custValid = 'Y' AND orderValid = 'Y' AND comboValid = 'Y' AND partValid = 'Y' AND qtyValid = 'Y' THEN
    
        AddLineItemSP (inOrderID, inPartID, inQty);
        
    vMsg := '1 Row added if transaction completes successfully.'; 
		DBMS_OUTPUT.PUT_LINE(vMsg);
    ELSE
        vErrorMsg := 'NOT ALL INPUT VALIDATED.';
        DBMS_OUTPUT.PUT_LINE (vErrorMsg);
        RAISE BADINPUT; 
    END IF; 
    
    vMsg := 'SUCCESSFUL TRANSACTION: '|| TRIM(inQty) || ' quantity of ' || TRIM(vDescription) || ' was added to the OrderId ' 
                || TRIM(inOrderID);
    DBMS_OUTPUT.PUT_LINE(vMsg);
    
    COMMIT;
    
	vMsg := 'Lab7 Transaction completes successfully. Program Ended.';
	DBMS_OUTPUT.PUT_LINE(vMsg);
    
EXCEPTION
    WHEN BADINPUT THEN
        vErrorMsg := 'Lab7 BADINPUT EXCEPTION: Transaction Failed. Invalid input(s) --See comments above.';
        DBMS_OUTPUT.PUT_LINE (vErrorMsg);
        ROLLBACK to mysavepoint;
        
    WHEN BADQTY THEN
        vErrorMsg := 'Lab7 BADQTY EXCEPTION: Transaction Failed. Not enough quantity in Stock.';
        DBMS_OUTPUT.PUT_LINE (vErrorMsg); 
        ROLLBACK to mysavepoint;
        
    WHEN NO_DATA_FOUND THEN
		vErrorMsg := 'NO_DATA_FOUND EXCEPTION: Lab7';
		DBMS_OUTPUT.PUT_LINE(vErrorMsg);
       ROLLBACK to mysavepoint;
		
	WHEN OTHERS THEN
		vErrorMsg := 'Lab7 OTHERS EXCEPTION ERROR';
		DBMS_OUTPUT.PUT_LINE(vErrorMsg);
		DBMS_OUTPUT.PUT_LINE(SQLCODE || '--' || SQLERRM);
        ROLLBACK to mysavepoint;
    
END;

