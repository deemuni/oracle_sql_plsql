/*
********************************************************************************
CIS276 @PCC on cisdbor.pcc.edu PL/SQL program SQL Developer and SalesDB
Test7.sql by Dipti Muni
This script file contains my tests for Lab7 program with Stored procedures, and two 
triggers: one for INSERT and one for UPDATE.
********************************************************************************
*/

SET VERFIY OFF
SET SERVEROUTPUT ON

----inCustID--inOrderID--inPartID--inQty----

/*
Test #1 all bad data
*/
@Lab7 9999  9999   9999   -1

/*
Test #2 All bad except CustID
*/
@Lab7 1  9999  9999 -5

/*
Test #3 All bad except CustID and OrderID that matches
*/
@Lab7 1 6099 9999 -10

/*
Test #4 All bad except CustID and OrderID that doesn't matches
*/
@Lab7  2  6099  9999 -99

/*
Test #5 All bad except CustID and OrderID that matches and PartID
*/
@Lab7 1 6099 1001 -10

/*
Test #6 All bad except CustID and OrderID that doesn't matches and Quantity is valid
*/
@Lab7 2 6099 9999 10

/*
Test #7 All bad except OrderID 
*/
@Lab7 9999 6099 9999 -10
/*
Test #8 All correct except CustID 
*/
@Lab7 9999 6099 1002 10

/*
Test #9 All correct except OrderID 
*/
@Lab7 1 9999 1002 10

/*
Test #10 All correct except PartID
*/
@Lab7 1 6099 0000 10

/*
Test #11 Bad Qty - when qty is 0
*/
@Lab7 1 6099 1001 0

/*
Test #12 Bad Qty - when qty is negative
*/
@Lab7 1 6099 1001 -100

/*
Test #13 CustID and OrderID correct but don't match with all valid values
*/
@Lab7 2 6099 1001 10

/*
Test #14 Invalid CustID and OrderID
*/
@Lab7 999 9999 1001 10

/*
Test #15 All Input valid and CustID and OrderID match - ALL GOOD with existing PartID
*/
-- SELECT * FROM ORDERITEMS;
SELECT      TO_CHAR(C.CustID, '9999') AS "ID",
            CAST(C.CName AS VARCHAR(30)) AS "Name",
            TO_CHAR(O.OrderID, '9999') AS "OrderID",
            TO_CHAR(O.SalesDate, 'MM-DD-YYYY') AS "Date",
            TO_CHAR(OI.Detail, '99999') AS "Detail",
            TO_CHAR(OI.PartID, '99999') AS "PartID",
            TO_CHAR(OI.Qty, '99,999') AS "Qty",
            CAST(INV.Description AS CHAR(20)) AS "Description",
            TO_CHAR(INV.StockQty, '99,999') AS "StkQty"
FROM        CUSTOMERS C
FULL JOIN   ORDERS O ON C.CustID = O.CustID
FULL JOIN   ORDERITEMS OI ON O.OrderID = OI.OrderID
FULL JOIN   INVENTORY INV ON OI.PartID = INV.PartID
WHERE       C.CustID = 1 
AND         O.OrderID = 6099
ORDER BY    OI.DETAIL ASC;

        
@Lab7 1 6099 1002 2

SELECT      TO_CHAR(C.CustID, '9999') AS "ID",
            CAST(C.CName AS VARCHAR(30)) AS "Name",
            TO_CHAR(O.OrderID, '9999') AS "OrderID",
            TO_CHAR(O.SalesDate, 'MM-DD-YYYY') AS "Date",
            TO_CHAR(OI.Detail, '99999') AS "Detail",
            TO_CHAR(OI.PartID, '99999') AS "PartID",
            TO_CHAR(OI.Qty, '99,999') AS "Qty",
            CAST(INV.Description AS CHAR(20)) AS "Description",
            TO_CHAR(INV.StockQty, '99,999') AS "StkQty"
FROM        CUSTOMERS C
FULL JOIN   ORDERS O ON C.CustID = O.CustID
FULL JOIN   ORDERITEMS OI ON O.OrderID = OI.OrderID
FULL JOIN   INVENTORY INV ON OI.PartID = INV.PartID
WHERE       C.CustID = 1 
AND         O.OrderID = 6099
ORDER BY    OI.DETAIL ASC;

--@SalesDBreset
-- SELECT * FROM ORDERITEMS;

/*
Test #16 All Input valid and CustID and OrderID match - ALL GOOD with PartID that doesnot exists in that Order.
*/
-- SELECT * FROM ORDERITEMS;
SELECT      TO_CHAR(C.CustID, '9999') AS "ID",
            CAST(C.CName AS VARCHAR(30)) AS "Name",
            TO_CHAR(O.OrderID, '9999') AS "OrderID",
            TO_CHAR(O.SalesDate, 'MM-DD-YYYY') AS "Date",
            TO_CHAR(OI.Detail, '99999') AS "Detail",
            TO_CHAR(OI.PartID, '99999') AS "PartID",
            TO_CHAR(OI.Qty, '99,999') AS "Qty",
            CAST(INV.Description AS CHAR(20)) AS "Description",
            TO_CHAR(INV.StockQty, '99,999') AS "StkQty"
FROM        CUSTOMERS C
FULL JOIN   ORDERS O ON C.CustID = O.CustID
FULL JOIN   ORDERITEMS OI ON O.OrderID = OI.OrderID
FULL JOIN   INVENTORY INV ON OI.PartID = INV.PartID
WHERE       C.CustID = 12 
AND         O.OrderID = 6155
ORDER BY    OI.DETAIL ASC;

@Lab7 12 6155 1008 9

SELECT      TO_CHAR(C.CustID, '9999') AS "ID",
            CAST(C.CName AS VARCHAR(30)) AS "Name",
            TO_CHAR(O.OrderID, '9999') AS "OrderID",
            TO_CHAR(O.SalesDate, 'MM-DD-YYYY') AS "Date",
            TO_CHAR(OI.Detail, '99999') AS "Detail",
            TO_CHAR(OI.PartID, '99999') AS "PartID",
            TO_CHAR(OI.Qty, '99,999') AS "Qty",
            CAST(INV.Description AS CHAR(20)) AS "Description",
            TO_CHAR(INV.StockQty, '99,999') AS "StkQty"
FROM        CUSTOMERS C
FULL JOIN   ORDERS O ON C.CustID = O.CustID
FULL JOIN   ORDERITEMS OI ON O.OrderID = OI.OrderID
FULL JOIN   INVENTORY INV ON OI.PartID = INV.PartID
WHERE       C.CustID = 12 
AND         O.OrderID = 6155
ORDER BY    OI.DETAIL ASC;

--@SalesDBreset
-- SELECT * FROM ORDERITEMS;

/*
Test #17 All Input valid and CustID and OrderID match, but Qty requested exceeds Stockqty. Fails
*/

@Lab7 2 6109 1007 11

/*
Test #18 All Input valid and CustID and OrderID match, but Qty requested is exactly amount of Stockqty.
         Therefore new Stockqty is 0.
*/
-- SELECT * FROM ORDERITEMS;
-- SELECT * FROM INVENTORY;
SELECT      TO_CHAR(C.CustID, '9999') AS "ID",
            CAST(C.CName AS VARCHAR(30)) AS "Name",
            TO_CHAR(O.OrderID, '9999') AS "OrderID",
            TO_CHAR(O.SalesDate, 'MM-DD-YYYY') AS "Date",
            TO_CHAR(OI.Detail, '99999') AS "Detail",
            TO_CHAR(OI.PartID, '99999') AS "PartID",
            TO_CHAR(OI.Qty, '99,999') AS "Qty",
            CAST(INV.Description AS CHAR(20)) AS "Description",
            TO_CHAR(INV.StockQty, '99,999') AS "StkQty"
FROM        CUSTOMERS C
FULL JOIN   ORDERS O ON C.CustID = O.CustID
FULL JOIN   ORDERITEMS OI ON O.OrderID = OI.OrderID
FULL JOIN   INVENTORY INV ON OI.PartID = INV.PartID
WHERE       C.CustID = 2 
AND         O.OrderID = 6109
ORDER BY    OI.DETAIL ASC;


@Lab7 2 6109 1001 100

SELECT      TO_CHAR(C.CustID, '9999') AS "ID",
            CAST(C.CName AS VARCHAR(30)) AS "Name",
            TO_CHAR(O.OrderID, '9999') AS "OrderID",
            TO_CHAR(O.SalesDate, 'MM-DD-YYYY') AS "Date",
            TO_CHAR(OI.Detail, '99999') AS "Detail",
            TO_CHAR(OI.PartID, '99999') AS "PartID",
            TO_CHAR(OI.Qty, '99,999') AS "Qty",
            CAST(INV.Description AS CHAR(20)) AS "Description",
            TO_CHAR(INV.StockQty, '99,999') AS "StkQty"
FROM        CUSTOMERS C
FULL JOIN   ORDERS O ON C.CustID = O.CustID
FULL JOIN   ORDERITEMS OI ON O.OrderID = OI.OrderID
FULL JOIN   INVENTORY INV ON OI.PartID = INV.PartID
WHERE       C.CustID = 2 
AND         O.OrderID = 6109
ORDER BY    OI.DETAIL ASC;

--@SalesDBreset
-- SELECT * FROM ORDERITEMS;
-- SELECT * FROM INVENTORY;

/*
Test #19 All Input valid and CustID and OrderID match, but the new lineitem is the same as the inputs that already exists.
         Should not cause error it will just have Max(Detail)+1 for that order.
*/
-- SELECT * FROM ORDERITEMS;
SELECT      TO_CHAR(C.CustID, '9999') AS "ID",
            CAST(C.CName AS VARCHAR(30)) AS "Name",
            TO_CHAR(O.OrderID, '9999') AS "OrderID",
            TO_CHAR(O.SalesDate, 'MM-DD-YYYY') AS "Date",
            TO_CHAR(OI.Detail, '99999') AS "Detail",
            TO_CHAR(OI.PartID, '99999') AS "PartID",
            TO_CHAR(OI.Qty, '99,999') AS "Qty",
            CAST(INV.Description AS CHAR(20)) AS "Description",
            TO_CHAR(INV.StockQty, '99,999') AS "StkQty"
FROM        CUSTOMERS C
FULL JOIN   ORDERS O ON C.CustID = O.CustID
FULL JOIN   ORDERITEMS OI ON O.OrderID = OI.OrderID
FULL JOIN   INVENTORY INV ON OI.PartID = INV.PartID
WHERE       C.CustID = 3
AND         O.OrderID = 6128
ORDER BY    OI.DETAIL ASC;

@Lab7 3 6128 1004 2

SELECT      TO_CHAR(C.CustID, '9999') AS "ID",
            CAST(C.CName AS VARCHAR(30)) AS "Name",
            TO_CHAR(O.OrderID, '9999') AS "OrderID",
            TO_CHAR(O.SalesDate, 'MM-DD-YYYY') AS "Date",
            TO_CHAR(OI.Detail, '99999') AS "Detail",
            TO_CHAR(OI.PartID, '99999') AS "PartID",
            TO_CHAR(OI.Qty, '99,999') AS "Qty",
            CAST(INV.Description AS CHAR(20)) AS "Description",
            TO_CHAR(INV.StockQty, '99,999') AS "StkQty"
FROM        CUSTOMERS C
FULL JOIN   ORDERS O ON C.CustID = O.CustID
FULL JOIN   ORDERITEMS OI ON O.OrderID = OI.OrderID
FULL JOIN   INVENTORY INV ON OI.PartID = INV.PartID
WHERE       C.CustID = 3
AND         O.OrderID = 6128
ORDER BY    OI.DETAIL ASC;

--@SalesDBreset
-- SELECT * FROM ORDERITEMS;

/*
Test #20 All Input valid and CustID and OrderID match, but the new lineitem is entered consecutively or twice
         Not required for this assignment but in real situation, I would display a warning message so the user is aware 
         and they can fix it if it is an error.
*/
-- SELECT * FROM ORDERITEMS;
SELECT      TO_CHAR(C.CustID, '9999') AS "ID",
            CAST(C.CName AS VARCHAR(30)) AS "Name",
            TO_CHAR(O.OrderID, '9999') AS "OrderID",
            TO_CHAR(O.SalesDate, 'MM-DD-YYYY') AS "Date",
            TO_CHAR(OI.Detail, '99999') AS "Detail",
            TO_CHAR(OI.PartID, '99999') AS "PartID",
            TO_CHAR(OI.Qty, '99,999') AS "Qty",
            CAST(INV.Description AS CHAR(20)) AS "Description",
            TO_CHAR(INV.StockQty, '99,999') AS "StkQty"
FROM        CUSTOMERS C
FULL JOIN   ORDERS O ON C.CustID = O.CustID
FULL JOIN   ORDERITEMS OI ON O.OrderID = OI.OrderID
FULL JOIN   INVENTORY INV ON OI.PartID = INV.PartID
WHERE       C.CustID = 11
AND         O.OrderID = 6148
ORDER BY    OI.DETAIL ASC;


@Lab7 11 6148 1009 2
@Lab7 11 6148 1009 2

SELECT      TO_CHAR(C.CustID, '9999') AS "ID",
            CAST(C.CName AS VARCHAR(30)) AS "Name",
            TO_CHAR(O.OrderID, '9999') AS "OrderID",
            TO_CHAR(O.SalesDate, 'MM-DD-YYYY') AS "Date",
            TO_CHAR(OI.Detail, '99999') AS "Detail",
            TO_CHAR(OI.PartID, '99999') AS "PartID",
            TO_CHAR(OI.Qty, '99,999') AS "Qty",
            CAST(INV.Description AS CHAR(20)) AS "Description",
            TO_CHAR(INV.StockQty, '99,999') AS "StkQty"
FROM        CUSTOMERS C
FULL JOIN   ORDERS O ON C.CustID = O.CustID
FULL JOIN   ORDERITEMS OI ON O.OrderID = OI.OrderID
FULL JOIN   INVENTORY INV ON OI.PartID = INV.PartID
WHERE       C.CustID = 11
AND         O.OrderID = 6148
ORDER BY    OI.DETAIL ASC;

--@SalesDBreset
-- SELECT * FROM ORDERITEMS;

/*
Test #21 All Input valid and CustID and OrderID match, but there are no detail line item in OrderItems
*/
-- SELECT * FROM ORDERITEMS;
INSERT INTO ORDERS (OrderID, EmpID, CustID, SalesDate) VALUES (8879, 106, 79, SYSDATE);
SELECT      TO_CHAR(C.CustID, '9999') AS "ID",
            CAST(C.CName AS VARCHAR(30)) AS "Name",
            TO_CHAR(O.OrderID, '9999') AS "OrderID",
            TO_CHAR(O.SalesDate, 'MM-DD-YYYY') AS "Date",
            TO_CHAR(OI.Detail, '99999') AS "Detail",
            TO_CHAR(OI.PartID, '99999') AS "PartID",
            TO_CHAR(OI.Qty, '99,999') AS "Qty",
            CAST(INV.Description AS CHAR(20)) AS "Description",
            TO_CHAR(INV.StockQty, '99,999') AS "StkQty"
FROM        CUSTOMERS C
FULL JOIN   ORDERS O ON C.CustID = O.CustID
FULL JOIN   ORDERITEMS OI ON O.OrderID = OI.OrderID
FULL JOIN   INVENTORY INV ON OI.PartID = INV.PartID
WHERE       C.CustID = 79
AND         O.OrderID = 8879
ORDER BY    OI.DETAIL ASC;

@Lab7 79 8879 1003 3

SELECT      TO_CHAR(C.CustID, '9999') AS "ID",
            CAST(C.CName AS VARCHAR(30)) AS "Name",
            TO_CHAR(O.OrderID, '9999') AS "OrderID",
            TO_CHAR(O.SalesDate, 'MM-DD-YYYY') AS "Date",
            TO_CHAR(OI.Detail, '99999') AS "Detail",
            TO_CHAR(OI.PartID, '99999') AS "PartID",
            TO_CHAR(OI.Qty, '99,999') AS "Qty",
            CAST(INV.Description AS CHAR(20)) AS "Description",
            TO_CHAR(INV.StockQty, '99,999') AS "StkQty"
FROM        CUSTOMERS C
FULL JOIN   ORDERS O ON C.CustID = O.CustID
FULL JOIN   ORDERITEMS OI ON O.OrderID = OI.OrderID
FULL JOIN   INVENTORY INV ON OI.PartID = INV.PartID
WHERE       C.CustID = 79
AND         O.OrderID = 8879
ORDER BY    OI.DETAIL ASC;

--@SalesDBreset
-- SELECT * FROM ORDERITEMS;

/*
End of Testing
*/