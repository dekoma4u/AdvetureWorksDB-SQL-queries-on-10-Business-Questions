
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
