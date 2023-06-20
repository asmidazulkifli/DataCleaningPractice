/*

NashvilleHousing Data Cleaning

*/

SELECT * FROM [dbo].[NashvilleHousing]

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


SELECT [SaleDate], CONVERT(DATE,[SaleDate])
FROM [dbo].[NashvilleHousing]

ALTER TABLE [dbo].[NashvilleHousing]
ADD SaleDateConverted Date;

UPDATE [dbo].[NashvilleHousing]
SET SaleDateConverted = CONVERT(DATE,[SaleDate])

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

-- 29 rows with null value
SELECT [PropertyAddress]
FROM [dbo].[NashvilleHousing]
WHERE [PropertyAddress] IS NULL

-- Data in the ParcelID column has its own unique data in the PropertyAddress column
-- Therefore, we will use the ParcelID column to fill in the PropertyAddress column with null values, provided that their UniqueID does not overlap

SELECT a.[ParcelID], a.[PropertyAddress], b.[ParcelID], b.[PropertyAddress], ISNULL(a.[PropertyAddress],b.[PropertyAddress])
FROM [dbo].[NashvilleHousing] a
JOIN [dbo].[NashvilleHousing] b
	ON a.[ParcelID] = b.[ParcelID]
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.[PropertyAddress] IS NULL


UPDATE a
SET [PropertyAddress] = ISNULL(a.[PropertyAddress],b.[PropertyAddress])
FROM [dbo].[NashvilleHousing] a
JOIN [dbo].[NashvilleHousing] b
	ON a.[ParcelID] = b.[ParcelID]
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.[PropertyAddress] IS NULL

/*
-- below queries are the steps taken to change the data type for UniqueID column from float to nvarchar(255)

SELECT CAST([UniqueID ] AS nvarchar(255))
FROM [dbo].[NashvilleHousing]

UPDATE [dbo].[NashvilleHousing]
SET [UniqueID ] = CAST([UniqueID ] AS nvarchar(255))

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'NashvilleHousing' AND COLUMN_NAME = 'UniqueID'

-- The data type is still float, even though a Cast function has been used to try and convert it to a different type
-- Hence, we have to create a new column

ALTER TABLE [dbo].[NashvilleHousing]
ADD [UniqueID_New] nvarchar(255) NULL;

UPDATE [dbo].[NashvilleHousing]
SET [UniqueID_New] = CAST([UniqueID] AS nvarchar(255));

ALTER TABLE [dbo].[NashvilleHousing]
DROP COLUMN [UniqueID];

EXEC sp_rename 'NashvilleHousing.UniqueID_New', 'UniqueID', 'COLUMN';
*/

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Addressm City, State)

-- Property Address

SELECT [PropertyAddress]
FROM [dbo].[NashvilleHousing]

-- -1/+1 is to remove the delimeter; ','

SELECT
SUBSTRING([PropertyAddress], 1, CHARINDEX(',', [PropertyAddress]) -1 ) AS Address,
SUBSTRING([PropertyAddress], CHARINDEX(',', [PropertyAddress]) +1, LEN([PropertyAddress])) AS Address
FROM [dbo].[NashvilleHousing]


ALTER TABLE [dbo].[NashvilleHousing]
ADD PropertySplitAdress nvarchar(255);

UPDATE [dbo].[NashvilleHousing]
SET PropertySplitAdress = SUBSTRING([PropertyAddress], 1, CHARINDEX(',', [PropertyAddress]) -1 )

ALTER TABLE [dbo].[NashvilleHousing]
ADD PropertySplitCity nvarchar(255)

UPDATE [dbo].[NashvilleHousing]
SET PropertySplitCity = SUBSTRING([PropertyAddress], CHARINDEX(',', [PropertyAddress]) +1, LEN([PropertyAddress]))

SELECT * FROM [dbo].[NashvilleHousing]


-- Owner Address

SELECT [OwnerAddress] FROM [dbo].[NashvilleHousing]

SELECT 
PARSENAME(REPLACE([OwnerAddress], ',', '.'), 3),
PARSENAME(REPLACE([OwnerAddress], ',', '.'), 2),
PARSENAME(REPLACE([OwnerAddress], ',', '.'), 1)
FROM [dbo].[NashvilleHousing]


ALTER TABLE [dbo].[NashvilleHousing]
ADD OwnerSplitAddress nvarchar(255)

UPDATE [dbo].[NashvilleHousing]
SET OwnerSplitAddress = PARSENAME(REPLACE([OwnerAddress], ',', '.'), 3)

ALTER TABLE [dbo].[NashvilleHousing]
ADD OwnerSplitCity nvarchar(255)

UPDATE [dbo].[NashvilleHousing]
SET OwnerSplitCity = PARSENAME(REPLACE([OwnerAddress], ',', '.'), 2)

ALTER TABLE [dbo].[NashvilleHousing]
ADD OwnerSplitState nvarchar(255)

UPDATE [dbo].[NashvilleHousing]
SET OwnerSplitState = PARSENAME(REPLACE([OwnerAddress], ',', '.'), 1)

SELECT * FROM [dbo].[NashvilleHousing]


-------------------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT([SoldAsVacant]), COUNT([SoldAsVacant])
FROM [dbo].[NashvilleHousing]
GROUP BY [SoldAsVacant]
ORDER BY 2

SELECT [SoldAsVacant],
CASE
	WHEN [SoldAsVacant] = 'Y' THEN 'Yes'
	WHEN [SoldAsVacant] = 'N' THEN 'No'
	ELSE [SoldAsVacant]
	END
FROM [dbo].[NashvilleHousing]

UPDATE [dbo].[NashvilleHousing]
SET [SoldAsVacant] = CASE
	WHEN [SoldAsVacant] = 'Y' THEN 'Yes'
	WHEN [SoldAsVacant] = 'N' THEN 'No'
	ELSE [SoldAsVacant]
	END

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
 
-- temp table to identify duplicate data 
WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
	PARTITION BY [ParcelID],
				 [PropertyAddress],
				 [SalePrice],
				 [SaleDate], 
				 [LegalReference]
				 ORDER BY
					[UniqueID]
					) row_num
FROM [dbo].[NashvilleHousing]
--ORDER BY [ParcelID]
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY [PropertyAddress]


-- deleting rows with duplicate data
WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
	PARTITION BY [ParcelID],
				 [PropertyAddress],
				 [SalePrice],
				 [SaleDate], 
				 [LegalReference]
				 ORDER BY
					[UniqueID]
					) row_num
FROM [dbo].[NashvilleHousing]
--ORDER BY [ParcelID]
)
DELETE
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY [PropertyAddress]

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT * FROM [dbo].[NashvilleHousing]

ALTER TABLE [dbo].[NashvilleHousing]
DROP COLUMN [PropertyAddress], [OwnerAddress], [TaxDistrict]

ALTER TABLE [dbo].[NashvilleHousing]
DROP COLUMN [SaleDate]








