--This Query is a compilation of all the Labs necessary to pass the Transact-SQL Microsoft Course.

--Lab01
/* Adventure Works Cycles sells directly to retailers, who then sell products to consumers. Each retailer
that is an Adventure Works customer has provided a named contact for all communication from
Adventure Works. The sales manager at Adventure Works has asked you to generate some reports
containing details of the company’s customers to support a direct sales campaign. */

/* Familiarize yourself with the Customer table by writing a Transact-SQL query that retrieves all columns
for all customers. */

SELECT * from SalesLT.Customer;

/* Create a list of all customer contact names that includes the title, first name, middle name (if any), last
name, and suffix (if any) of all customers.*/

SELECT Title, FirstName, ISNULL(MiddleName,'N/A'), LastName, ISNULL(Suffix,'N/A') from SalesLT.Customer;

/* Each customer has an assigned salesperson. You must write a query to create a call sheet that lists:
 The salesperson
 A column named CustomerName that displays how the customer contact should be greeted (for
example, “Mr Smith”)
 The customer’s phone number. */

SELECT SalesPerson, CONCAT(Title+' ',LastName), Phone FROM SalesLT.Customer;

/* As you continue to work with the Adventure Works customer data, you must create queries for reports
that have been requested by the sales team */

/* You have been asked to provide a list of all customer companies in the format <Customer ID> :
<Company Name> - for example, 78: Preferred Bikes. */

SELECT CONCAT(CustomerID,': ', CompanyName) As 'CustomerID: CompanyName' FROM SalesLT.Customer;

/* The SalesLT.SalesOrderHeader table contains records of sales orders. You have been asked to retrieve
data for a report that shows:
 The sales order number and revision number in the format <Order Number> (<Revision>) – for
example SO71774 (2).
 The order date converted to ANSI standard format (yyyy.mm.dd – for example 2015.01.31). */

/* 1 */

SELECT CONCAT(SalesOrderNumber,'      (',RevisionNumber,')') AS '<Order Number> (<Revision>)' FROM SalesLT.SalesOrderHeader;
/* 2 */

SELECT CAST(OrderDate AS date) FROM SalesLT.SalesOrderHeader;  

/* Some records in the database include missing or unknown values that are returned as NULL. You must
create some queries that handle these NULL fields appropriately.*/



/*You have been asked to write a query that returns a list of customer names. The list must consist of a
single field in the format <first name> <last name> (for example Keith Harris) if the middle name is
unknown, or <first name> <middle name> <last name> (for example Jane M. Gates) if a middle name is
stored in the database.*/


SELECT CONCAT(FirstName,'',ISNULL(MiddleName,' '),'',LastName) AS 'Complete Name' FROM SalesLT.Customer;

/*Customers may provide adventure Works with an email address, a phone number, or both. If an email
address is available, then it should be used as the primary contact method; if not, then the phone
number should be used. You must write a query that returns a list of customer IDs in one column, and a
second column named PrimaryContact that contains the email address if known, and otherwise the
phone number.*/

SELECT CustomerID, COALESCE(EmailAddress,Phone) AS 'Primary Contact' FROM SalesLT.Customer;

/*You have been asked to create a query that returns a list of sales order IDs and order dates with a
column named ShippingStatus that contains the text “Shipped” for orders with a known ship date, and
“Awaiting Shipment” for orders with no ship date.*/


SELECT SalesOrderID, CASE
					WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
					ELSE 'Shipped'
					END AS 'Shipping Status'
FROM SalesLT.SalesOrderHeader;

-- Lab02 - Querying with Transact-SQL

/* Challenge 1: Retrieve Data for Transportation Reports
The logistics manager at Adventure Works has asked you to generate some reports containing details of
the company’s customers to help to reduce transportation costs.

1. Retrieve a list of cities
Initially, you need to produce a list of all of your customers' locations. Write a Transact-SQL query that
queries the Address table and retrieves all values for City and StateProvince, removing duplicates.*/

SELECT DISTINCT City, StateProvince FROM SalesLT.Address;

/* 2. Retrieve the heaviest products
Transportation costs are increasing and you need to identify the heaviest products. Retrieve the names
of the top ten percent of products by weight.*/

SELECT * FROM SalesLT.Product;

SELECT TOP (10) PERCENT Name, ProductNumber, Weight FROM SalesLT.Product 
ORDER BY Weight desc;


/*3. Retrieve the heaviest 100 products not including the heaviest ten
The heaviest ten products are transported by a specialist carrier, therefore you need to modify the
previous query to list the heaviest 100 products not including the heaviest ten. */

SELECT Name, ProductNumber, Weight FROM SalesLT.Product 
ORDER BY Weight desc
OFFSET 10 ROWS
FETCH NEXT 100 ROWS ONLY;


/* Challenge 2: Retrieve Product Data
The Production Manager at Adventure Works would like you to create some reports listing details of the
products that you sell.*/

/*1. Retrieve product details for product model 1
Initially, you need to find the names, colors, and sizes of the products with a product model ID 1.*/

SELECT Name,Color,Size FROM SalesLT.Product
	WHERE ProductModelID=1;

/*2. Filter products by color and size
Retrieve the product number and name of the products that have a color of 'black', 'red', or 'white' and
a size of 'S' or 'M'.*/

SELECT ProductNumber,Name FROM SalesLT.Product
WHERE (Color = 'Black' OR Color ='Red' OR Color= 'White')
AND (Size = 'S' OR Size='M');


/*3. Filter products by product number
Retrieve the product number, name, and list price of products whose product number begins 'BK-'.*/

SELECT ProductNumber,Name,ListPrice FROM SalesLT.Product
	WHERE ProductNumber LIKE  'BK%';


/*4. Retrieve specific products by product number
Modify your previous query to retrieve the product number, name, and list price of products whose
product number begins 'BK-' followed by any character other than 'R’, and ends with a '-' followed by
any two numerals.*/

SELECT ProductNumber,Name,ListPrice FROM SalesLT.Product
	WHERE ProductNumber LIKE  'BK-%' AND ProductNumber NOT LIKE '___R%';

-- Lab03

/* Challenge 1: Generate Invoice Reports
Adventure Works Cycles sells directly to retailers, who must be invoiced for their orders. You have been
tasked with writing a query to generate a list of invoices to be sent to customers.*/

/* 1. Retrieve customer orders
As an initial step towards generating the invoice report, write a query that returns the company name
from the SalesLT.Customer table, and the sales order ID and total due from the
SalesLT.SalesOrderHeader table.*/

SELECT c.CompanyName, oh.SalesOrderID, oh.TotalDue 
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID=oh.CustomerID
;

/* 2. Retrieve customer orders with addresses
Extend your customer orders query to include the Main Office address for each customer, including the
full street address, city, state or province, postal code, and country or region */

SELECT c.CompanyName, oh.SalesOrderID, oh.TotalDue, ca.AddressID, ad.AddressLine1, ad.City, ad.StateProvince, ad.CountryRegion, ad.PostalCode
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID=oh.CustomerID
JOIN SalesLT.CustomerAddress AS ca
ON ca.CustomerID=c.CustomerID
JOIN SalesLT.Address AS ad
ON ca.AddressID=ad.AddressID;

/* Challenge 2: Retrieve Sales Data
As you continue to work with the Adventure Works customer and sales data, you must create queries
for reports that have been requested by the sales team. */


/*1. Retrieve a list of all customers and their orders
The sales manager wants a list of all customer companies and their contacts (first name and last name),
showing the sales order ID and total due for each order they have placed. Customers who have not
placed any orders should be included at the bottom of the list with NULL values for the order ID and
total due. */

SELECT c.FirstName,c.LastName,c.CompanyName,sh.SalesOrderID,sh.TotalDue 
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS sh
ON c.CustomerID=sh.CustomerID
ORDER BY SalesOrderID desc;

/*2. Retrieve a list of customers with no address
A sales employee has noticed that Adventure Works does not have address information for all
customers. You must write a query that returns a list of customer IDs, company names, contact names
(first name and last name), and phone numbers for customers with no address stored in the database. */

SELECT c.CustomerID,c.CompanyName,c.FirstName,c.LastName,c.Phone FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
WHERE ca.CustomerID IS NULL;


/*3. Retrieve a list of customers and products without orders
Some customers have never placed orders, and some products have never been ordered. Create a query
that returns a column of customer IDs for customers who have never placed an order, and a column of
product IDs for products that have never been ordered. Each row with a customer ID should have a
NULL product ID (because the customer has never ordered a product) and each row with a product ID
should have a NULL customer ID (because the product has never been ordered by a customer). */

SELECT c.CustomerID, p.ProductID
FROM SalesLT.Customer AS c
	
	FULL JOIN SalesLT.SalesOrderHeader AS oh -- Para que puedan aparecer los que son nulos, el join tiene que ser completo.
	ON c.CustomerID = oh.CustomerID

	FULL JOIN SalesLT.SalesOrderDetail AS od
	ON od.SalesOrderID = oh.SalesOrderID

	FULL JOIN SalesLT.Product AS p
	ON p.ProductID = od.ProductID
	WHERE oh.SalesOrderID IS NULL

ORDER BY ProductID, CustomerID;

-- Lab04

/*Customers can have two kinds of address: a main office address and a shipping address. The accounts
department want to ensure that the main office address is always used for billing, and have asked you to
write a query that clearly identifies the different types of address for each customer. */


/*1. Retrieve billing addresses
Write a query that retrieves the company name, first line of the street address, city, and a column
named AddressType with the value ‘Billing’ for customers where the address type in the
SalesLT.CustomerAddress table is ‘Main Office’.*/


SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType FROM SalesLT.CustomerAddress as ca
JOIN SalesLT.Customer AS c
ON ca.CustomerID = c.CustomerID
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'


/*2. Retrieve shipping addresses
Write a similar query that retrieves the company name, first line of the street address, city, and a
column named AddressType with the value ‘Shipping’ for customers where the address type in the
SalesLT.CustomerAddress table is ‘Shipping’.*/

SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping' AS AddressType FROM SalesLT.CustomerAddress as ca
JOIN SalesLT.Customer AS c
ON ca.CustomerID = c.CustomerID
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Shipping'



/*3. Combine billing and shipping addresses
Combine the results returned by the two queries to create a list of all customer addresses that is sorted
by company name and then address type.*/

SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType FROM SalesLT.CustomerAddress as ca
JOIN SalesLT.Customer AS c
ON ca.CustomerID = c.CustomerID
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'
UNION
SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping' AS AddressType FROM SalesLT.CustomerAddress as ca
JOIN SalesLT.Customer AS c
ON ca.CustomerID = c.CustomerID
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Shipping'
ORDER BY CompanyName,AddressType

/*Challenge 2: Filter Customer Addresses
You have created a master list of all customer addresses, but now you have been asked to create filtered
lists that show which customers have only a main office address, and which customers have both a main
office and a shipping address.*/


/*1. Retrieve customers with only a main office address
Write a query that returns the company name of each company that appears in a table of customers
with a ‘Main Office’ address, but not in a table of customers with a ‘Shipping’ address.*/

SELECT c.CompanyName FROM SalesLT.CustomerAddress as ca
JOIN SalesLT.Customer AS c
ON ca.CustomerID = c.CustomerID
WHERE ca.AddressType = 'Main Office'
EXCEPT
SELECT c.CompanyName FROM SalesLT.CustomerAddress as ca
JOIN SalesLT.Customer AS c
ON ca.CustomerID = c.CustomerID
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName


/*2. Retrieve only customers with both a main office address and a shipping address
Write a query that returns the company name of each company that appears in a table of customers
with a ‘Main Office’ address, and also in a table of customers with a ‘Shipping’ address.*/

-- There are multiple ways of dealing with this problem :

-- Number 1

SELECT c.CompanyName FROM SalesLT.Customer AS c
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
GROUP BY c.CompanyName
HAVING count(distinct ca.AddressType) =2

-- Number 2

SELECT c.CompanyName FROM SalesLT.CustomerAddress as ca
JOIN SalesLT.Customer AS c
ON ca.CustomerID = c.CustomerID
WHERE ca.AddressType = 'Main Office'
INTERSECT
SELECT c.CompanyName FROM SalesLT.CustomerAddress as ca
JOIN SalesLT.Customer AS c
ON ca.CustomerID = c.CustomerID
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName

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

--Lab06

/* Challenge 1: Retrieve Product Price Information
Adventure Works products each have a standard cost price that indicates the cost of manufacturing the
product, and a list price that indicates the recommended selling price for the product. This data is stored
in the SalesLT.Product table. Whenever a product is ordered, the actual unit price at which it was sold is
also recorded in the SalesLT.SalesOrderDetail table. You must use subqueries to compare the cost and
list prices for each product with the unit prices charged in each sale.*/



/*1. Retrieve products whose list price is higher than the average unit price
Retrieve the product ID, name, and list price for each product where the list price is higher than the
average unit price for all products that have been sold. */

SELECT p.ProductID, p.Name, p.ListPrice FROM SalesLT.Product AS p
	WHERE p.ListPrice > (SELECT AVG(sod.LineTotal) FROM SalesLT.SalesOrderDetail AS sod)

/*2. Retrieve Products with a list price of $100 or more that have been sold for less than
$100*/
/*Retrieve the product ID, name, and list price for each product where the list price is $100 or more, and
the product has been sold for less than $100.*/

SELECT p.ProductID, p.name FROM SalesLT.Product AS p
WHERE p.ProductID IN 
(SELECT sod.ProductID FROM SalesLT.SalesOrderDetail AS sod WHERE sod.LineTotal/sod.OrderQty < 100)
AND p.ListPrice >= 100



/*3. Retrieve the cost, list price, and average selling price for each product.
Retrieve the product ID, name, cost, and list price for each product along with the average unit price for
which that product has been sold.*/

SELECT p.ProductID, p.Name, p.StandardCost, p.ListPrice, 
		(SELECT AVG(sod.UnitPrice)
		FROM SalesLT.SalesOrderDetail as sod
		WHERE p.ProductID = sod.ProductID) AS Promedio
FROM SalesLT.Product as p

/*4. Retrieve products that have an average selling price that is lower than the cost.
Filter your previous query to include only products where the cost price is higher than the average
selling price.*/

SELECT p.ProductID, p.Name, p.StandardCost, p.ListPrice, 
		(SELECT AVG(sod.UnitPrice)
		FROM SalesLT.SalesOrderDetail as sod
		WHERE p.ProductID = sod.ProductID) AS Promedio
FROM SalesLT.Product as p
WHERE p.StandardCost > (SELECT AVG(sod.UnitPrice)
						FROM SalesLT.SalesOrderDetail as sod
						WHERE p.ProductID = sod.ProductID)

/*Challenge 2: Retrieve Customer Information
The AdventureWorksLT database includes a table-valued user-defined function named
dbo.ufnGetCustomerInformation. You must use this function to retrieve details of customers based on
customer ID values retrieved from tables in the database.*/

/*1. Retrieve customer information for all sales orders.
Retrieve the sales order ID, customer ID, first name, last name, and total due for all sales orders from
the SalesLT.SalesOrderHeader table and the dbo.ufnGetCustomerInformation function.*/



SELECT soh.SalesOrderID, soh.CustomerID, soh.TotalDue, d.FirstName, d.LastName
FROM SalesLT.SalesOrderHeader as soh
	CROSS APPLY dbo.ufnGetCustomerInformation((
		SELECT c.CustomerID
		FROM SalesLT.Customer as c
		WHERE soh.CustomerID = c.CustomerID)) as d
--OR 

SELECT SOH.SalesOrderID, SOH.CustomerID, CI.FirstName, CI.LastName, SOH.TotalDue
FROM SalesLT.SalesOrderHeader AS SOH
	CROSS APPLY dbo.ufnGetCustomerInformation(SOH.CustomerID) AS CI
ORDER BY SOH.SalesOrderID;

/*2. Retrieve customer address information.
Retrieve the customer ID, first name, last name, address line 1 and city for all customers from the
SalesLT.Address and SalesLT.CustomerAddress tables, and the dbo.ufnGetCustomerInformation
function.*/

SELECT ca.CustomerID, f.FirstName, f.LastName, a.AddressLine1, a.City
FROM SalesLT.CustomerAddress AS ca
JOIN SalesLT.Address AS a
ON ca.AddressID=a.AddressID
	CROSS APPLY dbo.ufnGetCustomerInformation(ca.CustomerID) as f

--Lab07

/* Challenge 1: Retrieve Product Information
Adventure Works sells many products that are variants of the same product model. You must write
queries that retrieve information about these products*/

/*1. Retrieve product model descriptions
Retrieve the product ID, product name, product model name, and product model summary for each
product from the SalesLT.Product table and the SalesLT.vProductModelCatalogDescription view.*/

SELECT p.ProductID, p.Name, v.Name, v.Summary FROM SalesLT.Product as p, SalesLT.vProductModelCatalogDescription AS v
ORDER BY ProductID

/*2. Create a table of distinct colors

Create a table variable and populate it with a list of distinct colors from the SalesLT.Product table. Then
use the table variable to filter a query that returns the product ID, name, and color from the
SalesLT.Product table so that only products with a color listed in the table variable are returned.*/

DECLARE @Colores AS TABLE
(
Color NVARCHAR(15)
)
INSERT INTO @Colores(Color)
SELECT DISTINCT Color FROM SalesLT.Product
WHERE Color IS NOT NULL

SELECT p.ProductID, p.Name, p.Color FROM SalesLT.Product as p
JOIN @Colores as c
ON c.Color = p.Color
ORDER BY Color

/*3. Retrieve product parent categories

The AdventureWorksLT database includes a table-valued function named dbo.ufnGetAllCategories,
which returns a table of product categories (for example ‘Road Bikes’) and parent categories (for
example ‘Bikes’). Write a query that uses this function to return a list of all products including their
parent category and category.*/

SELECT d.ParentProductCategoryName, d.ProductCategoryName, p.*  FROM SalesLT.Product as p
JOIN dbo.ufnGetAllCategories() as d
ON p.ProductCategoryID=d.ProductCategoryID

--Lab08

/* Challenge 1: Retrieve Regional Sales Totals
Adventure Works sells products to customers in multiple country/regions around the world */

/*1. Retrieve totals for country/region and state/province
An existing report uses the following query to return total sales revenue grouped by country/region and
state/province.
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY a.CountryRegion, a.StateProvince
ORDER BY a.CountryRegion, a.StateProvince;
You have been asked to modify this query so that the results include a grand total for all sales revenue
and a subtotal for each country/region in addition to the state/province subtotals that are already
returned.*/

SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;



/*2. Indicate the grouping level in the results

Modify your query to include a column named Level that indicates at which level in the total,
country/region, and state/province hierarchy the revenue figure in the row is aggregated. For example,
the grand total row should contain the value ‘Total’, the row showing the subtotal for United States
should contain the value ‘United States Subtotal’, and the row showing the subtotal for California should
contain the value ‘California Subtotal’.*/

SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue,
CASE
	WHEN CountryRegion IS NULL AND StateProvince IS NULL THEN 'GrandTotal'
	WHEN CountryRegion ='United Kingdom' AND StateProvince IS NULL THEN 'United Kingdom Subtotal'
	WHEN CountryRegion='United States' AND StateProvince IS NULL THEN 'United States Subtotal'
	ELSE a.StateProvince + ' SubTotal'
	END AS Level
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;	


/*3. Add a grouping level for cities
Extend your query to include a grouping for individual cities. */

SELECT a.CountryRegion, a.StateProvince, a.City, SUM(soh.TotalDue) AS Revenue,
CASE
	WHEN CountryRegion IS NULL AND StateProvince IS NULL THEN 'GrandTotal'
	WHEN CountryRegion ='United Kingdom' AND StateProvince IS NULL THEN 'United Kingdom Subtotal'
	WHEN CountryRegion='United States' AND StateProvince IS NULL THEN 'United States Subtotal'
	ELSE a.StateProvince + ' SubTotal'
	END AS Level
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince, a.City)
ORDER BY a.CountryRegion, a.StateProvince, a.City;

/* Challenge 2: Retrieve Customer Sales Revenue by Category

Adventure Works products are grouped into categories, which in turn have parent categories (defined in
the SalesLT.vGetAllCategories view). Adventure Works customers are retail companies, and they may
place orders for products of any category. The revenue for each product in an order is recorded as the
LineTotal value in the SalesLT.SalesOrderDetail table.*/

/*1. Retrieve customer sales revenue for each parent category

Retrieve a list of customer company names together with their total revenue for each parent category in
Accessories, Bikes, Clothing, and Components. */

SELECT c.CompanyName, sod.LineTotal, v.ParentProductCategoryName FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader as soh
ON c.CustomerID=soh.CustomerID
JOIN SalesLT.SalesOrderDetail AS sod
ON soh.SalesOrderID=sod.SalesOrderID
JOIN SalesLT.Product AS p
ON p.ProductID=sod.ProductID
JOIN SalesLT.vGetAllCategories as v
ON p.ProductCategoryID = v.ProductCategoryID
GROUP BY ROLLUP(c.CompanyName, v.ParentProductCategoryName, sod.LineTotal)
ORDER BY CompanyName, ParentProductCategoryName
