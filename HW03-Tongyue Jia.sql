-- T1. Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
CREATE VIEW view_product_order_Jia AS 
SELECT a.ProductID Product, SUM(b.Quantity) Total_oredered_quantity
FROM Products a LEFT JOIN [Order Details] b 
ON a.ProductID=b.ProductID
GROUP BY a.ProductID


-- *T2. Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
CREATE PROC sp_product_order_quantity_Jia 
@prod_id INT,
@total_quantity INT OUT
AS 
BEGIN
SELECT @total_quantity=SUM(b.Quantity) 
FROM Products a LEFT JOIN [Order Details] b 
ON a.ProductID=b.ProductID
WHERE a.ProductID=@prod_id
END


BEGIN
DECLARE @total_quantity INT
EXEC sp_product_order_quantity_Jia 2, @total_quantity out
PRINT @total_quantity
END

-- ***T3. Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.
CREATE PROC sp_product_order_city_Jia 
@prod_name VARCHAR(20),
@top5_city VARCHAR(20) OUT,
@total_quantity INT OUT 
AS
BEGIN
SELECT 
FROM [Order Details] a INNER JOIN Orders b ON a.OrderID=b.OrderID 
INNER JOIN Customers c ON b.CustomerID=c.CustomerID 
WHERE a.ProductID=(
    SELECT Distinct ProductID FROM Products WHERE ProductName=@prod_name
)
END

-- T4. Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
CREATE TABLE city_jia (
    Id INT PRIMARY KEY,
    City VARCHAR(20) UNIQUE NOT NULL
)

INSERT INTO city_jia VALUES(1,'Seatle')
INSERT INTO city_jia VALUES(2,'Green Bay')

CREATE TABLE people_jia (
    Id INT PRIMARY KEY,
    Name VARCHAR(20) NOT NULL,
    City INT 
)

INSERT INTO people_jia VALUES(1,'Aaron Rodgers',2)
INSERT INTO people_jia VALUES(2,'Russell Wilson',1)
INSERT INTO people_jia VALUES(3,'Jody Nelson',2)

DELETE FROM city_jia WHERE City='Seatle'

INSERT INTO city_jia VALUES(3,'Madison')

UPDATE people_jia SET City=3 WHERE City=1

CREATE VIEW packers_jia AS 
SELECT a.Name people 
FROM people_jia a LEFT JOIN city_jia b 
ON a.City=b.Id 
WHERE b.City='Green Bay'

SELECT * 
FROM packers_jia

DROP TABLE people_jia
DROP TABLE city_jia
DROP VIEW packers_jia

-- #T5. Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
CREATE PROC sp_birthday_employees_jia
AS
BEGIN
IF OBJECT_ID('birthday_employees_jia','u') IS NOT NULL DROP TABLE birthday_employees_jia
SELECT EmployeeID INTO birthday_employees_jia FROM(
    SELECT EmployeeID
    FROM Employees
    WHERE DATEPART(mm,BirthDate)=2
) a
END

EXEC sp_birthday_employees_jia

SELECT * FROM birthday_employees_jia

DROP TABLE birthday_employees_jia

-- T6. How do you make sure two tables have the same data?
-- By defining constraints when creating tables.

