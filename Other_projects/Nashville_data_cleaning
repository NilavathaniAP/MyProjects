--DATA CLEANING

SELECT top (1000) *
  FROM [PortfolioProject].[dbo].[Nash]


--CREATING INDEX
  --create index idx_nash
  --on portfolioproject..nash(uniqueid)


--Cleaning date format
SELECT SaleDate2, convert(date, SaleDate2)
  FROM [PortfolioProject].[dbo].[Nash]

alter table nash
add SaleDate2 date

update nash
set saledate2= convert(date, SaleDate);

--alter table nash
--drop column saledate2


-- Populating null property address data
SELECT *
  FROM [PortfolioProject].[dbo].[Nash]
  --where PropertyAddress is null
  order by ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
  FROM [PortfolioProject].[dbo].[Nash] a
  join [PortfolioProject].[dbo].[Nash] b
  on a.ParcelID = b.ParcelID
  and a.UniqueID <> b.UniqueID
  where a.PropertyAddress is null

update a
set PropertyAddress =  isnull(a.PropertyAddress,b.PropertyAddress)
  FROM [PortfolioProject].[dbo].[Nash] a
  join [PortfolioProject].[dbo].[Nash] b
  on a.ParcelID = b.ParcelID
  and a.UniqueID <> b.UniqueID
  where a.PropertyAddress is null

--Breaking Adress as Address, City, State
SELECT PropertyAddress
  FROM [PortfolioProject].[dbo].[Nash]

alter table portfolioproject..Nash
add Property_Address nvarchar(255);

alter table portfolioproject..Nash
add Property_City nvarchar(255)

update nash
set Property_Address= substring(propertyaddress,1,charindex(',',propertyaddress) -1)
from portfolioproject..nash

update nash
set Property_City= substring(propertyaddress,charindex(',',propertyaddress) +2, len(propertyaddress))

--for owner address
select substring(propertyaddress,1,charindex(',',propertyaddress) -1) as Address,
substring(propertyaddress,charindex(',',propertyaddress) +2, len(propertyaddress)) as City

select PARSENAME(replace(OwnerAddress,',','.') , 3)
, PARSENAME(replace(OwnerAddress,',','.') , 2)
, PARSENAME(replace(OwnerAddress,',','.') , 1)
from portfolioproject..nash 

alter table portfolioproject..Nash
add Owner_Address nvarchar(255);

alter table portfolioproject..Nash
add Owner_City nvarchar(255)

alter table portfolioproject..Nash
add Owner_State nvarchar(255)

update nash
set Owner_Address= PARSENAME(replace(OwnerAddress,',','.') , 3)
from portfolioproject..nash

update nash
set Owner_City= PARSENAME(replace(OwnerAddress,',','.') , 2)
from portfolioproject..nash

update nash
set Owner_State= PARSENAME(replace(OwnerAddress,',','.') , 1)
from portfolioproject..nash

SELECT top (1000) * 
  FROM [PortfolioProject].[dbo].[Nash]


--Change Y & N to Yes & No
SELECT SoldAsVacant
, case when SoldAsVacant = 'N' then 'No'
     when SoldAsVacant = 'Y' then 'Yes'
	 else SoldAsVacant
	 end
  FROM [PortfolioProject].[dbo].[Nash]

update [PortfolioProject].[dbo].[Nash]
set SoldAsVacant = case when SoldAsVacant = 'N' then 'No'
     when SoldAsVacant = 'Y' then 'Yes'
	 else SoldAsVacant
	 end

--removing duplicates where row number > 1 are dulipcates 

with rownum as(
select * ,
ROW_NUMBER() over(partition by parcelid,propertyaddress, saleprice, saledate,legalreference
order by uniqueid ) as row_number
from PortfolioProject..Nash)
delete from rownum
where ROW_NUMBER>1
--order by propertyaddress

alter table PortfolioProject..Nash
drop column owneraddress,taxdistrict,propertyaddress

alter table PortfolioProject..Nash
drop column saledate

