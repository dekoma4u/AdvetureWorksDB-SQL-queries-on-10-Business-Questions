# AdvetureWorksDB-SQL-queries-on-10-Business-Questions
## Analysis of AdventureWorks Database: Advanced SQL Queries

In this analysis, we will explore the AdventureWorks database using advanced SQL queries to answer ten different questions. The AdventureWorks database is a fictional sample database provided by Microsoft that simulates a company's data for sales, products, customers, and employees. We'll use these SQL queries to gain valuable insights into the data and answer specific business-related questions.

### 1. Top 5 Customers with Highest Total Sales Amount:

To find the top 5 customers with the highest total sales amount, we will sum the sales amount for each customer and then sort the results in descending order. The SQL query for this is as follows:

```sql
SELECT TOP 5
    CustomerID,
    SUM(SalesAmount) AS TotalSalesAmount
FROM
    Sales.SalesOrderHeader
GROUP BY
    CustomerID
ORDER BY
    TotalSalesAmount DESC;
```

### 2. Total Revenue Generated by Each Product Category:

To calculate the total revenue generated by each product category, we will sum the sales amount for each product category. The SQL query for this is as follows:

```sql
SELECT
    pc.Name AS ProductCategory,
    SUM(soh.SalesAmount) AS TotalRevenue
FROM
    Sales.SalesOrderHeader soh
JOIN
    Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN
    Production.Product p ON sod.ProductID = p.ProductID
JOIN
    Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN
    Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY
    pc.Name;
```

### 3. Top 3 Salespeople Based on the Number of Orders:

To identify the top 3 salespeople based on the number of orders they have processed, we will count the number of orders processed by each salesperson and then sort the results in descending order. The SQL query for this is as follows:

```sql
SELECT TOP 3
    SalesPersonID,
    COUNT(SalesOrderID) AS NumOfOrders
FROM
    Sales.SalesOrderHeader
WHERE
    SalesPersonID IS NOT NULL
GROUP BY
    SalesPersonID
ORDER BY
    NumOfOrders DESC;
```

### 4. Total Profit for Each Subcategory of Products:

To calculate the total profit for each subcategory of products, we will subtract the product cost from the sales amount for each product and then sum the results for each subcategory. The SQL query for this is as follows:

```sql
SELECT
    psc.Name AS ProductSubcategory,
    SUM(soh.SalesAmount - sod.LineTotal) AS TotalProfit
FROM
    Sales.SalesOrderHeader soh
JOIN
    Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN
    Production.Product p ON sod.ProductID = p.ProductID
JOIN
    Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
GROUP BY
    psc.Name;
```

### 5. Average Order Processing Time for Each Month in a Given Year:

To determine the average order processing time for each month in a given year, we will calculate the difference between the order date and the ship date for each order. We'll then calculate the average time for each month. The SQL query for this is as follows (replace `@Year` with the desired year):

```sql
DECLARE @Year INT = 2023; -- Replace with the desired year

SELECT
    DATEPART(MONTH, OrderDate) AS OrderMonth,
    AVG(DATEDIFF(DAY, OrderDate, ShipDate)) AS AvgOrderProcessingTime
FROM
    Sales.SalesOrderHeader
WHERE
    YEAR(OrderDate) = @Year
GROUP BY
    DATEPART(MONTH, OrderDate);
```

### 6. Top 10 Most Popular Products Based on the Number of Units Sold:

To find the top 10 most popular products based on the number of units sold, we will count the total units sold for each product and then sort the results in descending order. The SQL query for this is as follows:

```sql
SELECT TOP 10
    p.Name AS ProductName,
    SUM(sod.OrderQty) AS TotalUnitsSold
FROM
    Sales.SalesOrderDetail sod
JOIN
    Production.Product p ON sod.ProductID = p.ProductID
GROUP BY
    p.Name
ORDER BY
    TotalUnitsSold DESC;
```

### 7. Average Discount Percentage Offered for Each Product Category:

To calculate the average discount percentage offered for each product category, we will compute the average discount percentage for all products within each category. The SQL query for this is as follows:

```sql
SELECT
    pc.Name AS ProductCategory,
    AVG(sod.UnitPriceDiscount) AS AvgDiscountPercentage
FROM
    Sales.SalesOrderDetail sod
JOIN
    Production.Product p ON sod.ProductID = p.ProductID
JOIN
    Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN
    Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY
    pc.Name;
```

### 8. Customers Who Have Made Purchases in All Available Sales Territories:

To identify the customers who have made purchases in all the available sales territories, we will count the number of distinct sales territories each customer has made purchases in and filter out those who have made purchases in all of them. The SQL query for this is as follows:

```sql
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName
FROM
    Sales.Customer c
JOIN
    Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
WHERE
    NOT EXISTS (
        SELECT
            st.TerritoryID
        FROM
            Sales.SalesTerritory st
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM
                    Sales.SalesOrderHeader soh2
                WHERE
                    soh2.CustomerID = c.CustomerID
                    AND soh2.TerritoryID = st.TerritoryID
            )
    );
```

### 9. Top 5 Products with the Highest Growth in Sales Revenue Over the Last Quarter:

To find the top 5 products that have experienced the highest growth in sales revenue over the last quarter, we will compare the sales revenue of each product in the last quarter with the revenue from the quarter before that. The SQL query for this is as follows:

```sql
SELECT TOP 5
    p.Name AS ProductName,
    SUM(CASE WHEN soh.OrderDate >= DATEADD(QUARTER, -2, GETDATE()) THEN sod.LineTotal ELSE 0 END)
        - SUM(CASE WHEN soh.OrderDate >= DATEADD(QUARTER, -4, GETDATE()) AND soh.OrderDate < DATEADD(QUARTER, -2, GETDATE()) THEN sod.LineTotal ELSE 0 END) AS RevenueGrowth
FROM
    Sales.SalesOrderDetail sod
JOIN
    Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN
    Production.Product p ON sod.ProductID = p.ProductID
GROUP BY
    p.Name
ORDER
