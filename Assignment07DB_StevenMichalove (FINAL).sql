--*************************************************************************--
-- Title: Assignment07
-- Author: StevenMichalove
-- Desc: This file demonstrates how to use Functions
-- Change Log: When,Who,What
-- 0221-08-21,StevenMichalove,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment07DB_StevenMichalove')
	 Begin 
	  Alter Database [Assignment07DB_StevenMichalove] set Single_user With Rollback Immediate;
	  Drop Database Assignment07DB_StevenMichalove;
	 End
	Create Database Assignment07DB_StevenMichalove;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment07DB_StevenMichalove;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL
,[ProductID] [int] NOT NULL
,[ReorderLevel] int NOT NULL -- New Column 
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count] From dbo.Inventories;
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From vCategories;
go
Select * From vProducts;
go
Select * From vEmployees;
go
Select * From vInventories;
go

/********************************* Questions and Answers *********************************/
--'NOTES------------------------------------------------------------------------------------ 
-- 1) You must use the BASIC views for each table.
 --2) Remember that Inventory Counts are Randomly Generated. So, your counts may not match mine
 --3) To make sure the Dates are sorted correctly, you can use Functions in the Order By clause!
------------------------------------------------------------------------------------------'
-- Question 1 (5% of pts): What built-in SQL Server function can you use to show a list 
-- of Product names, and the price of each product, with the price formatted as US dollars?
-- Order the result by the product!

-- <Put Your Code Here> --
-- Show the table
Select * from vProducts

Select	
		ProductName, 
		Format(vProducts.UnitPrice,'C') Price 
from vProducts
Order by ProductName
go

-- Question 2 (10% of pts): What built-in SQL Server function can you use to show a list 
-- of Category and Product names, and the price of each product, 
-- with the price formatted as US dollars?
-- Order the result by the Category and Product!

-- <Put Your Code Here> --
--Show the tables to join
Select * from vProducts
Select * from vCategories
-- Join vProducts and vCategories on CategoryID
select  
		vCategories.CategoryName, 
		vProducts.ProductName, 
		Format (vProducts.UnitPrice,'C') Price
	from vCategories
	inner join vProducts on vCategories.CategoryID=vProducts.CategoryID 
	order by CategoryName, ProductName;
go

-- Question 3 (10% of pts): What built-in SQL Server function can you use to show a list 
-- of Product names, each Inventory Date, and the Inventory Count,
-- with the date formatted like "January, 2017?" 
-- Order the results by the Product, Date, and Count!

-- <Put Your Code Here> --
Select * from vInventories
Select * from vProducts
SELECT DATENAME(month, '2017/08/25') AS DatePartString;
-- Join vInventories AND vProducts on ProductID
Select 
	vProducts.ProductName,	
	Concat(datename(month,InventoryDate),', ',Year(InventoryDate))as Date,
	vInventories.Count
From vProducts 
Inner join vInventories on vInventories.ProductID=vProducts.ProductID 
order by ProductName,date, count
go

-- Question 4 (10% of pts): How can you CREATE A VIEW called vProductInventories 
-- That shows a list of Product names, each Inventory Date, and the Inventory Count, 
-- with the date FORMATTED like January, 2017? Order the results by the Product, Date,
-- and Count!

-- <Put Your Code Here> --
Select * from vInventories
Select * from vProducts
-- test datename
SELECT DATENAME(month, '2017/08/25') AS DatePartString;
-- Join vInventories AND vProducts on ProductID
go
Create view vProductInventories
as
	Select top 10000
		Products.ProductName,	
		Concat(datename(month,InventoryDate),', ',Year(InventoryDate))as Date,
		Inventories.Count
	From Products 
	Inner join Inventories on Inventories.ProductID=Products.ProductID 
	order by ProductName,date, count;
Go

-- Check that it works: Select * From vProductInventories;
select * from vProductInventories
go

-- Question 5 (10% of pts): How can you CREATE A VIEW called vCategoryInventories 
-- that shows a list of Category names, Inventory Dates, 
-- and a TOTAL Inventory Count BY CATEGORY, with the date FORMATTED like January, 2017?

--
-- <Put Your Code Here> --
Select * from Categories
select * from Inventories
Select * from Products
Go
Create view vCategoryInventories 
as
	Select top 1000 
		C.CategoryName, 
		Concat(datename(month,I.InventoryDate),', ',Year(InventoryDate))as Date, 
		Sum(I.Count) as [Total Count]
	-- join Products to Categories using CategoryID and then Join that to Inventoriess with ProductID
	from Categories as C
		Inner Join Products as P on C.CategoryID=P.CategoryID 
		Inner Join Inventories as I on P.ProductID=I.ProductID 
	Group by CategoryName,InventoryDate
	Order by CategoryName;
go

-- Check that it works: Select * From vCategoryInventories;
Select * From vCategoryInventories;
go

-- Question 6 (10% of pts): How can you CREATE ANOTHER VIEW called 
-- vProductInventoriesWithPreviouMonthCounts to show 
-- a list of Product names, Inventory Dates, Inventory Count, AND the Previous Month
-- Count? Use a functions to set any null counts or 1996 counts to zero. Order the
-- results by the Product, Date, and Count. This new view must use your
-- vProductInventories view!



-- <Put Your Code Here> --
Go
select * , month(date) from vProductInventories order by ProductName,month(date) asc
go
-- In this option I set the non existant previous month to NULL which makes alot more sense
GO
create view  vProductInventoriesWithPreviouMonthCountswithNULL as 
	Select top 100000	
		ProductName, 
		Date ,
		Count, 
		IIF (month(date) = 1,NULL, LAG(I.[count], 1,0) OVER (ORDER BY   ProductName, Month(Date))) AS PreviousMonth 
	from vProductInventories as I

	Group by productName,date, count 
	Order by  ProductName, month(date)
		
go
select * from vProductInventoriesWithPreviouMonthCountswithNULL;
Go

-- In this option I set the non existant previous month count to zero as the question asks
Go
create view  vProductInventoriesWithPreviouMonthCounts as 
	Select top 100000	
		ProductName, 
		Date ,
		Count, 
		IIF (month(date) = 1,0, LAG(I.[count], 1,0) OVER (ORDER BY   ProductName, Month(Date))) AS PreviousMonth 
	from vProductInventories as I

	Group by productName,date, count 
	Order by  ProductName, month(date);
		
go


go
Select * From vProductInventoriesWithPreviouMonthCounts;
-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCounts;
go

-- Question 7 (20% of pts): How can you CREATE one more VIEW 
-- called vProductInventoriesWithPreviousMonthCountsWithKPIs
-- to show a list of Product names, Inventory Dates, Inventory Count, the Previous Month 
-- Count and a KPI that displays an increased count as 1, 
-- the same count as 0, and a decreased count as -1? Order the results by the 
-- Product, Date, and Count!

-- <Put Your Code Here> --
go
create view vProductInventoriesWithPreviousMonthCountsWithKPIs
AS
Select top 100000	
		ProductName, 
		Date ,
		Count,
		
		IIF (month(date) = 1,0, LAG([count], 1,0) OVER (ORDER BY   ProductName, Month(Date))) AS PreviousMonth,
		[QtyChangeKPI] = Case
		
		When Count > PreviousMonth Then 1
		When Count = PreviousMonth Then 0
		When Count < PreviousMonth Then -1
   End


	from vProductInventoriesWithPreviouMonthCounts 


	Order by  ProductName,month(date) ;
Go		

-- Important: This new view must use your vProductInventoriesWithPreviousMonthCounts view!
-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;
Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;
go

-- Question 8 (25% of pts): How can you CREATE a User Defined Function (UDF) 
-- called fProductInventoriesWithPreviousMonthCountsWithKPIs
-- to show a list of Product names, Inventory Dates, Inventory Count, the Previous Month
-- Count and a KPI that displays an increased count as 1, the same count as 0, and a
-- decreased count as -1 AND the result can show only KPIs with a value of either 1, 0,
-- or -1? This new function must use you
-- ProductInventoriesWithPreviousMonthCountsWithKPIs view!
-- Include an Order By clause in the function using this code: 
-- Year(Cast(v1.InventoryDate as Date))
-- and note what effect it has on the results.

-- <Put Your Code Here> --
go

Select * from  vProductInventoriesWithPreviousMonthCountsWithKPIs
go
create function dbo.fProductInventoriesWithPreviousMonthCountsWithKPIs(@KPI int)
Returns table
as
	return( 
		Select top 100000
			ProductName,
			Date ,
			count as [This Month's Count],
			PreviousMonth,
			QtyChangeKPI
		From vProductInventoriesWithPreviousMonthCountsWithKPIs
		-- Filter on the input parameter @KPI
		where [QtyChangeKPI] = (@KPI)
		Order by ProductName,month(date),Year(Cast([Date] as Date))
	)

go
/* Check that it works:
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);
*/
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);



go

/***************************************************************************************/