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
