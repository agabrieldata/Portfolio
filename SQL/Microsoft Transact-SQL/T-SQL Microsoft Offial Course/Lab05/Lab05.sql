-- Lab05

/* Challenge 1: Retrieve Product Information
Your reports are returning the correct records, but you would like to modify how these records are
displayed. */



/* 1. Retrieve the name and approximate weight of each product
Write a query to return the product ID of each product, together with the product name formatted as
upper case and a column named ApproxWeight with the weight of each product rounded to the nearest
whole unit.*/


SELECT ProductID, UPPER(Name), ROUND(Weight,0) AS ApproxWeight FROM SalesLT.Product;

/* 2. Retrieve the year and month in which products were first sold
Extend your query to include columns named SellStartYear and SellStartMonth containing the year and
month in which Adventure Works started selling each product. The month should be displayed as the
month name (for example, ‘January’).*/

SELECT ProductID, UPPER(Name), ROUND(Weight,0) AS ApproxWeight, DATENAME(month, SellStartDate) AS SellStartMonth, YEAR(SellStartDate) AS SellStartYear
FROM SalesLT.Product;

/* 3. Extract product types from product numbers
Extend your query to include a column named ProductType that contains the leftmost two characters
from the product number.*/

SELECT ProductID, UPPER(Name), ROUND(Weight,0) AS ApproxWeight, DATENAME(month, SellStartDate) AS SellStartMonth, YEAR(SellStartDate) AS SellStartYear, LEFT(ProductNumber,2) AS ProductType
FROM SalesLT.Product;

SELECT * FROM SalesLT.Product

/* 4. Retrieve only products with a numeric size
Extend your query to filter the product returned so that only products with a numeric size are included.*/

SELECT ProductID, UPPER(Name), ROUND(Weight,0) AS ApproxWeight, DATENAME(month, SellStartDate) AS SellStartMonth, YEAR(SellStartDate) AS SellStartYear, LEFT(ProductNumber,2) AS ProductType, Size
FROM SalesLT.Product
WHERE Size LIKE '%[0-9]%';
--OR
SELECT ProductID, UPPER(Name), ROUND(Weight,0) AS ApproxWeight, DATENAME(month, SellStartDate) AS SellStartMonth, YEAR(SellStartDate) AS SellStartYear, LEFT(ProductNumber,2) AS ProductType, Size
FROM SalesLT.Product
WHERE ISNUMERIC(Size) =1


/*Challenge 2: Rank Customers by Revenue
The sales manager would like a list of customers ranked by sales.*/

SELECT c.FirstName, c.CustomerID,oh.TotalDue, RANK() OVER (ORDER BY oh.TotalDue desc) AS TotalRevenue FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID=oh.CustomerID

/* 1. Retrieve companies ranked by sales totals
Write a query that returns a list of company names with a ranking of their place in a list of highest
TotalDue values from the SalesOrderHeader table.*/

SELECT c.CompanyName, oh.TotalDue, RANK () OVER (ORDER BY oh.TotalDue DESC) AS Ranking FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID

/* Challenge 3: Aggregate Product Sales
The product manager would like aggregated information about product sales.
Tip: Review the documentation for the GROUP BY clause in the Transact-SQL Reference.*/

/* 1. Retrieve total sales by product
Write a query to retrieve a list of the product names and the total revenue calculated as the sum of the
LineTotal from the SalesLT.SalesOrderDetail table, with the results sorted in descending order of total
revenue.*/

SELECT p.Name, SUM(so.LineTotal) AS LineTotal FROM SalesLT.Product AS p
JOIN SalesLT.SalesOrderDetail AS so
ON p.ProductID = so.ProductID
GROUP BY p.Name
ORDER BY LineTotal DESC

/* 2. Filter the product sales list to include only products that cost over $1,000
Modify the previous query to include sales totals for products that have a list price of more than $1000.*/

SELECT p.Name, SUM(so.LineTotal) AS LineTotal FROM SalesLT.Product AS p
JOIN SalesLT.SalesOrderDetail AS so
ON p.ProductID = so.ProductID
WHERE so.UnitPrice > 1000
GROUP BY p.Name
ORDER BY LineTotal DESC

/* 3. Filter the product sales groups to include only total sales over $20,000*/

SELECT p.Name, SUM(so.LineTotal) AS LineTotal FROM SalesLT.Product AS p
JOIN SalesLT.SalesOrderDetail AS so
ON p.ProductID = so.ProductID
GROUP BY p.Name
HAVING SUM(so.LineTotal) > 20000
ORDER BY LineTotal DESC

