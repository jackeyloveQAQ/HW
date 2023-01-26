--1.How many products can you find in the Production.Product table?
SELECT DISTINCT *
FROM Production.Product
PRINT @@ROWCOUNT;
/*
3.How many Products reside in each SubCategory? Write a query to display the results with the following titles.
ProductSubcategoryID CountedProducts
*/
SELECT ProductSubcategoryID,COUNT(*) CountedProducts
FROM Production.Product
GROUP BY ProductSubcategoryID;

--4.How many products that do not have a product subcategory.
SELECT *
FROM Production.Product
WHERE ProductSubcategoryID IS NULL
PRINT @@ROWCOUNT;

--5.Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT SUM(Quantity)
FROM Production.ProductInventory;

/*6.Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
ProductID TheSum
*/
SELECT ProductID, SUM(Quantity) TheSum
FROM Production.ProductInventory
WHERE LocationID=40 AND Quantity<100
GROUP BY ProductID;

/*10.Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
ProductID Shelf TheAvg
*/
SELECT ProductID, Shelf, AVG(Quantity) TheAvg
FROM Production.ProductInventory
WHERE Shelf IS NOT NULL
GROUP BY ProductID, Shelf;

/*11.List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
Color Class TheCount AvgPrice
*/

SELECT Color, Class, Count(*) TheCount, AVG(ListPrice) AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class;
/*12.Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
Country Province
*/
SELECT C.Name Country, S.Name Province
FROM Person.CountryRegion C JOIN Person.StateProvince S ON C.CountryRegionCode=S.CountryRegionCode;
/*
13.  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
Country Province
*/
SELECT C.Name Country, S.Name Province
FROM Person.CountryRegion C JOIN Person.StateProvince S ON C.CountryRegionCode=S.CountryRegionCode
WHERE C.Name='Germany' or C.Name='Canada';
--15.List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 ShipPostalCode
FROM Orders
GROUP BY ShipPostalCode
ORDER BY Count(*) DESC;

--17.List all city names and number of customers in that city.     
SELECT City, Count(*) NumberOfCustomers
FROM Customers
GROUP BY CITY;
--18.List city names which have more than 2 customers, and number of customers in that city
SELECT City, Count(*) NumberOfCustomers
FROM Customers
GROUP BY CITY HAVING Count(*)>2;
--19.List the names of customers who placed orders after 1/1/98 with order date.
SELECT C.ContactName, O.OrderDate
FROM Orders O Join Customers C ON O.CustomerID=C.CustomerID
WHERE O.OrderDate>CONVERT(DATETIME, '1/1/98');

--20.List the names of all customers with most recent order dates
SELECT C.ContactName, MAX(O.OrderDate)
FROM Orders O RIGHT Join Customers C ON O.CustomerID=C.CustomerID
GROUP BY C.CustomerID,C.ContactName;

/*23.List all of the possible ways that suppliers can ship their products. Display the results as below
Supplier Company Name Shipping Company Name
*/
SELECT DISTINCT S.CompanyName,SH.CompanyName
FROM Orders O Join Shippers SH ON O.ShipVia=SH.ShipperID
Join [Order Details] OD ON O.OrderID=OD.OrderID
Join Products P ON OD.ProductID=P.ProductID
Join Suppliers S ON S.SupplierID=P.SupplierID;
--26.Display all the Managers who have more than 2 employees reporting to them.
SELECT M.EmployeeID,M.Title,M.LastName,M.FirstName
FROM Employees M JOIN Employees E ON M.EmployeeID=E.ReportsTo
WHERE M.Title LIKE '%Manager%'
GROUP BY M.EmployeeID,M.Title,M.LastName,M.FirstName HAVING COUNT(*)>2;