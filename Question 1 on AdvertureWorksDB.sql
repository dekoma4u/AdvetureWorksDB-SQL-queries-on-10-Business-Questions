/*
1. Find the top 5 customers with the highest total sales amount.
*/

-- Retrieve the top 5 customers based on their total sales amount.

SELECT TOP 5
    CustomerKey,                      -- Select the customer key
    SUM(OrderQuantity * UnitPrice) AS Total  -- Calculate the total sales amount for each customer

FROM 
    FactInternetSales  -- Specify the FactInternetSales table

GROUP BY 
    CustomerKey  -- Group the results by customer key to aggregate sales for each customer

ORDER BY 
    Total DESC;  -- Order the results by total sales amount in descending order
