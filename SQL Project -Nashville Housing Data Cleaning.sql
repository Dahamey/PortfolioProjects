/* Cleaning Data in SQL Qeries  */
SELECT *
FROM PortfolioProject..NashvilleHousing


-----------------------------------------------------------------

--  Standardize Date format
/* Cleaning Data in SQL Queries  */


SELECT SaleDate, CONVERT(date, SaleDate)
FROM PortfolioProject..NashvilleHousing


UPDATE NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate)


ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;


UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)


SELECT SaleDateConverted
FROM PortfolioProject..NashvilleHousing




-------------------------------------------------------------

-- Populate property Adress data


SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing


SELECT *
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL






-----------------------------------------------------------------------------------
-- Breaking out Address into individual columns (Address, City, State)


SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing


SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))  AS State
FROM PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAdress nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitAdress =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))










-----------------------------------------------------------------------
-- breaking down the owner's address using another method 


SELECT PARSENAME(REPLACE(OwnerAddress,',', '.'),3) AS Address,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS City,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS State
FROM PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(250);


UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'),3) 


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(250);


UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'),2) 


ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(250);


UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'),1) 








------------------------------------------------------------------------------


-- Changing 'Y' and 'N' in the SoldAsVacant field into 'Yes' and 'No' 


SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE 
	WHEN SoldAsVacant ='N' THEN 'No'
	WHEN SoldAsVacant ='Y' THEN 'Yes'
	ELSE SoldAsVacant
END AS SoldsVacantFixed
FROM PortfolioProject..NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
	WHEN SoldAsVacant ='N' THEN 'No'
	WHEN SoldAsVacant ='Y' THEN 'Yes'
	ELSE SoldAsVacant
	END





----------------------------------------------------------------

-- Remove Duplicates


----- Duplicates will have 2 in 'row_num'
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
	PropertyAddress,
	SaleDate,
	SalePrice,
	LegalReference
	ORDER BY
		UniqueID
		) row_num
FROM PortfolioProject..NashvilleHousing
ORDER BY ParcelID


------ Use CTE

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
	PropertyAddress,
	SaleDate,
	SalePrice,
	LegalReference
	ORDER BY
		UniqueID
		) row_num
FROM PortfolioProject..NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num >1



-------------------------------------------------

-- Delete unused Columns 


SELECT *
FROM PortfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN  SaleDate, PropertyAddress, OwnerAddress
