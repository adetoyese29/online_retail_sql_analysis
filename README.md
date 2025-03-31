E-commerce SQL Analysis

Project Overview
This project involves analyzing a UK based online_retail store (with majority of the customers beign wholesalers) transaction data using SQL. 
The dataset contains order details, including product information, sales transactions, and customer purchases. The objective is to derive insights such as sales trends, product performance, and customer behavior.

Assumptions
For every Negative Values under the Quantity column (`Quantity < 0`):
  - If the `InvoiceNo` starts with 'C', it is assumed to be a cancellation.
  - If the `InvoiceNo` does not start with 'C', it is assumed to be a refund.

Dataset Columns
| Column Name   | Description |
|--------------|-------------|
| InvoiceNo | Unique identifier for each transaction. Transactions starting with 'C' indicate cancellations. |
| StockCode | Unique product identifier. |
| Description | Name or description of the product. |
| Quantity | Number of units purchased. Negative values indicate returns or cancellations. |
| InvoiceDate | Timestamp of the transaction. |
| Date | Extracted date from `InvoiceDate`. |
| Time | Extracted time from `InvoiceDate`. |
| UnitPrice | Price per unit of the product. |
| CustomerID | Unique identifier for customers. Some entries may be missing. |
| Country | Country where the transaction took place. |

