
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
