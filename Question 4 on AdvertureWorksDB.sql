
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
