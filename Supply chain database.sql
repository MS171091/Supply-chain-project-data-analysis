Create database Supply_Chain
CREATE TABLE Products (
    SKU VARCHAR (20) PRIMARY KEY,
    Product_Type VARCHAR(100),
    Price float,
    Availability INT,
);
Create table Sales (
  SKU VARCHAR(20),
  Number_of_products_sold int,
  Revenue_generated float,
  Order_quantities int,
  Customer_demographics varchar(20),
FOREIGN KEY (SKU) REFERENCES Products(SKU)
  );
Create table Suppliers (
  SKU VARCHAR(20),
  Supplier_name varchar(20),
  Location VARCHAR(50),
  Lead_time int,
  Production_volumes int,
  Manufacturing_lead_time int,
  Manufacturing_costs float,
FOREIGN KEY (SKU) REFERENCES Products(SKU)
  );

  Create table Inventory (
  SKU VARCHAR(20),
  Stock_levels int,
  Lead_times int,
  Order_quantities int,
  Shipping_times int,
  Shipping_carriers varchar(50),
  Shipping_costs float 
FOREIGN KEY (SKU) REFERENCES Products(SKU)
  );

  CREATE TABLE Customers (
    Product_Type VARCHAR(100),
    SKU VARCHAR(20),
   Customer_demographics VARCHAR(20),
FOREIGN KEY (SKU) REFERENCES Products(SKU)
	);

  CREATE TABLE QualityControl (
    SKU VARCHAR(20),
	Inspection_results VARCHAR(20),
	Defect_rates float,
FOREIGN KEY (SKU) REFERENCES Products(SKU)
	);

CREATE TABLE Transportation (
    SKU VARCHAR(20),
	Transportation_modes VARCHAR(20),
	Routes VARCHAR(20), 
	Costs float,
FOREIGN KEY (SKU) REFERENCES Products(SKU)
	);
BULK INSERT Products
FROM "D:\DEPI Data Analysis\Supply chain Project\SQL\Products.csv"
WITH (
    format = 'csv',
    FIELDTERMINATOR = ',',  -- Specifies that fields are separated by commas
    ROWTERMINATOR = '\n',   -- Specifies that rows are separated by newlines
    FIRSTROW = 2           -- Skips the header row
);

BULK INSERT Customers
FROM "D:\DEPI Data Analysis\Supply chain Project\SQL\Customers.csv"
WITH (
    format = 'csv',
    FIELDTERMINATOR = ',',  -- Specifies that fields are separated by commas
    ROWTERMINATOR = '\n',   -- Specifies that rows are separated by newlines
    FIRSTROW = 2           -- Skips the header row
);

BULK INSERT Inventory
FROM "D:\DEPI Data Analysis\Supply chain Project\SQL\Inventory.csv"
WITH (
    format = 'csv',
    FIELDTERMINATOR = ',',  -- Specifies that fields are separated by commas
    ROWTERMINATOR = '\n',   -- Specifies that rows are separated by newlines
    FIRSTROW = 2           -- Skips the header row
);
BULK INSERT QualityControl
FROM "D:\DEPI Data Analysis\Supply chain Project\SQL\Quality Control.csv"
WITH (
    format = 'csv',
    FIELDTERMINATOR = ',',  -- Specifies that fields are separated by commas
    ROWTERMINATOR = '\n',   -- Specifies that rows are separated by newlines
    FIRSTROW = 2           -- Skips the header row
);
BULK INSERT Sales
FROM "D:\DEPI Data Analysis\Supply chain Project\SQL\Sales.csv"
WITH (
    format = 'csv',
    FIELDTERMINATOR = ',',  -- Specifies that fields are separated by commas
    ROWTERMINATOR = '\n',   -- Specifies that rows are separated by newlines
    FIRSTROW = 2           -- Skips the header row
);
BULK INSERT Suppliers
FROM "D:\DEPI Data Analysis\Supply chain Project\SQL\Suppliers.csv"
WITH (
    format = 'csv',
    FIELDTERMINATOR = ',',  -- Specifies that fields are separated by commas
    ROWTERMINATOR = '\n',   -- Specifies that rows are separated by newlines
    FIRSTROW = 2           -- Skips the header row
);
BULK INSERT Transportation
FROM "D:\DEPI Data Analysis\Supply chain Project\SQL\Transportation.csv"
WITH (
    format = 'csv',
    FIELDTERMINATOR = ',',  -- Specifies that fields are separated by commas
    ROWTERMINATOR = '\n',   -- Specifies that rows are separated by newlines
    FIRSTROW = 2           -- Skips the header row
);

--1.	Which product types generate the highest revenue?
SELECT 
    p.Product_Type,
    SUM(Revenue_generated) AS TotalRevenue
FROM 
    Sales s
JOIN 
    Products p
    ON s.SKU = p.SKU
GROUP BY 
    p.Product_Type
ORDER BY 
    TotalRevenue DESC;

--2- What is Sales Trends Based on Customer Demographics?
select c.customer_demographics, sum(s.revenue_generated) As TotalRevenue
from Sales s
join Customers c on c.SKU = s.SKU
Group by c.Customer_demographics
Order by TotalRevenue Desc;

--3- Which transportation modes are associated with the lowest costs ?

Select t.transportation_modes, 
AVG(t.costs) as Avg_Costs
from transportation t
Join Inventory i on i.SKU=t.SKU
Group by transportation_modes
order by Avg_Costs asc;

--4- Which transportation modes are associated with the fastest delivery times?
Select t.transportation_modes, 
Avg(i.shipping_times) as Avg_Shipping_time 
from transportation t
Join Inventory i on i.SKU=t.SKU
Group by transportation_modes
order by Avg_Shipping_time asc;

--5-Which suppliers have the shortest lead times 
SELECT Suppliers.Supplier_Name, AVG(Lead_Time) AS Average_Lead_Time
FROM Suppliers
GROUP BY Suppliers.Supplier_Name
order by Average_Lead_Time asc;