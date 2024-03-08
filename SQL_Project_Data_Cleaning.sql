--Cleaning the data in SQL Queries

Select *
From Portfolio_Cleaning_Project..Nashville_Housing

--Changing Sales Date

Select SaleDate, Convert(Date, SaleDate) as Sale_Date
From Portfolio_Cleaning_Project..Nashville_Housing

Update Nashville_Housing
Set Sale_Date =  SaleDate

Alter Table Nashville_Housing
add Sale_Date Date

--Populating Property Address Data

Select *
From Portfolio_Cleaning_Project..Nashville_Housing
--Where PropertyAddress is Null
Order By ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IsNull(a.PropertyAddress,b.PropertyAddress)
From Portfolio_Cleaning_Project..Nashville_Housing as a
Join Portfolio_Cleaning_Project..Nashville_Housing as b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is not null

Update a
Set PropertyAddress = IsNull(a.PropertyAddress,b.PropertyAddress)
From Portfolio_Cleaning_Project..Nashville_Housing as a
Join Portfolio_Cleaning_Project..Nashville_Housing as b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is null

--Categorizing Property Address Column as (Address, City, State)



Select *
From Portfolio_Cleaning_Project..Nashville_Housing
Where Owner_Address is Null
--Order By ParcelID

--Char Index/Character Index And Substring

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress)) as Address
From Portfolio_Cleaning_Project..Nashville_Housing

Alter Table Nashville_Housing
Add Property_Address Nvarchar(255)

Update Nashville_Housing
Set Property_Address =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter Table Nashville_Housing
Add Property_City Nvarchar(255)

Update Nashville_Housing
Set Property_City =  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress))

Select *
From Portfolio_Cleaning_Project..Nashville_Housing



Select
PARSENAME(Replace(OwnerAddress,',','.') ,3) as address
,PARSENAME(Replace(OwnerAddress,',','.') ,2) as City
,PARSENAME(Replace(OwnerAddress,',','.') ,1) as States
From Portfolio_Cleaning_Project..Nashville_Housing


Alter Table Nashville_Housing
Add Owner_Address Nvarchar(255)

Alter Table Nashville_Housing
Add Owner_City Nvarchar(255)

Alter Table Nashville_Housing
Add Owner_State Nvarchar(255)

Update Nashville_Housing
Set Owner_Address =  PARSENAME(Replace(OwnerAddress,',','.') ,3)

Update Nashville_Housing
Set Owner_City =  PARSENAME(Replace(OwnerAddress,',','.') ,2)

Update Nashville_Housing
Set Owner_State = PARSENAME(Replace(OwnerAddress,',','.') ,1)



--Changing Y And N to Yes And No in (SoldAsVacant) Table Using Case Statement

Select Distinct(SoldAsVacant),COUNT(SoldAsVacant) 
From Portfolio_Cleaning_Project..Nashville_Housing
Group By SoldAsVacant
Order By 2


Select SoldAsVacant
,Case When SoldAsVacant = 'Y' Then 'Yes'
	  When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant 
	  End
From Portfolio_Cleaning_Project..Nashville_Housing

Update Nashville_Housing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	  When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant 
	  End

--Removing Duplicates Using CTE, Row_Number and Partition By

With Row_NumCTE as(
Select *,
	ROW_NUMBER() Over (
	Partition By ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order By
					UniqueID
					) as Row_Num

From Portfolio_Cleaning_Project..Nashville_Housing
--Order By ParcelID
)

Select *
From Row_NumCTE
Where Row_Num > 1


-- Deleting Unused Column


Select *
From Portfolio_Cleaning_Project..Nashville_Housing

Alter Table Portfolio_Cleaning_Project..Nashville_Housing
Drop Column TaxDistrict, PropertyAddress, OwnerAddress,SaleDate

















