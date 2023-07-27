
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
