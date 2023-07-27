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
