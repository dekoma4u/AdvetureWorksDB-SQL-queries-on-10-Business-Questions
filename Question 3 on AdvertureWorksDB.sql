
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
