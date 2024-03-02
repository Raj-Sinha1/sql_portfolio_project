---------------------------------------------------------------------------------------------------
--Cleaning Data for Sql Queries


select SaleDate,cast(SaleDate as date) as CorrectFormat
from PortfolioProject..NashvilleHousing


select Saledate, convert(date, Saledate) as CorrentFormat
from PortfolioProject..NashvilleHousing


alter table NashvilleHousing
add SaledateConverted date

update NashvilleHousing
set SaledateConverted = CONVERT(date,SaleDate)

select * from NashvilleHousing

---------------------------------------------------------------------------------------------------
--Populate property Address 

select * from NashvilleHousing
where PropertyAddress is null
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing as a
join PortfolioProject..NashvilleHousing as b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing as a
join PortfolioProject..NashvilleHousing as b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]

---------------------------------------------------------------------------------------------------
--Breaking out Address into individual Columns(Address, city, State)

select PropertyAddress 
from PortfolioProject..NashvilleHousing

select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,--,CHARINDEX(',',PropertyAddress)
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as address1
from PortfolioProject..NashvilleHousing


alter table NashvilleHousing
add PropertySplitAddress nvarchar(50)

update NashvilleHousing
set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(50)

update NashvilleHousing
set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

select * from NashvilleHousing

select OwnerAddress from NashvilleHousing

select 
PARSENAME(replace(OwnerAddress,',','.'),3), 
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress nvarchar(50)

update NashvilleHousing
set OwnerSplitAddress=PARSENAME(replace(OwnerAddress,',','.'),3)

alter table NashvilleHousing
add OwnerSplitCity nvarchar(50)

update NashvilleHousing
set OwnerSplitCity=PARSENAME(replace(OwnerAddress,',','.'),2)

alter table NashvilleHousing
add OwnerSplitState nvarchar(50)

update NashvilleHousing
set OwnerSplitState=PARSENAME(replace(OwnerAddress,',','.'),1)


---------------------------------------------------------------------------------------------------
--Changing y and n to yes and no in SoldVsVacant Field 
select distinct SoldAsVacant, COUNT(SoldAsVacant) 
from NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant='Y' then 'Yes'
	 when SoldAsVacant='N' then 'No'
	 else SoldAsVacant
	 end
from NashvilleHousing

update NashvilleHousing set SoldAsVacant=
case when SoldAsVacant='Y' then 'Yes'
	 when SoldAsVacant='N' then 'No'
	 else SoldAsVacant
	 end

---------------------------------------------------------------------------------------------------
--Removing Duplicates

with cte_nash as(
select *, 
	ROW_NUMBER() over (
	Partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by ParcelId
	) row_num
from NashvilleHousing
)
select * from cte_nash
where row_num>1


with cte_nash as(
select *, 
	ROW_NUMBER() over (
	Partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by ParcelId
	) row_num
from NashvilleHousing
)
delete from cte_nash
where row_num>1

--considering that there are no primary keys in our data set
select * 
from NashvilleHousing


------------------------------------------------------------------------------------------------
--Deleting Unused Columns

select * 
from PortfolioProject..NashvilleHousing


alter table PortfolioProject..NashvilleHousing
drop column owneraddress, taxdistrict, propertyaddress

alter table PortfolioProject..NashvilleHousing
drop column saledate
