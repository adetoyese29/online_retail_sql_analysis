SELECT *
FROM online_retail
LIMIT 50;

--Analysing KPIS

-- KPI 1: TOTAL SALES NET REVENUE

SELECT
	CAST(SUM(quantity * unitprice)/1000000 AS DECIMAL(10,2)) AS TOTALNETREVENUE
FROM online_retail
WHERE InvoiceNo NOT LIKE 'C%';

-- KPI 2: TOTAL NO OF CUSTOMERS

SELECT
	COUNT(DISTINCT(online_retail.customerid)) AS TOTALCUSTOMERS
FROM online_retail;

-- KPI 3: TOTAL NO OF COMPLETED TRANSACTIONS

SELECT 
	COUNT(DISTINCT(online_retail.invoiceno)) AS TOTALTRANSACTIONS
FROM online_retail
WHERE InvoiceNo NOT LIKE 'C%';

-- KPI 4: TOTAL NO OF STOCKS

SELECT
	COUNT(DISTINCT(online_retail.stockcode)) AS TOTALNOOFSTOCKS
FROM online_retail;

--KPI 5: TOTAL QUANTITY OF STOCKS BOUGHT

SELECT
	CAST(SUM(quantity)/1000000 AS DECIMAL(10,2)) AS TOTALSTOCKSBOUGHT
FROM online_retail
WHERE QUANTITY > 0;

-- KPI 6: What is the average spend per customer?

SELECT
	SUM(quantity * unitprice)/COUNT(DISTINCT(online_retail.customerid)) AS AVGSPEND
FROM online_retail
WHERE quantity>0;

-- KPI 7: Average Order Value (AOV)

SELECT
	SUM(quantity * unitprice)/COUNT(DISTINCT(online_retail.invoiceno)) AS AVGORDERVALUE
FROM online_retail
WHERE InvoiceNo NOT LIKE 'C%';

-- KPI 8: Cancellation Rate 

SELECT
	SUM(CASE WHEN invoiceno LIKE 'C%' THEN 1 ELSE 0 END) *100.0 /COUNT(invoiceno) AS CANCELLATIONRATE
FROM online_retail;

-- ANSWERING BUSINESS QUESTIONS

-- QUESTION 1: What are the best-selling products based on revenue?
SELECT
	description,
	SUM(quantity * unitprice) AS REVENUE
FROM online_retail
WHERE quantity >0
GROUP BY description
ORDER BY REVENUE DESC
LIMIT 10;

-- QUESTION 2: What are the best-selling products based on quantity?
SELECT
	description,
	SUM(quantity) AS QUANTITY
FROM online_retail
WHERE quantity > 0
GROUP BY description
ORDER BY QUANTITY DESC
LIMIT 10;

-- QUESTION 3: Who are the top customers based on total spend?
SELECT
	customerid,
	SUM(unitprice * quantity) AS TOTALSPEND
FROM online_retail
WHERE quantity > 0 AND customerid IS NOT NULL
GROUP BY customerid
ORDER BY TOTALSPEND DESC
LIMIT 10;

-- QUESTION 4: Customer Segmentation → Based on Recency, Frequency, and Monetary Value (RFM Analysis)
-- Extracting the max date from the dataset
WITH LATESTDATE AS( 
	SELECT MAX(date) AS MAXDATE FROM online_retail
), 
-- Calculating the RFM 
RFM AS (
	SELECT
		O.customerid,
		AGE(D.MAXDATE, MAX(O.date))AS RECENCY,
		COUNT(DISTINCT invoiceno) AS FREQUENCY,
		SUM(O.unitprice * O.quantity) AS MONETARY
	FROM online_retail AS O
	CROSS JOIN  LATESTDATE AS D -- Joining the max date to the online_retail table
	WHERE O.quantity > 0
	GROUP BY O.customerid, D.MAXDATE
	ORDER BY RECENCY ASC
),
-- Grouping the RFM values into 4 and assigning scores to them
RFMSCORES AS(
	SELECT 
		customerid,
		NTILE(4) OVER(ORDER BY RECENCY DESC) AS RECENCYSCORE,
		NTILE(4) OVER(ORDER BY FREQUENCY ASC) AS FREQUENCYSCORE,
		NTILE(4) OVER(ORDER BY MONETARY ASC) AS MONETARYSCORE
	FROM RFM
	GROUP BY customerid, RECENCY, FREQUENCY, MONETARY
),
-- Calculating the RFM total scores
RFM_SCORES AS(
	SELECT
		*,
		RECENCYSCORE + FREQUENCYSCORE + MONETARYSCORE AS RFM_SCORES
	FROM RFMSCORES
),
-- Classifying the RFM scores into segments
RFMSEGMENTS AS(
	SELECT
		*,
		CASE
			WHEN RFM_SCORES = 12 THEN 'VIP Customers'
			WHEN RFM_SCORES >= 9 THEN 'Loyal Customers'
			WHEN RFM_SCORES >= 6 THEN 'Potential Customers'
			ELSE 'At Risk'
		END AS CUSTOMERSEGMENT
	FROM RFM_SCORES
	GROUP BY customerid, RECENCYSCORE, FREQUENCYSCORE, MONETARYSCORE, RFM_SCORES, CUSTOMERSEGMENT
	ORDER BY RFM_SCORES DESC
)
SELECT *
FROM RFMSEGMENTS

-- QUESTION 5: Top-Selling Products by Country

SELECT DISTINCT ON (country) 
    country, 
    stockcode,  
    SUM(unitprice * quantity) AS totalsales  
FROM online_retail  
WHERE quantity > 0  
GROUP BY country, stockcode  
ORDER BY country, totalsales DESC;

-- QUESTION 6: Which countries contribute the most revenue?

SELECT DISTINCT
    country,   
    SUM(unitprice * quantity) AS totalsales  
FROM online_retail  
WHERE quantity > 0  
GROUP BY country   
ORDER BY totalsales DESC
LIMIT 10;

