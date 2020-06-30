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
