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
