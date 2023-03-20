/****** Script for SelectTopNRows command from SSMS  ******/

SELECT *
FROM [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]


***** Standardisinng Date Format

SELECT *, CONVERT(DATE, SaleDate)
FROM
[SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
 
*******Update the table with new date format

ALTER TABLE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
ADD SaleDateNew DATE

UPDATE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
SET SaleDateNew = CONVERT(DATE, SaleDate)

******Populate Propert Address Data

SELECT PropertyAddress
FROM
[SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
WHERE PropertyAddress IS NULL


***** finding-29 of Property Addresses are missing

*****will fill the address according to the details of parcelID by Self Joining the table so as to get the reference

SELECT A.ParcelID, B.ParcelID, A.PropertyAddress, B.PropertyAddress,
ISNULL(A.PropertyAddress,B.PropertyAddress)  
FROM
[SQL Portfolio Projects].[dbo].[Nashville Housing Data ] AS A
JOIN
[SQL Portfolio Projects].[dbo].[Nashville Housing Data ] AS B
ON 
A.ParcelID = B.ParcelID
AND
A.UniqueID != B.UniqueID  
WHERE A.PropertyAddress IS NULL


*****updating with filled addresses

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM
[SQL Portfolio Projects].[dbo].[Nashville Housing Data ] AS A
JOIN
[SQL Portfolio Projects].[dbo].[Nashville Housing Data ] AS B
ON 
A.ParcelID = B.ParcelID
AND
A.UniqueID != B.UniqueID  
WHERE A.PropertyAddress IS NULL


****** splitting the address into seperate columns

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) As Address,  
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) AS City 
FROM
[SQL Portfolio Projects].[dbo].[Nashville Housing Data ]


***** Adding new columns

ALTER TABLE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
ADD PropertySplitAddress varchar(225)

UPDATE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) 

ALTER TABLE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
ADD PropertySplitCity varchar(225)

UPDATE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))


****** splitting the address into seperate columns - owner address

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.' ),3),
PARSENAME(REPLACE(OwnerAddress,',','.' ),2),
PARSENAME(REPLACE(OwnerAddress,',','.' ),1)
FROM
[SQL Portfolio Projects].[dbo].[Nashville Housing Data ]





ALTER TABLE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
ADD OwnerSplitAddress varchar(225)

UPDATE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.' ),3)



 

ALTER TABLE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
ADD OwnerSplitCity varchar(225)

UPDATE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.' ),2)




ALTER TABLE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
ADD OwnerSplitState varchar(225)

UPDATE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.' ),1)



********* Changing "1" adn "0" to "Yes" adn "No" in "Sold as vacant" field

SELECt DISTINCT SoldasVacant
FROM [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]


****changing datatype for Sold As vacant

SELECT *, 
CASE WHEN (CAST(SoldasVacant AS varchar(255))) = '0' THEN  'No'
     WHEN (CAST(SoldasVacant AS varchar(255))) = '1' THEN  'Yes'
	 ELSE (CAST(SoldasVacant AS varchar(255)))
END
FROM [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]



***Updating on data list


ALTER TABLE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
ADD SoldAsVacantFixed varchar(225)


UPDATE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ]
SET SoldAsVacantFixed = (CASE WHEN (CAST(SoldasVacant AS varchar(255))) = '0' THEN  'No'
     WHEN (CAST(SoldasVacant AS varchar(255))) = '1' THEN  'Yes'
	 ELSE (CAST(SoldasVacant AS varchar(255)))
END)



******** Remove Duplicates

WITH RowNumCTE AS (
SELECT *,
      ROW_NUMBER() OVER(
	  PARTITION BY ParcelID,
	  PropertyAddress,
	  SalePrice,
	  SaleDate,
	  LegalReference
	  ORDER BY
	    UniqueID ) AS row_num
FROM [SQL Portfolio Projects].[dbo].[Nashville Housing Data ] 
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1



******* Delete unused column
 
ALTER TABLE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ] 
DROP COLUMN OwnerAddress, PropertyAddress

ALTER TABLE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ] 
DROP COLUMN SaleDate

ALTER TABLE [SQL Portfolio Projects].[dbo].[Nashville Housing Data ] 
DROP COLUMN SoldAsVacant