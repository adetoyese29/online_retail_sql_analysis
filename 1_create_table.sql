-- Create online_retail table

DROP TABLE IF EXISTS online_retail;
CREATE TABLE online_retail
(
	InvoiceNo VARCHAR(10),
	StockCode VARCHAR(15),
	Description TEXT,
	Quantity INT,
	InvoiceDate TIMESTAMP,
	Date DATE,
	Time TIME,
	UnitPrice DECIMAL(10,2),
	CustomerID VARCHAR(10),
	Country VARCHAR(30)
);

SELECT *
FROM online_retail
LIMIT 20;
