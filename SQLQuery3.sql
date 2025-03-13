CREATE TABLE cleaned_supply_chain (
    Product_type VARCHAR(50),
    SKU VARCHAR(20) PRIMARY KEY,
    Price DECIMAL(10,2),
    Availability INT,
    Number_of_products_sold INT,
    Revenue_generated DECIMAL(15,2),
    Customer_demographics VARCHAR(50),
    Stock_levels INT,
    Lead_times INT, 
    Order_quantities INT,
	Shipping_times INT,
	Shipping_carriers VARCHAR(100),
	Shipping_costs DECIMAL(15,2),
    Supplier_name VARCHAR(100),
    Location VARCHAR(100),
    Lead_time INT,
    Production_volumes INT,
    Manufacturing_lead_time INT,
    Manufacturing_costs DECIMAL(15,2),
    Inspection_results VARCHAR(50),
    Defect_rates DECIMAL(10,5),
    Transportation_modes VARCHAR(50),
    Routes VARCHAR(50),
    Costs DECIMAL(15,2)
);

BULK INSERT cleaned_supply_chain
FROM 'D:\nada\Digital Egypt Pioneers Initiative\Final project\cleaned_supply_chain.csv'
WITH (
    format = 'csv',
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '0x0a',   
    FIRSTROW = 2           
);

--Which product types generate the highest revenue? 
SELECT Product_type, 
       SUM(Revenue_generated) AS Total_Revenue
FROM cleaned_supply_chain
GROUP BY Product_type
ORDER BY Total_Revenue DESC;


--What is the relationship between the number of products sold and stock levels for each product type? 

SELECT 
    Product_type,
    SUM(Number_of_products_sold) AS Total_Products_Sold,
    SUM(Stock_levels) AS Total_Stock_Levels
FROM cleaned_supply_chain
GROUP BY Product_type
ORDER BY Product_type;

--How do shipping times and costs vary by product type and location? 

SELECT 
    Product_type,
    Location,
    AVG(Shipping_times) AS Avg_Shipping_Time,
    AVG(Shipping_costs) AS Avg_Shipping_Cost
FROM cleaned_supply_chain
GROUP BY Product_type, Location
ORDER BY Product_type, Location;

--What are the most common defect rates for each product type and their impact on revenue? 
	SELECT 
    Product_type,
    Defect_rates,
    COUNT(*) AS Defect_Count,
    AVG(Revenue_generated) AS Avg_Revenue
FROM cleaned_supply_chain
GROUP BY Product_type, Defect_rates
ORDER BY Product_type, Defect_rates DESC;

--How does availability influence the number of products sold across different product types?

SELECT 
    Product_type,
    AVG(Availability) AS Avg_Availability,
    SUM(Number_of_products_sold) AS Total_Sold
FROM cleaned_supply_chain
GROUP BY Product_type
ORDER BY Total_Sold DESC;

--How do lead times and shipping times affect sales performance?

SELECT 
    Product_type,
    AVG(Lead_time) AS Avg_Lead_Time,
    AVG(Shipping_times) AS Avg_Shipping_Time,
    SUM(Number_of_products_sold) AS Total_Sales,
    SUM(Revenue_generated) AS Total_Revenue
FROM cleaned_supply_chain
GROUP BY Product_type
ORDER BY Total_Sales DESC;

--Which customer demographics are associated with higher purchase volumes and revenues? 

SELECT 
    Customer_demographics,  
    SUM(Number_of_products_sold) AS Total_Products_Sold,    
    SUM(Revenue_generated) AS Total_Revenue  
FROM cleaned_supply_chain 
GROUP BY Customer_demographics  
ORDER BY Total_Revenue DESC;  

--How do customer demographics influence product preferences and purchase patterns?

SELECT 
    Customer_demographics,  
    Product_type,  
    SUM(Number_of_products_sold) AS Total_Products_Sold,   
    SUM(Revenue_generated) AS Total_Revenue, 
    AVG(Revenue_generated / NULLIF(Number_of_products_sold, 0)) AS Avg_Revenue_Per_Product  
FROM cleaned_supply_chain 
GROUP BY Customer_demographics, Product_type  
ORDER BY Customer_demographics, Total_Revenue DESC;

--What are the sales trends based on customer demographics?

SELECT 
    Customer_demographics,  
    Location,  
    SUM(Number_of_products_sold) AS Total_Products_Sold,  
    SUM(Revenue_generated) AS Total_Revenue  
FROM cleaned_supply_chain  
GROUP BY Customer_demographics, Location  
ORDER BY Customer_demographics, Total_Revenue DESC;

--How do customer demographics influence purchasing behavior?
SELECT 
    Customer_demographics,  
    COUNT(*) AS Purchase_Frequency,  
    SUM(Number_of_products_sold) AS Total_Products_Sold,  
    SUM(Revenue_generated) AS Total_Revenue,  
    AVG(Revenue_generated / NULLIF(Number_of_products_sold, 0)) AS Avg_Revenue_Per_Product  
FROM cleaned_supply_chain
GROUP BY Customer_demographics  
ORDER BY Total_Revenue DESC;

--Which suppliers have the shortest lead times and lowest manufacturing costs? 
SELECT 
    Supplier_name,  
    AVG(Lead_time) AS Avg_Lead_Time,  
    AVG(Manufacturing_costs) AS Avg_Manufacturing_Cost  
FROM cleaned_supply_chain 
GROUP BY Supplier_name  
ORDER BY Avg_Lead_Time ASC, Avg_Manufacturing_Cost ASC;

--How do production volumes vary by supplier and location? 
SELECT 
    Supplier_name,  
    Location,  
    SUM(Production_volumes) AS Total_Production_Volume  
FROM cleaned_supply_chain  
GROUP BY Supplier_name, Location  
ORDER BY Supplier_name, Total_Production_Volume DESC;

--Supplier and defect rates
SELECT 
    Supplier_name,  
    AVG(Defect_rates) AS Avg_Defect_Rate  
FROM cleaned_supply_chain  
GROUP BY Supplier_name  
ORDER BY Avg_Defect_Rate ASC;

--What are the average shipping costs and times for each transportation mode?
SELECT 
    Transportation_modes, 
    AVG(Shipping_costs) AS Avg_Shipping_Cost, 
    AVG(Shipping_times) AS Avg_Shipping_Time
FROM cleaned_supply_chain
GROUP BY Transportation_modes
ORDER BY Avg_Shipping_Cost DESC;

--How do shipping carriers affect shipping times and costs?
SELECT 
    Shipping_carriers, 
    AVG(Shipping_costs) AS Avg_Shipping_Cost, 
    AVG(Shipping_times) AS Avg_Shipping_Time
FROM cleaned_supply_chain
GROUP BY Shipping_carriers
ORDER BY Avg_Shipping_Cost DESC;

--Which transportation modes are associated with the lowest costs and fastest delivery times?
SELECT 
    Transportation_modes, 
    AVG(Shipping_costs) AS Avg_Shipping_Cost, 
    AVG(Shipping_times) AS Avg_Shipping_Time
FROM cleaned_supply_chain
GROUP BY Transportation_modes
ORDER BY Avg_Shipping_Cost ASC, Avg_Shipping_Time ASC;

--Evaluate supplier performance according to lead tim
SELECT 
    Supplier_name, 
    AVG(Lead_time) AS Avg_Lead_Time
FROM cleaned_supply_chain
GROUP BY Supplier_name
ORDER BY Avg_Lead_Time ASC;

--Inspection results for each category
SELECT 
    Product_Type, 
    Inspection_results, 
    COUNT(*) AS Count_Of_Results
FROM cleaned_supply_chain
GROUP BY Product_Type, Inspection_results
ORDER BY Product_Type, Count_Of_Results DESC;

