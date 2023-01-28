--3.List all products and their total order quantities throughout all orders.
SELECT P.ProductID, P.ProductName, SUM(OD.Quantity) Total_Quantities
FROM Products P
LEFT JOIN [Order Details] OD ON P.ProductID=OD.ProductID
GROUP BY P.ProductID, P.ProductName;

--4.List all Customer Cities and total products ordered by that city.
SELECT C.City, COUNT(DISTINCT OD.ProductID) [Number of Unique Products], COUNT(OD.ProductID) [Number of All Products],SUM(OD.Quantity) [Total Quantities]
FROM Customers C 
LEFT JOIN Orders O ON C.CustomerID=O.CustomerID 
LEFT JOIN [Order Details] OD ON O.OrderID=OD.OrderID
GROUP BY C.City
ORDER BY C.City;

--5.List all Customer Cities that have at least two customers.
--a.Use union
SELECT C.City
FROM Customers C
GROUP BY City HAVING COUNT(*) >=2;
--b.Use sub-query and no union
WITH temp_table as(SELECT DISTINCT C1.City, (SELECT Count(*)FROM Customers C2 WHERE C1.City=C2.City) cnt
FROM Customers C1)
SELECT * FROM temp_table WHERE cnt>=2;

--8.List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
--USE 3 CTE avgPrice is not weighted-average
WITH t_table AS(SELECT P.ProductID, P.ProductName, avg((1-OD.Discount)*OD.UnitPrice) OVER(PARTITION BY P.ProductID ORDER BY (SELECT NULL)) avgPrice, SUM(OD.Quantity) OVER(PARTITION BY P.ProductID ORDER BY (SELECT NULL)) Total_Quantities, O.ShipCity, OD.Quantity
FROM Products P LEFT JOIN [Order Details] OD ON OD.ProductID=P.ProductID
LEFT JOIN Orders O ON O.OrderID=OD.OrderID),
tt_table(ProductID,City,avg_price,T_Q, S_Q) AS (SELECT ProductID,ShipCity,avgPrice, Total_Quantities, SUM(Quantity) FROM t_table GROUP BY ProductID, ShipCity, avgPrice, Total_Quantities),
ttt_table AS(SELECT ProductID, City, T_Q,avg_price,RANK() OVER(PARTITION BY ProductID ORDER BY S_Q DESC) rk FROM tt_table)
SELECT TOP 5 ProductId, City, avg_price
FROM ttt_table
WHERE rk=1
ORDER BY T_Q DESC
;
--ONE CTE+subquery avgPrice is weighted-average
WITH help AS(SELECT P.ProductID,O.ShipCity, SUM(P.UnitPrice*(1-OD.Discount)*Quantity) OVER(PARTITION BY P.ProductID ORDER BY (SELECT NULL))/SUM(OD.Quantity) OVER(PARTITION BY P.ProductID ORDER BY (SELECT NULL)) avgPrice,
SUM(OD.Quantity) OVER(PARTITION BY P.ProductID, O.ShipCity ORDER BY (SELECT NULL)) PerCity, SUM(OD.Quantity) OVER(PARTITION BY P.ProductID ORDER BY (SELECT NULL)) PerProduct
FROM Products P 
LEFT JOIN [Order Details] OD ON OD.ProductID=P.ProductID
LEFT JOIN Orders O ON O.OrderID=OD.OrderID)
SELECT TOP 5 ProductID, avgPrice, ShipCity 
FROM (SELECT ProductID, ShipCity, avgPrice, ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY PerCity DESC) rk, PerProduct 
FROM help) help2
WHERE rk=1
ORDER BY PerProduct DESC;

--9.List all cities that have never ordered something but we have employees there.
--a.Use sub-query
SELECT DISTINCT City 
FROM Employees
WHERE City NOT IN(SELECT ShipCity FROM Orders);
--b.Do not use sub-query
SELECT DISTINCT City
FROM Employees E LEFT JOIN Orders O ON E.City=O.ShipCity
WHERE O.OrderID IS NULL;

--10.  List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is
--, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
WITH A AS(SELECT O.ShipCity, SUM(OD.Quantity) sm, COUNT(DISTINCT O.OrderID) cnt
FROM Orders O JOIN [Order Details] OD ON O.OrderID=OD.OrderID
GROUP BY O.ShipCity)
SELECT ShipCity FROM A WHERE sm = (SELECT MAX(sm) FROM A) AND cnt = (SELECT MAX(cnt) FROM A) 


/*11. How do you remove the duplicates record of a table?
We can use CTE to remove duplicates record:
Assume duplicate table is T and VAL Column has duplicate records
DELETE (SELECT val, ROW_NUMBER()OVER(PARTITION BY VAL ORDER BY (SELECT NULL)) rk FROM T) WHERE rk <> 1
*/

--1.Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
CREATE VIEW view_product_order_hu
AS(
SELECT P.ProductID, P.ProductName, SUM(OD.Quantity) sm
FROM Products P
LEFT JOIN [Order Details] OD ON OD.ProductID=P.ProductID
GROUP BY P.ProductID, P.ProductName
)
--2.Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
CREATE PROC sp_product_order_quantity_hu
(@product_id int,
@t_q int out)
AS
BEGIN
	SELECT @t_q=sm FROM view_product_order_hu WHERE ProductID=@product_id 
END
--3.Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.
CREATE PROC sp_product_order_city_hu
@product_name varchar(40)
AS
BEGIN
	SELECT TOP 5 O.ShipCity, SUM(OD.Quantity) sm
	FROM Products P
	LEFT JOIN [Order Details] OD ON P.ProductID=OD.ProductID
	LEFT JOIN Orders O ON O.OrderID=OD.OrderID
	WHERE P.ProductName=@product_name
	GROUP BY O.ShipCity
	ORDER BY sm
END

--4.Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
CREATE TABLE city_hu(
City_id int PRIMARY KEY,
City varchar(40)
)
CREATE TABLE people_hu(
id int PRIMARY KEY,
Name Varchar(40),
City_id int FOREIGN KEY REFERENCES city_hu(City_id)
)
insert into city_hu values (1,'Seattle'),(2,'Green Bay')
insert into people_hu values (1,'Aaron Rodgers',2),(2,'Russell Wilson',1),(3,'Jody Nelson',2)
SELECT * FROM people_hu
SELECT * FROM city_hu

INSERT city_hu values(3, 'Madison')
UPDATE people_hu SET City_id=3 WHERE City_id=1
DELETE city_hu WHERE City='Seattle'

CREATE VIEW Packers_hu 
AS(
	SELECT id, Name, c.City_id
	FROM people_hu p
	JOIN city_hu c ON p.City_id=c.City_id
	WHERE c.City='Green Bay'
)

--5.Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
CREATE PROC sp_birthday_employees_hu
AS
BEGIN
	CREATE TABLE birthday_employees_hu(
		EmployeeID INT Primary Key NOT NULL,
		LastName nvarchar(20) NOT NULL,
		FirstName nvarchar(10) NOT NULL,
		Title nvarchar(30) Default NULL,
		TitleOfCourtesy nvarchar(25) Default NULL,
		BirthDate datetime Default NULL,
		HireDate datetime Default NULL,
		Address nvarchar(60) Default NULL,
		City nvarchar(15) Default NULL,
		Region nvarchar(15) Default NULL,
		PostalCode nvarchar(10) Default NULL,
		Country nvarchar(15) Default NULL,
		HomePhone nvarchar(24) Default NULL,
		Extension nvarchar(4) Default NULL, 
		Photo image Default NULL,
		Notes ntext Default NULL,
		ReportsTo int Default NULL FOREIGN KEY REFERENCES Employees(EmployeeID),
		PhotoPath nvarchar(255) Default NULL
	)

	INSERT INTO birthday_employees_hu
	SELECT * 
	FROM Employees
	WHERE Month(BirthDate)=2

END
--6.How do you make sure two tables have the same data?
--USE UNION AND COUNT ROW_NUMBERS