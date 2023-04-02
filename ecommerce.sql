
--DATA CLEANING & MANIPULATION
--Perform data wrangling and cleaning to clean and transform the dataset

SELECT * FROM [dbo].[ecommerce]

--check if there is any blank/empty rows based on column1 and InvoiceNo column
SELECT * 
FROM [dbo].[ecommerce]
WHERE [column1] IS NULL
OR [InvoiceNo] IS NULL

--to check if there is any duplicate rows
SELECT DISTINCT COUNT(*) FROM [dbo].[ecommerce]

SELECT COUNT(*) FROM [dbo].[ecommerce]

--rename column1 to ProductID
sp_rename '[dbo].[ecommerce].[OrderID]', 'ProductID', 'COLUMN'

SELECT * FROM [dbo].[ecommerce]

--to change colum format for UnitPrice to 0.00
SELECT [UnitPrice], FORMAT([UnitPrice], '0.00') AS unitprice01 FROM [dbo].[ecommerce]

UPDATE [dbo].[ecommerce]
SET [UnitPrice] = FORMAT([UnitPrice], '0.00')

SELECT * FROM [dbo].[ecommerce]

--trim extra spaces in ProductID column
SELECT TRIM([ProductID]) AS trimmed_OrderID FROM [dbo].[ecommerce]

--previous query is error as TRIM function expects its argument to be a string or character expression.
--change the data type from 'int' to 'varchar'
SELECT TRIM(CONVERT(VARCHAR, [ProductID])) AS trimmed_ProductID FROM [dbo].[ecommerce]

UPDATE [dbo].[ecommerce] 
SET [ProductID] = TRIM(CONVERT(VARCHAR, [ProductID]))

SELECT * FROM [dbo].[ecommerce]

--add in Sales column = quantity * unit price
ALTER TABLE [dbo].[ecommerce] ADD sales int;

UPDATE [dbo].[ecommerce] 
SET [sales] = [Quantity] * [UnitPrice]

SELECT * FROM [dbo].[ecommerce]

--check transformed data
SELECT * FROM [dbo].[ecommerce]

