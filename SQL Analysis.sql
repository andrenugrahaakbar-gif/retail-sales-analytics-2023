--- Overview Data----
SELECT * FROM retail_data LIMIT 20;

--Update Logic Total Amount-
UPDATE retail_data
SET "TotalAmount" = ROUND(("GrossAmount" * (1 - (COALESCE("DiscountApplied", 0) / 100.0)))::numeric, 2);

--1. Revenue Per Bulan
WITH MonthlyRevenue AS (
    SELECT
        DATE_TRUNC('month', "Date") AS "Month_Trunc",
        SUM("TotalAmount") AS "Revenue",
        SUM("Quantity") AS "Units_Sold",
        COUNT(DISTINCT "StoreID") AS "Active_Stores"
    FROM retail_data
    WHERE EXTRACT(YEAR FROM "Date") = 2023
    GROUP BY DATE_TRUNC('month', "Date")
)
SELECT
    TO_CHAR("Month_Trunc", 'YYYY-MM') AS "Month",
    ROUND(("Revenue")::numeric, 2) AS "Total_Revenue",
    "Units_Sold",
    "Active_Stores",
    ROUND((LAG("Revenue") OVER (ORDER BY "Month_Trunc"))::numeric, 2) AS "Prev_Revenue",
    ROUND(
        COALESCE(
            (("Revenue" - LAG("Revenue") OVER (ORDER BY "Month_Trunc"))
            / NULLIF(LAG("Revenue") OVER (ORDER BY "Month_Trunc"), 0) * 100)::numeric,
            0
        ), 2
    ) AS "MoM_Growth_%"
FROM MonthlyRevenue
ORDER BY "Month_Trunc" ASC;

--2. Revenue Per Bulan By Category
SELECT
    TO_CHAR(DATE_TRUNC('month', "Date"), 'YYYY-MM') AS "Month",
    ROUND((SUM(CASE WHEN "CategoryName" = 'Electronics' THEN "TotalAmount" ELSE 0 END))::numeric,2) AS "Electronics_Rev",
    ROUND((SUM(CASE WHEN "CategoryName" = 'Clothing'    THEN "TotalAmount" ELSE 0 END))::numeric,2) AS "Clothing_Rev",
    ROUND((SUM(CASE WHEN "CategoryName" = 'Beauty'      THEN "TotalAmount" ELSE 0 END))::numeric,2) AS "Beauty_Rev",
    ROUND((SUM("TotalAmount"))::numeric,2) AS "Total_Revenue",
    SUM("Quantity") AS "Total_Units_Sold"
FROM
    retail_data
WHERE
    EXTRACT(YEAR FROM "Date") = 2023
GROUP BY
    DATE_TRUNC('month', "Date")
ORDER BY
    DATE_TRUNC('month', "Date") ASC;

--3. Revenue Per Bulan By Store
SELECT
    TO_CHAR(DATE_TRUNC('month', "Date"), 'YYYY-MM') AS "Month",
    ROUND((SUM(CASE WHEN "StoreName" = 'Bandung Store'      THEN "TotalAmount" ELSE 0 END))::numeric,2) AS "Bandung",
    ROUND((SUM(CASE WHEN "StoreName" = 'Bali Shop'          THEN "TotalAmount" ELSE 0 END))::numeric,2) AS "Bali",
    ROUND((SUM(CASE WHEN "StoreName" = 'Medan Branch'       THEN "TotalAmount" ELSE 0 END))::numeric,2) AS "Medan",
    ROUND((SUM(CASE WHEN "StoreName" = 'Surabaya Outlet'    THEN "TotalAmount" ELSE 0 END))::numeric,2) AS "Surabaya",
    ROUND((SUM(CASE WHEN "StoreName" = 'Main Store Jakarta' THEN "TotalAmount" ELSE 0 END))::numeric,2) AS "Jakarta",
    ROUND((SUM("TotalAmount"))::numeric,2) AS "Total_Revenue",
	SUM("Quantity") AS "Total_Units_Sold"
FROM
    retail_data
WHERE
    EXTRACT(YEAR FROM "Date") = 2023
GROUP BY
    DATE_TRUNC('month', "Date")
ORDER BY
    DATE_TRUNC('month', "Date") ASC;


--4. Quantity per Bulan by Category
SELECT
    TO_CHAR(DATE_TRUNC('month', "Date"), 'YYYY-MM') AS "Month",
	ROUND((SUM("TotalAmount"))::numeric,2) AS "Total_Revenue",
    SUM(CASE WHEN "CategoryName" = 'Electronics' THEN "Quantity" ELSE 0 END) AS "Electronics_Units",
    SUM(CASE WHEN "CategoryName" = 'Clothing'    THEN "Quantity" ELSE 0 END) AS "Clothing_Units",
    SUM(CASE WHEN "CategoryName" = 'Beauty'      THEN "Quantity" ELSE 0 END) AS "Beauty_Units",
    SUM("Quantity") AS "Total_Units",
    ROUND((SUM("TotalAmount") / NULLIF(SUM("Quantity"), 0))::numeric, 2) AS "Avg_Revenue_Per_Unit"
FROM
    retail_data
WHERE
    EXTRACT(YEAR FROM "Date") = 2023
GROUP BY
    DATE_TRUNC('month', "Date")
ORDER BY
    DATE_TRUNC('month', "Date") ASC;

--5. Transaction and Quantity in Low Revenue Month (3)
SELECT
    TO_CHAR(DATE_TRUNC('month', "Date"), 'YYYY-MM') AS "Month",
    "CategoryName",
    "StoreName",
    ROUND((SUM("TotalAmount"))::numeric,2) AS "Revenue",
    SUM("Quantity") AS "Units_Sold",
    COUNT(*) AS "Transactions",
    ROUND((AVG("DiscountApplied"))::numeric, 2) AS "Avg_Discount"
FROM
    retail_data
WHERE
    EXTRACT(YEAR FROM "Date") = 2023
    AND EXTRACT(MONTH FROM "Date") IN (3)
GROUP BY
    DATE_TRUNC('month', "Date"),
    "CategoryName",
    "StoreName"
ORDER BY
    "Month" ASC,
    "Revenue" ASC;
	
-- Month (6)
SELECT
    TO_CHAR(DATE_TRUNC('month', "Date"), 'YYYY-MM') AS "Month",
    "CategoryName",
    "StoreName",
    ROUND((SUM("TotalAmount"))::numeric,2) AS "Revenue",
    SUM("Quantity") AS "Units_Sold",
    COUNT(*) AS "Transactions",
    ROUND((AVG("DiscountApplied"))::numeric, 2) AS "Avg_Discount"
FROM
    retail_data
WHERE
    EXTRACT(YEAR FROM "Date") = 2023
    AND EXTRACT(MONTH FROM "Date") IN (6)
GROUP BY
    DATE_TRUNC('month', "Date"),
    "CategoryName",
    "StoreName"
ORDER BY
    "Month" ASC,
    "Revenue" ASC;
	
-- Month 9
SELECT
    TO_CHAR(DATE_TRUNC('month', "Date"), 'YYYY-MM') AS "Month",
    "CategoryName",
    "StoreName",
    ROUND((SUM("TotalAmount"))::numeric,2) AS "Revenue",
    SUM("Quantity") AS "Units_Sold",
    COUNT(*) AS "Transactions",
    ROUND((AVG("DiscountApplied"))::numeric, 2) AS "Avg_Discount"
FROM
    retail_data
WHERE
    EXTRACT(YEAR FROM "Date") = 2023
    AND EXTRACT(MONTH FROM "Date") IN (9)
GROUP BY
    DATE_TRUNC('month', "Date"),
    "CategoryName",
    "StoreName"
ORDER BY
    "Month" ASC,
    "Revenue" ASC;

--6. Transaction and Quantity in High Revenue Month (5)
SELECT
    TO_CHAR(DATE_TRUNC('month', "Date"), 'YYYY-MM') AS "Month",
    "CategoryName",
    "StoreName",
    ROUND((SUM("TotalAmount"))::numeric,2) AS "Revenue",
    SUM("Quantity") AS "Units_Sold",
    ROUND((AVG("DiscountApplied"))::numeric, 2) AS "Avg_Discount",
    ROUND((SUM("TotalAmount") / NULLIF(SUM("Quantity"), 0))::numeric, 2) AS "Avg_Price"
FROM
    retail_data
WHERE
    EXTRACT(YEAR FROM "Date") = 2023
    AND EXTRACT(MONTH FROM "Date") IN (5)
GROUP BY
    DATE_TRUNC('month', "Date"),
    "CategoryName",
    "StoreName"
ORDER BY
    "Month" ASC,
    "Revenue" DESC;

-- Month 10
SELECT
    TO_CHAR(DATE_TRUNC('month', "Date"), 'YYYY-MM') AS "Month",
    "CategoryName",
    "StoreName",
    ROUND((SUM("TotalAmount"))::numeric,2) AS "Revenue",
    SUM("Quantity") AS "Units_Sold",
    ROUND((AVG("DiscountApplied"))::numeric, 2) AS "Avg_Discount",
    ROUND((SUM("TotalAmount") / NULLIF(SUM("Quantity"), 0))::numeric, 2) AS "Avg_Price"
FROM
    retail_data
WHERE
    EXTRACT(YEAR FROM "Date") = 2023
    AND EXTRACT(MONTH FROM "Date") IN (10)
GROUP BY
    DATE_TRUNC('month', "Date"),
    "CategoryName",
    "StoreName"
ORDER BY
    "Month" ASC,
    "Revenue" DESC;

	
--7. Kategori Paling Fluktuatif vs Stabil
WITH MonthlyCategory AS (
    SELECT
        DATE_TRUNC('month', "Date") AS "Month_Trunc",
        "CategoryName",
        SUM("TotalAmount") AS "Revenue"
    FROM retail_data
    WHERE EXTRACT(YEAR FROM "Date") = 2023
    GROUP BY DATE_TRUNC('month', "Date"), "CategoryName"
)
SELECT
    "CategoryName",
    ROUND((AVG("Revenue"))::numeric, 2) AS "Avg_Monthly_Revenue",
    ROUND((STDDEV("Revenue"))::numeric, 2) AS "StdDev_Revenue",
    ROUND((MIN("Revenue"))::numeric, 2) AS "Min_Revenue",
    ROUND((MAX("Revenue"))::numeric, 2) AS "Max_Revenue",
    ROUND(((MAX("Revenue") - MIN("Revenue")) / NULLIF(AVG("Revenue"), 0) * 100)::numeric, 2) AS "Volatility_%",
    CASE
        WHEN STDDEV("Revenue") > (SELECT AVG(stddev_val) FROM (
            SELECT STDDEV("Revenue") AS stddev_val
            FROM MonthlyCategory
            GROUP BY "CategoryName"
        ) sub)
        THEN 'Fluktuatif'
        ELSE 'Stabil'
    END AS "Stability_Status"
FROM MonthlyCategory
GROUP BY "CategoryName"
ORDER BY "StdDev_Revenue" DESC;

--8. Toko Benchmark & Toko Terlemah
SELECT
    "StoreName",
    "City",
    ROUND((SUM("TotalAmount"))::numeric, 2) AS "Total_Revenue",
    SUM("Quantity") AS "Total_Units",
    COUNT(*) AS "Total_Transactions",
    ROUND((SUM("TotalAmount") / NULLIF(COUNT(*), 0))::numeric, 2) AS "Avg_Transaction_Value",
    ROUND((SUM("TotalAmount") / NULLIF(SUM("Quantity"), 0))::numeric, 2) AS "Avg_Price_Per_Unit",
    ROUND((SUM("TotalAmount") * 100.0 / SUM(SUM("TotalAmount")) OVER ())::numeric, 2) AS "Contribution_%",
    RANK() OVER (ORDER BY SUM("TotalAmount") DESC) AS "Revenue_Rank"
FROM retail_data
WHERE EXTRACT(YEAR FROM "Date") = 2023
GROUP BY "StoreName", "City"
ORDER BY "Revenue_Rank" ASC;

--9. Driver Utama Revenue (Ranking Kombinasi Category × Store)
SELECT
    "CategoryName",
    "StoreName",
    ROUND((SUM("TotalAmount"))::numeric, 2) AS "Total_Revenue",
    SUM("Quantity") AS "Total_Units",
    COUNT(*) AS "Total_Transactions",
    ROUND((SUM("TotalAmount") / NULLIF(SUM("Quantity"), 0))::numeric, 2) AS "Avg_Price_Per_Unit",
    ROUND((SUM("TotalAmount") * 100.0 / SUM(SUM("TotalAmount")) OVER ())::numeric, 2) AS "Contribution_%",
    RANK() OVER (ORDER BY SUM("TotalAmount") DESC) AS "Revenue_Rank"
FROM retail_data
WHERE EXTRACT(YEAR FROM "Date") = 2023
GROUP BY "CategoryName", "StoreName"
ORDER BY "Revenue_Rank" ASC;

--10. Performa Bulanan per Kategori (dengan Growth)
WITH MonthlyCategory AS (
    SELECT
        DATE_TRUNC('month', "Date") AS "Month_Trunc",
        "CategoryName",
        SUM("TotalAmount") AS "Revenue"
    FROM retail_data
    WHERE EXTRACT(YEAR FROM "Date") = 2023
    GROUP BY DATE_TRUNC('month', "Date"), "CategoryName"
)
SELECT
    TO_CHAR("Month_Trunc", 'YYYY-MM') AS "Month",
    "CategoryName",
    ROUND(("Revenue")::numeric, 2) AS "Revenue",
    ROUND((LAG("Revenue") OVER (PARTITION BY "CategoryName" ORDER BY "Month_Trunc"))::numeric, 2) AS "Prev_Revenue",
    ROUND(
        COALESCE(
            (("Revenue" - LAG("Revenue") OVER (PARTITION BY "CategoryName" ORDER BY "Month_Trunc"))
            / NULLIF(LAG("Revenue") OVER (PARTITION BY "CategoryName" ORDER BY "Month_Trunc"), 0) * 100)::numeric,
            0
        ), 2
    ) AS "MoM_Growth_%"
FROM MonthlyCategory
ORDER BY "CategoryName" ASC, "Month_Trunc" ASC;

--11. Hubungan Quantity vs Revenue per Kategori
SELECT
    "CategoryName",
    SUM("Quantity") AS "Total_Units",
    ROUND((SUM("TotalAmount"))::numeric, 2) AS "Total_Revenue",
    ROUND((SUM("TotalAmount") / NULLIF(SUM("Quantity"), 0))::numeric, 2) AS "Revenue_Per_Unit",
    ROUND((AVG("Quantity"))::numeric, 2) AS "Avg_Units_Per_Transaction",
    CASE
        WHEN SUM("Quantity") > (SELECT AVG(qty) FROM (SELECT SUM("Quantity") AS qty FROM retail_data WHERE EXTRACT(YEAR FROM "Date") = 2023 GROUP BY "CategoryName") sub)
             AND SUM("TotalAmount") > (SELECT AVG(rev) FROM (SELECT SUM("TotalAmount") AS rev FROM retail_data WHERE EXTRACT(YEAR FROM "Date") = 2023 GROUP BY "CategoryName") sub)
        THEN 'Star (High Vol, High Rev)'
        WHEN SUM("TotalAmount") > (SELECT AVG(rev) FROM (SELECT SUM("TotalAmount") AS rev FROM retail_data WHERE EXTRACT(YEAR FROM "Date") = 2023 GROUP BY "CategoryName") sub)
        THEN 'Cash Cow (Low Vol, High Rev)'
        WHEN SUM("Quantity") > (SELECT AVG(qty) FROM (SELECT SUM("Quantity") AS qty FROM retail_data WHERE EXTRACT(YEAR FROM "Date") = 2023 GROUP BY "CategoryName") sub)
        THEN 'Question Mark (High Vol, Low Rev)'
        ELSE 'Dog (Low Vol, Low Rev)'
    END AS "Product_Matrix"
FROM retail_data
WHERE EXTRACT(YEAR FROM "Date") = 2023
GROUP BY "CategoryName"
ORDER BY "Total_Revenue" DESC;

--12. Detail Harga & Diskon per Produk per Bulan
SELECT
    TO_CHAR(DATE_TRUNC('month', "Date"), 'YYYY-MM') AS "Month",
    "CategoryName",
    "ProductName",
    SUM("Quantity") AS "Total_Units",
    ROUND((SUM("TotalAmount"))::numeric, 2) AS "Total_Revenue",
    ROUND((SUM("TotalAmount") / NULLIF(SUM("Quantity"), 0))::numeric, 2) AS "Avg_Price_Per_Unit",
    ROUND((AVG("PricePerUnit"))::numeric, 2) AS "Avg_Listed_Price",
    ROUND((AVG("DiscountApplied"))::numeric, 2) AS "Avg_Discount_%",
    ROUND((SUM("TotalAmount") * 100.0 / SUM(SUM("TotalAmount")) OVER (PARTITION BY DATE_TRUNC('month', "Date")))::numeric, 2) AS "Contribution_%"
FROM
    retail_data
WHERE
    EXTRACT(YEAR FROM "Date") = 2023
GROUP BY
    DATE_TRUNC('month', "Date"),
    "CategoryName",
    "ProductName"
ORDER BY
    "CategoryName" ASC,
    "ProductName" ASC,
    DATE_TRUNC('month', "Date") ASC;