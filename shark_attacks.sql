
--Perform data wrangling and cleaning to clean and transform the dataset

SELECT * FROM [dbo].[shark_attacks01]

SELECT * 
FROM [dbo].[shark_attacks01]
WHERE [Date] IS NULL
OR [Case_Number] IS NULL

--Deleting all rows that contain NULLs in any of the column (except 'Species' column)
DELETE FROM [dbo].[shark_attacks01]
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

--Rows with type as 'Invalid'
SELECT * FROM [dbo].[shark_attacks01]
WHERE [Type]='Invalid'

--6 types of shark attacks, two are similar (Boat & Boating). To update Boat to Boating
SELECT DISTINCT [Type] FROM [dbo].[shark_attacks01]

UPDATE [dbo].[shark_attacks01]
SET [Type]='Boating'
WHERE [Type]='Boat'

--There are 419 rows of different activities listed, many are similar or fall in same bucket
SELECT DISTINCT [Activity] FROM [dbo].[shark_attacks01]

--20 rows contain data starting from 'fishing'
--39 rows contain data 'surfing'
--5 rows contain data 'rescue'
SELECT DISTINCT [Activity] FROM [dbo].[shark_attacks01]
WHERE [Activity] like 'fishing%'

SELECT DISTINCT [Activity] FROM [dbo].[shark_attacks01]
WHERE [Activity] like '%surfing%'

SELECT DISTINCT [Activity] FROM [dbo].[shark_attacks01]
WHERE [Activity] like '%rescue%'

--Data in column [Fatal_Y_N] should only have Y / N. Update Incorrect data to UNKNOWN
SELECT DISTINCT [Fatal_Y_N] FROM [dbo].[shark_attacks01]

UPDATE [dbo].[shark_attacks01]
SET [Fatal_Y_N]='UNKNOWN'
WHERE [Fatal_Y_N]<>'Y' AND [Fatal_Y_N]<>'N'

UPDATE [dbo].[shark_attacks01]
SET [Fatal_Y_N]=NULL
WHERE [Fatal_Y_N]= 'UNKNOWN'

--Find the rows contain gender details in the Name column
SELECT DISTINCT [Name] FROM [dbo].[shark_attacks01]

--160 rows contain gender details in Name column
--Compare the details with Sex column to validate the findings. Only 1 row with 'male' in Name column is NULL in Sex column. 
SELECT [Name] FROM [dbo].[shark_attacks01]
WHERE [Name] IN ('boy','girl','male','female')

SELECT [Name],[Sex] FROM [dbo].[shark_attacks01]
WHERE [Name] IN ('boy','girl','male','female')
ORDER BY [Sex]

--Replace the gender details in Name column to UNKNOWN
UPDATE [dbo].[shark_attacks01]
SET [Name]= 'UNKNOWN'
WHERE [Name] IN ('boy','girl','male','female')

--removes extra spaces in Name column
SELECT TRIM([Name]) FROM [dbo].[shark_attacks01]

UPDATE [dbo].[shark_attacks01]
SET [Name]=TRIM([Name])

--check again if there is any gender data in Name column
SELECT DISTINCT [Name] FROM [dbo].[shark_attacks01]

SELECT [Name] FROM [dbo].[shark_attacks01] 
WHERE [Name] LIKE '%boy%' OR [Name] LIKE '%girl%' OR [Name] LIKE '%male%' OR [Name] LIKE '%female%';

SELECT [Name],[Sex] FROM [dbo].[shark_attacks01]
WHERE [Name] LIKE '%boy%' OR [Name] LIKE '%girl%' OR [Name] LIKE '%male%' OR [Name] LIKE '%female%'
ORDER BY [Sex]

UPDATE [dbo].[shark_attacks01]
SET [Name]= 'UNKNOWN'
WHERE [Name] IN ('Arab boy','a German girl','American male','A male from Muitoa')

UPDATE [dbo].[shark_attacks01]
SET [Name]= 'UNKNOWN'
WHERE [Name] IN ('a male from Miami','a German tourist (male)','Japanese female','male, a tourist from Venezuela', 'male from pleasure craft Press On Regardless')

UPDATE [dbo].[shark_attacks01]
SET [Name]= 'UNKNOWN'
WHERE [Name] IN ('a South Australian boy')

UPDATE [dbo].[shark_attacks01]
SET [Name]='Unknown'
WHERE [Name] ='UNKNOWN'

SELECT DISTINCT [Name] FROM [dbo].[shark_attacks01]

--730 rows of Species column with NULL/blanks. Replace them with UNKNOWN
SELECT [Species] FROM [dbo].[shark_attacks01]
WHERE [Species] =' '
OR [Species] IS NULL

UPDATE [dbo].[shark_attacks01]
SET [Species]='UNKNOWN'
WHERE [Species] =' '
OR [Species] IS NULL

UPDATE [dbo].[shark_attacks01]
SET [Species]='Unknown'
WHERE [Species] ='UNKNOWN'

SELECT [Species] FROM [dbo].[shark_attacks01]

--Update FATAL to Fatal in Injury column
SELECT [Injury] FROM [dbo].[shark_attacks01]

UPDATE [dbo].[shark_attacks01]
SET [Injury]='Fatal'
WHERE [Injury]='FATAL'

SELECT * FROM [dbo].[shark_attacks01]

--remove column23 and column24 as no data in both column
SELECT DISTINCT [column23],[column24] FROM [dbo].[shark_attacks01]

ALTER TABLE [dbo].[shark_attacks01]
DROP COLUMN [column23],[column24]

--Wrangling Country column, changing values from UPPER to Proper Case
SELECT CONCAT(UPPER(SUBSTRING([Country],1,1)), lower(SUBSTRING([Country],2,LEN([Country])))) AS Country01 FROM [dbo].[shark_attacks01]

UPDATE [dbo].[shark_attacks01]
SET [Country]=CONCAT(UPPER(SUBSTRING([Country],1,1)), lower(SUBSTRING([Country],2,LEN([Country]))))

SELECT * FROM [dbo].[shark_attacks01]

--Rename the column Sex to Gender
sp_rename '[dbo].[shark_attacks01].[Sex]', 'Gender', 'COLUMN'

--Rename the column Fatal (Y/N) to Fatal
sp_rename '[dbo].[shark_attacks01].[Fatal_Y_N]', 'Fatal', 'COLUMN'

--Wrangling the Time column
SELECT [Time] FROM [dbo].[shark_attacks01]

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
FROM [dbo].[shark_attacks01]
ORDER BY Attack_Time

UPDATE [dbo].[shark_attacks01]
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

SELECT * FROM [dbo].[shark_attacks01]

--Rename Time column to Attack Time
sp_rename '[dbo].[shark_attacks01].[Time]', 'Attack Time', 'COLUMN'

--check transformed data
SELECT * FROM [dbo].[shark_attacks01]
