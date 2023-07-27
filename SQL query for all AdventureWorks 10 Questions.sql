/*
1. Find the top 5 customers with the highest total sales amount.
*/

-- Retrieve the top 5 customers based on their total sales amount.

SELECT TOP 5
    CustomerKey,      
    SUM(OrderQuantity * UnitPrice) AS Total  

FROM 
    FactInternetSales  

GROUP BY 
    CustomerKey  

ORDER BY 
    Total DESC;  




/*
2. Calculate the total revenue generated by each product category.
*/

-- Calculate total revenue by product category
SELECT 
	DPC.ProductCategoryKey AS Product_Category,    -- Product category key with alias
	ROUND(SUM(FS.OrderQuantity * FS.UnitPrice), 0) AS Total  -- Calculate rounded total revenue
FROM 
	FactInternetSales AS FS  -- FactInternetSales table alias
JOIN 
	DimProduct AS DP ON FS.ProductKey = DP.ProductKey  -- Join FactInternetSales with DimProduct
JOIN 
	DimProductSubcategory AS DSP ON DP.ProductSubcategoryKey = DSP.ProductSubcategoryKey  -- Join DimProduct with DimProductSubcategory
JOIN 
	DimProductCategory AS DPC ON DSP.ProductCategoryKey = DPC.ProductCategoryKey  -- Join DimProductSubcategory with DimProductCategory
GROUP BY 
	DPC.ProductCategoryKey  -- Group by product category key
ORDER BY 
	Total DESC;  -- Order results by total revenue descending



/*
3. Identify the top 3 salespeople based on the number of orders they have processed.
*/
-- Top 10 resellers by total orders
SELECT Top 3
	RS.ResellerKey AS Reseller,  -- Reseller key with alias
	COUNT(FS.SalesOrderNumber) AS Order_count  -- Calculate total orders
FROM 
	DimReseller RS  -- DimReseller table alias
JOIN 
	DimGeography Geo ON RS.GeographyKey = Geo.GeographyKey  -- Join DimReseller with DimGeography
JOIN 
	FactInternetSales FS ON Geo.SalesTerritoryKey = FS.SalesTerritoryKey  -- Join DimGeography with FactInternetSales
GROUP BY 
	RS.ResellerKey  -- Group by reseller key
ORDER BY 
	Order_count DESC;  -- Order results by total orders descending




/*
4. Calculate the total profit for each subcategory of products.
*/

-- This SQL query calculates sales-related data for each product category and displays the results in descending order of profit.

-- SELECT statement:
-- Calculate sales statistics for each product category

SELECT 
    DPC.ProductCategoryKey AS Product_Category,  -- Select the product category key and give it an alias "Product_Category"
    ROUND(SUM(FS.SalesAmount), 0) AS SalesAmount,  -- Calculate the rounded sum of sales amount and give it an alias "SalesAmount"
    ROUND(SUM(FS.TotalProductCost), 0) AS TotalCosts,  -- Calculate the rounded sum of total product costs and give it an alias "TotalCosts"
    ROUND(SUM(FS.SalesAmount) - SUM(FS.TotalProductCost), 0) AS Profit  -- Calculate the rounded profit (sales amount minus total costs) and give it an alias "Profit"
    
-- FROM clause:
FROM 
    FactInternetSales AS FS  -- Alias the FactInternetSales table as "FS"

-- JOIN clauses:
JOIN 
    DimProduct AS DP ON FS.ProductKey = DP.ProductKey  -- Join FactInternetSales with DimProduct on ProductKey
JOIN 
    DimProductSubcategory AS DSP ON DP.ProductSubcategoryKey = DSP.ProductSubcategoryKey  -- Join DimProduct with DimProductSubcategory on ProductSubcategoryKey
JOIN 
    DimProductCategory AS DPC ON DSP.ProductCategoryKey = DPC.ProductCategoryKey  -- Join DimProductSubcategory with DimProductCategory on ProductCategoryKey

-- GROUP BY clause:
GROUP BY 
    DPC.ProductCategoryKey  -- Group the results by the ProductCategoryKey to aggregate sales data for each product category

-- ORDER BY clause:
ORDER BY 
    Profit DESC;  -- Sort the results in descending order of profit




/*
5. Determine the average order processing time for each month in a given year.
*/


-- Select the name of the month from the 'ShipDate' column and alias it as 'Months'
SELECT 
    DATENAME(month, ShipDate) as Months,

    -- Extract the year from the 'ShipDate' column and alias it as 'Years'
    Year(ShipDate) as Years,

    -- Calculate the average number of days between 'OrderDate' and 'ShipDate' for each month and year
    avg(DATEDIFF(day, OrderDate, ShipDate)) AS DayDiff
FROM 
    FactInternetSales

-- Group the results by month and year, so we get the average for each combination
GROUP BY 
    DATENAME(month, ShipDate),
    Year(ShipDate)

-- Sort the results in ascending order of years
ORDER BY 
    Years asc;



/*
6. Find the top 10 most popular products based on the number of units sold.
*/

-- Select the top 10 products and their total quantity sold
SELECT TOP 10
    DP.EnglishProductName,     -- English product name column
    SUM(OrderQuantity) AS Quantity  -- Calculate total quantity sold and alias it as 'Quantity'
FROM 
    FactInternetSales FIS  -- FactInternetSales table, aliased as 'FIS'
INNER JOIN
    DimProduct DP  -- DimProduct table, aliased as 'DP'
    ON FIS.ProductKey = DP.ProductKey   -- Join tables on ProductKey column
GROUP BY	
    DP.EnglishProductName  -- Group results by English product name
ORDER BY 
    Quantity DESC;  -- Sort results in descending order based on total quantity



	/*
7. Calculate the average discount percentage offered for each product category.
*/

-- Select the product category key, English product category name, and the average unit price discount percentage rounded to 4 decimal places.
SELECT 
    DPC.ProductCategoryKey, -- Product category key
    DPC.EnglishProductCategoryName, -- English product category name
    ROUND(AVG(FRS.UnitPriceDiscountPct), 4) AS Discountpct -- Average unit price discount percentage (rounded to 4 decimal places)
    
FROM 
    FactResellerSales FRS -- Main sales data table
    
INNER JOIN
    DimProduct DP ON DP.ProductKey = FRS.ProductKey -- Join with DimProduct table to get additional product information
    
INNER JOIN
    DimProductSubcategory DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey -- Join with DimProductSubcategory table for product subcategory information
    
INNER JOIN
    DimProductCategory DPC ON DPC.ProductCategoryKey = DPS.ProductCategoryKey -- Join with DimProductCategory table for product category information
    
GROUP BY
    DPC.EnglishProductCategoryName, -- Group by product category name in English
    DPC.ProductCategoryKey -- Group by product category key
    
ORDER BY 
    Discountpct DESC -- Sort the results in descending order of the average unit price discount percentage




	/*
8. Identify the customers who have made purchases in at least half of the available Sales territories.
*/

-- Retrieve distinct customer names and their sales territory countries
SELECT DISTINCT
    CONCAT(DC.FirstName, ', ', DC.LastName) AS Full_Name,  -- Concatenate first name and last name to create the full name
    DST.SalesTerritoryCountry  -- Sales territory country
FROM 
    DimCustomer DC
INNER JOIN 
    DimGeography DG ON DG.GeographyKey = DC.GeographyKey  -- Join DimCustomer with DimGeography on GeographyKey
INNER JOIN
    DimSalesTerritory DST ON DST.SalesTerritoryKey = DG.SalesTerritoryKey  -- Join DimGeography with DimSalesTerritory on SalesTerritoryKey
WHERE 
    DST.SalesTerritoryCountry IN ('Australia', 'Canada', 'France', 'Germany', 'United Kingdom', 'United States')
    -- Filter the results to include only the specified sales territory countries

GROUP BY 
    CONCAT(DC.FirstName, ', ', DC.LastName), DST.SalesTerritoryCountry
    -- Group the results by customer name and sales territory country

HAVING 
    COUNT(DISTINCT DST.SalesTerritoryCountry) = 1;
    -- Filter the grouped results to include only those customers who have sales territories in all six specified countries



/*
9. Find the top 5 products that have experienced the highest growth in sales revenue over the last quarter.
*/

-- Retrieve the top 5 products' sales for the last 3 months.
SELECT TOP 5
    DP.EnglishProductName, -- Select the English product name.
    SUM(FIS.SalesAmount) AS Total, -- Calculate the total sales amount for each product.
    CAST(FIS.OrderDate as Date) as OrderDate -- Convert the OrderDate to a date without time.

FROM DimProduct DP
INNER JOIN FactInternetSales FIS ON DP.ProductKey = FIS.ProductKey
-- Join DimProduct and FactInternetSales tables.

WHERE
    -- Filter the orders within the last 3 months.
    FIS.OrderDate >= DATEADD(MONTH, DATEDIFF(month, 0, (SELECT MAX(OrderDate) FROM FactInternetSales)) - 2, 0)
    AND FIS.OrderDate < DATEADD(MONTH, DATEDIFF(month, 0, (SELECT MAX(OrderDate) FROM FactInternetSales)) + 1, 0)

GROUP BY
    DP.EnglishProductName, FIS.OrderDate
-- Group the results by product name and order date.

ORDER BY Total DESC;
-- Sort the results by total sales amount in descending order.




/*
10. Calculate the total revenue generated by each customer for each quarter of the year.
*/
-- Retrieve customer full names, total price, year, and quarter of orders.
-- Retrieve the full name, price, year, and quarter for each order.
SELECT
    CONCAT(DC.FirstName, ', ', DC.LastName) AS Full_Name, -- Combine the first and last names into a full name.
    SUM(FIS.UnitPrice) AS Price, -- Calculate the total price by summing the UnitPrice.
    YEAR(FIS.OrderDate) AS Year, -- Extract the year from the OrderDate.
    CASE
        WHEN DATEPART(quarter, FIS.OrderDate) = 1 THEN 'Q1' -- Set Quarter as 'Q1' if the OrderDate's quarter is 1.
        ELSE '' -- Set Quarter to an empty string for other cases when quarter is not 1.
    END AS Quarter
FROM
    DimCustomer DC
INNER JOIN 
    FactInternetSales FIS ON FIS.CustomerKey = DC.CustomerKey
GROUP BY
    CONCAT(DC.FirstName, ', ', DC.LastName), FIS.OrderDate, YEAR(FIS.OrderDate),
    CASE
        WHEN DATEPART(quarter, FIS.OrderDate) = 1 THEN 'Q1' -- Group by Quarter as 'Q1' if the OrderDate's quarter is 1.
        ELSE '' -- Group by Quarter as an empty string for other cases when quarter is not 1.
    END
ORDER BY 
    CONCAT(DC.FirstName, ', ', DC.LastName) ASC; -- Sort the results by Full_Name in ascending order.



-- Alternatively, this block of codes make removes the empty or null values from the Quarter column.

-- Retrieve the full name, price, year, and quarter for each order, excluding rows with an empty Quarter value.


SELECT
    CONCAT(DC.FirstName, ', ', DC.LastName) AS Full_Name, -- Combine the first and last names into a full name.
    SUM(FIS.UnitPrice) AS Price, -- Calculate the total price by summing the UnitPrice.
    YEAR(FIS.OrderDate) AS Year, -- Extract the year from the OrderDate.
    CASE
        WHEN DATEPART(quarter, FIS.OrderDate) = 1 THEN 'Q1' -- Set Quarter as 'Q1' if the OrderDate's quarter is 1.
        WHEN DATEPART(quarter, FIS.OrderDate) = 2 THEN 'Q2' -- Set Quarter as 'Q2' if the OrderDate's quarter is 2.
        WHEN DATEPART(quarter, FIS.OrderDate) = 3 THEN 'Q3' -- Set Quarter as 'Q3' if the OrderDate's quarter is 3.
        WHEN DATEPART(quarter, FIS.OrderDate) = 4 THEN 'Q4' -- Set Quarter as 'Q4' if the OrderDate's quarter is 4.
        ELSE '' -- Set Quarter to an empty string for other cases when quarter is not 1, 2, 3, or 4.
    END AS Quarter
FROM
    DimCustomer DC
INNER JOIN 
    FactInternetSales FIS ON FIS.CustomerKey = DC.CustomerKey
WHERE
    CASE
        WHEN DATEPART(quarter, FIS.OrderDate) = 1 THEN 'Q1' -- Include rows with Quarter as 'Q1'.
        WHEN DATEPART(quarter, FIS.OrderDate) = 2 THEN 'Q2' -- Include rows with Quarter as 'Q2'.
        WHEN DATEPART(quarter, FIS.OrderDate) = 3 THEN 'Q3' -- Include rows with Quarter as 'Q3'.
        WHEN DATEPART(quarter, FIS.OrderDate) = 4 THEN 'Q4' -- Include rows with Quarter as 'Q4'.
        ELSE '' -- Exclude rows with an empty Quarter value for other cases when quarter is not 1, 2, 3, or 4.
    END <> ''
GROUP BY
    CONCAT(DC.FirstName, ', ', DC.LastName),
    FIS.OrderDate,
    YEAR(FIS.OrderDate),
    CASE
        WHEN DATEPART(quarter, FIS.OrderDate) = 1 THEN 'Q1' -- Group by Quarter as 'Q1' if the OrderDate's quarter is 1.
        WHEN DATEPART(quarter, FIS.OrderDate) = 2 THEN 'Q2' -- Group by Quarter as 'Q2' if the OrderDate's quarter is 2.
        WHEN DATEPART(quarter, FIS.OrderDate) = 3 THEN 'Q3' -- Group by Quarter as 'Q3' if the OrderDate's quarter is 3.
        WHEN DATEPART(quarter, FIS.OrderDate) = 4 THEN 'Q4' -- Group by Quarter as 'Q4' if the OrderDate's quarter is 4.
        ELSE '' -- Group by Quarter as an empty string for other cases when quarter is not 1, 2, 3, or 4.
    END
ORDER BY 
    Full_Name ASC; -- Sort the results by Full_Name in ascending order.
