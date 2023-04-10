/*

SharkAttacks Data Cleaning

*/

SELECT * FROM [dbo].[SharkAttacks]

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete empty rows 
-- (19,422 rows with no data)

SELECT * 
FROM [dbo].[SharkAttacks]
WHERE [Date] IS NULL
OR [Case_Number] IS NULL

DELETE FROM [dbo].[SharkAttacks]
WHERE [Date] IS NULL
OR [Case_Number] IS NULL
OR [Type] IS NULL
OR [Activity] IS NULL
OR [Age] IS NULL
OR [Time] IS NULL
OR [Location] IS NULL
OR [Name] IS NULL
OR [Area] IS NULL
OR [Injury] IS NULL

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT [Date]
FROM [dbo].[SharkAttacks]
WHERE ISDATE([Date]) = 0

--8 rows with incorrect format (%Reported dd-mm-yyy%)
SELECT [Date] FROM [dbo].[SharkAttacks]
WHERE [Date] like '%report%'

SELECT REPLACE([Date], 'reported', '')
FROM [dbo].[SharkAttacks] 
WHERE [Date] like '%report%'

UPDATE [dbo].[SharkAttacks]
SET [Date] = REPLACE([Date], 'reported', '')
WHERE [Date] like '%report%'

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Standardize Year Format

SELECT [Year]
FROM [dbo].[SharkAttacks]
WHERE ISDATE([Year]) = 0

-- 6 rows with incorrect year format
SELECT [Year], [Date], [Case_Number], [Name]
FROM [dbo].[SharkAttacks]
WHERE ISDATE([Year]) = 0

SELECT [Year], 
       CASE 
           WHEN ISDATE([Year]) = 0 THEN NULL
           ELSE YEAR(CONVERT(DATE, [Date], 103))
       END AS [Year]
FROM [dbo].[SharkAttacks]

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Rename data in Type Column from Boat to Boating 

SELECT DISTINCT [Type] FROM [dbo].[SharkAttacks]

UPDATE [dbo].[SharkAttacks]
SET [Type]='Boating'
WHERE [Type]='Boat'

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Update incorrect data in 'Fatal_y_n' to 'null'

SELECT DISTINCT [Fatal_Y_N] FROM [dbo].[SharkAttacks]

UPDATE [dbo].[SharkAttacks]
SET [Fatal_Y_N] = NULL
WHERE [Fatal_Y_N]<>'Y' AND [Fatal_Y_N]<>'N'

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Replace the gender details in Name column to 'Unknown'

-- Find the rows contain gender details in the Name column
-- (160 rows with gender details)

SELECT DISTINCT [Name] FROM [dbo].[SharkAttacks]

SELECT [Name] FROM [dbo].[SharkAttacks]
WHERE [Name] IN ('boy','girl','male','female')

SELECT [Name],[Sex] FROM [dbo].[SharkAttacks]
WHERE [Name] IN ('boy','girl','male','female')
ORDER BY [Sex]

UPDATE [dbo].[SharkAttacks]
SET [Name]= 'Unknown'
WHERE [Name] IN ('boy','girl','male','female')

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove extra spaces in Name column

SELECT TRIM([Name]) FROM [dbo].[SharkAttacks]

UPDATE [dbo].[SharkAttacks]
SET [Name]=TRIM([Name])

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Replace Null/blanks rows in Species column to 'Unknown'
-- (730 rows with null/blank data)

SELECT [Species] FROM [dbo].[SharkAttacks]
WHERE [Species] =' '
OR [Species] IS NULL

UPDATE [dbo].[SharkAttacks]
SET [Species]='Unknown'
WHERE [Species] =' '
OR [Species] IS NULL

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Update FATAL to Fatal in Injury column
-- (172 rows with UPPERCASE)

SELECT [Injury] FROM [dbo].[SharkAttacks]
WHERE [Injury] = 'FATAL'

UPDATE [dbo].[SharkAttacks]
SET [Injury]='Fatal'
WHERE [Injury]='FATAL'

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Rename Fatal_Y_N column to Fatal
sp_rename '[dbo].[SharkAttacks].[Fatal_Y_N]', 'Fatal', 'COLUMN'

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Rename Sex Column to Gender
sp_rename '[dbo].[SharkAttacks].[Sex]', 'Gender', 'COLUMN'

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Wrangling Country column, changing values from UPPER to Proper Case

SELECT CONCAT(UPPER(SUBSTRING([Country],1,1)), lower(SUBSTRING([Country],2,LEN([Country])))) AS Country01 FROM [dbo].[SharkAttacks]

UPDATE [dbo].[SharkAttacks]
SET [Country]=CONCAT(UPPER(SUBSTRING([Country],1,1)), lower(SUBSTRING([Country],2,LEN([Country]))))

SELECT [Country] FROM [dbo].[SharkAttacks]

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Wrangling Time column

SELECT [Time] FROM [dbo].[SharkAttacks]

SELECT [Time], SUBSTRING([Time],1,2),
CASE
	WHEN SUBSTRING([Time],1,2)<'04' THEN 'Pre-dawn'
	WHEN SUBSTRING([Time],1,2)>='04' AND SUBSTRING([Time],1,2)<'07' THEN 'Early Morning'
	WHEN SUBSTRING([Time],1,2)>='07' AND SUBSTRING([Time],1,2)<'10' THEN 'Morning'
	WHEN SUBSTRING([Time],1,2)>='10' AND SUBSTRING([Time],1,2)<'12' THEN 'Early Noon'
	WHEN SUBSTRING([Time],1,2)>='12' AND SUBSTRING([Time],1,2)<'13' THEN 'Noon'
	WHEN SUBSTRING([Time],1,2)>='13' AND SUBSTRING([Time],1,2)<'15' THEN 'Afternoon'
	WHEN SUBSTRING([Time],1,2)>='15' AND SUBSTRING([Time],1,2)<'16' THEN 'Early Evening'
	WHEN SUBSTRING([Time],1,2)>='16' AND SUBSTRING([Time],1,2)<'18' THEN 'Evening'
	WHEN SUBSTRING([Time],1,2)>='18' AND SUBSTRING([Time],1,2)<'20' THEN 'Late Evening'
	WHEN SUBSTRING([Time],1,2)>='20' AND SUBSTRING([Time],1,2)<'22' THEN 'Night'
	WHEN SUBSTRING([Time],1,2)>='22' THEN 'Late Night'
	ELSE [Time]
END AS Attack_Time
FROM [dbo].[SharkAttacks]
ORDER BY Attack_Time

UPDATE [dbo].[SharkAttacks]
SET [Time]= (CASE
	WHEN SUBSTRING([Time],1,2)<'04' THEN 'Pre-dawn'
	WHEN SUBSTRING([Time],1,2)>='04' AND SUBSTRING([Time],1,2)<'07' THEN 'Early Morning'
	WHEN SUBSTRING([Time],1,2)>='07' AND SUBSTRING([Time],1,2)<'10' THEN 'Morning'
	WHEN SUBSTRING([Time],1,2)>='10' AND SUBSTRING([Time],1,2)<'12' THEN 'Early Noon'
	WHEN SUBSTRING([Time],1,2)>='12' AND SUBSTRING([Time],1,2)<'13' THEN 'Noon'
	WHEN SUBSTRING([Time],1,2)>='13' AND SUBSTRING([Time],1,2)<'15' THEN 'Afternoon'
	WHEN SUBSTRING([Time],1,2)>='15' AND SUBSTRING([Time],1,2)<'16' THEN 'Early Evening'
	WHEN SUBSTRING([Time],1,2)>='16' AND SUBSTRING([Time],1,2)<'18' THEN 'Evening'
	WHEN SUBSTRING([Time],1,2)>='18' AND SUBSTRING([Time],1,2)<'20' THEN 'Late Evening'
	WHEN SUBSTRING([Time],1,2)>='20' AND SUBSTRING([Time],1,2)<'22' THEN 'Night'
	WHEN SUBSTRING([Time],1,2)>='22' THEN 'Late Night'
	ELSE [Time]
END)

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Rename Time column to Attack Time
sp_rename '[dbo].[SharkAttacks].[Time]', 'Attack Time', 'COLUMN'

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT DISTINCT [column23],[column24] FROM [dbo].[SharkAttacks]

ALTER TABLE [dbo].[SharkAttacks]
DROP COLUMN [column23],[column24]
