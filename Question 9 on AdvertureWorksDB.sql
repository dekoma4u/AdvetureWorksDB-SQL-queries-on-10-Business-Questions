
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

