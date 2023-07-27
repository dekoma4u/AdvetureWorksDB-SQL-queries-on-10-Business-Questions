
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