CREATE DATABASE IF NOT EXISTS supermarketsale;
USE supermarketsale;
-- DROP TABLE IF EXISTS supermarketsale;
DROP TABLE IF EXISTS Geocery;
-- create table 
CREATE TABLE Geocery (
	OrderID VARCHAR (15),
    OrderDate DATE,
    GrossMarginPercentage FLOAT (15),
    CustomerID VARCHAR (8),
    CustomerName VARCHAR (50),
    Segment TEXT (15),
    Country TEXT (15),
    City TEXT (50),
    State VARCHAR (20),
    PostalCode INT (5),
    Region TEXT (10),
    ProductID VARCHAR (25),
    Category VARCHAR (40),
    SubCategory VARCHAR (40),
    Sales INT (5),
    Discount FLOAT (4),
    Profit FLOAT (10),
    InvoiceID VARCHAR (12),
    PaymentType TEXT (15)
);

-- Loading script
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/tai.csv'
INTO TABLE Geocery
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(OrderID, @OrderDate, GrossMarginPercentage, CustomerID, CustomerName, Segment, Country, City, State, @PostalCode, Region, ProductID, Category, SubCategory, Sales, Discount, Profit, InvoiceID, PaymentType)
SET OrderDate = STR_TO_DATE(@OrderDate, '%d/%m/%Y'),
    PostalCode = NULLIF(@PostalCode, '');
    
-- total profit and sales in the data
SELECT Category, SUM(Profit) AS Total_Profit, SUM(Sales) AS Total_Sales
FROM Geocery
WHERE Category IN ('Bakery', 'Oil and Masala', 'Snacks') AND YEAR(OrderDate) = 2016
GROUP BY Category
ORDER BY Total_Profit ASC;

-- total sales product with total profit from every sales
SELECT Category,
  SUM(Sales) AS Total_Sales,
  SUM(Profit) AS Total_Profit,
  SUM(Discount) AS Total_Discount
FROM Geocery
WHERE YEAR(OrderDate) IN (2017, 2018)
GROUP BY Category
ORDER BY Category ASC;

-- Indexing script
CREATE INDEX index_OrderID ON Geocery (OrderID);
CREATE INDEX index_OrderDate ON Geocery (OrderDate);
CREATE INDEX index_GrossMarginPercentage ON Geocery (GrossMarginPercentage);
CREATE INDEX index_CustomerID ON Geocery (CustomerID);
CREATE INDEX index_CustomerName ON Geocery (CustomerName);
CREATE INDEX index_Segment ON Geocery (Segment(15));
CREATE INDEX index_Country ON Geocery (Country(15));
CREATE INDEX index_City ON Geocery (City(50));
CREATE INDEX index_State ON Geocery (State);
CREATE INDEX index_PostalCode ON Geocery (PostalCode);
CREATE INDEX index_Region ON Geocery (Region(10));
CREATE INDEX index_ProductID ON Geocery (ProductID);
CREATE INDEX index_Category ON Geocery (Category);
CREATE INDEX index_SubCategory ON Geocery (SubCategory);
CREATE INDEX index_Sales ON Geocery (Sales);
CREATE INDEX index_Discount ON Geocery (Discount);
CREATE INDEX index_Profit ON Geocery (Profit); 
CREATE INDEX index_InvoiceID ON Geocery (InvoiceID);
CREATE INDEX index_PaymentType ON Geocery (PaymentType(15));

-- View Update script
CREATE OR REPLACE VIEW UserView1 AS
SELECT OrderID, OrderDate, CustomerName, Category, Sales
FROM Geocery;

CREATE OR REPLACE VIEW UserView2 AS
SELECT *
FROM Geocery
WHERE Sales > 1000 AND Profit > 500;

SELECT * FROM UserView1;
SELECT * FROM UserView2;


-- total sales product with total profit from 2017-2018
SELECT Category, AVG(Profit) AS Average_Profit, SUM(Sales) AS Total_Sales, MAX(Sales) AS Peak_Sale
FROM Geocery
WHERE YEAR(OrderDate) BETWEEN 2017 AND 2018
GROUP BY Category
ORDER BY Total_Sales DESC
LIMIT 1;

SELECT Category, AVG(Profit) AS Average_Profit, SUM(Sales) AS Total_Sales, MAX(Sales) AS Peak_Sale
FROM Geocery
GROUP BY Category
ORDER BY Total_Sales DESC
LIMIT 1;

-- Insert value
INSERT INTO Geocery (OrderID, OrderDate, GrossMarginPercentage, CustomerID, CustomerName, Segment, Country, City, State, PostalCode, Region, ProductID, Category, SubCategory, Sales, Discount, Profit, InvoiceID, PaymentType )
VALUES ('CA-2022-1270', (STR_TO_DATE('19/11/2022', '%d/%m/%Y')), 4.761904762, 'KP-11271', 'Senyai', 'Consumer', 'Thailand', 'Bangkoko', 'Bangkok', '11172', 'Central', 'MTS-OS-10007265', 'Bakery', 'Brownie', 21, 0.22, 27.6, 'IN1-662-1552', 'Ewallet'),
	   ('CA-2022-9488', (STR_TO_DATE('24/10/2022', '%d/%m/%Y')), 4.761904762, 'VN-89468', 'TuaRainbow', 'Consumer', 'Thailand', 'Bangkok', 'Bangkok', '14132', 'Central', 'TNV-JU-74394629', 'Bakery', 'Rainbow cake', 3, 0.49, 18.2, 'IN4-834-6431', 'Cash'),
       ('CA-2022-5573', (STR_TO_DATE('28/10/2022', '%d/%m/%Y')), 4.761904762, 'DS-37283', 'Jackgiant', 'Consumer', 'Thailand', 'Bangkok', 'Bangkok', '70028', 'Central', 'SHD-LW-83729930', 'Food Grains', 'Organic Staples', 2, 0.89, 38.3, 'IN3-758-7293', 'Credit Card');
       
SELECT * FROM Geocery;

-- Create, Insert, Update Table 'Cashiers'
DROP TABLE IF EXISTS SaleData;
CREATE TABLE Cashiers (
  CashiersID VARCHAR(10) PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  ShopPosition VARCHAR(50)
);

INSERT INTO Cashierss (CashiersID, FirstName, LastName, ShopPosition)
VALUES ('CS-678-608', 'Susan', 'Suay', 'Cashier'),
       ('CS-739-832', 'Happy', 'Holiday', 'Chief Cashier'),
       ('CS-830-493', 'Enjoy', 'Eating', 'Chief Cashier');

SELECT * FROM Cashiers;

UPDATE Cashiers
SET ShopPosition = 'Cashier'
WHERE CashiersID = 'CS-739-832';


DROP VIEW IF EXISTS UpdatedCashiers;
CREATE VIEW UpdatedCashiers AS
SELECT * FROM Employees;

UPDATE UpdatedCashiers
SET ShopPosition = 'Cashier'
WHERE CashiersID = 'CS-739-832';

SELECT * FROM UpdatedCashiers;
