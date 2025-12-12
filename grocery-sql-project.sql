CREATE DATABASE GROCERYSTOREMANAGEMENT2;
USE  GROCERYSTOREMANAGEMENT2;

-- 1. Supplier Table
CREATE TABLE IF NOT EXISTS SUPPLIER1(
    sup_id TINYINT PRIMARY KEY AUTO_INCREMENT,
    sup_name VARCHAR(255),
    address TEXT
);
INSERT INTO SUPPLIER1 (sup_name, address) VALUES
('Alpha Traders', 'Hyderabad'),
('Global Supplies', 'Mumbai'),
('Sunshine Exports', 'Chennai'),
('Blue Star Industries', 'Bangalore'),
('Prime Suppliers', 'Delhi'),
('Nova Enterprises', 'Pune'),
('Victory Distributors', 'Kolkata');


-- 2. Categories Table
CREATE TABLE IF NOT EXISTS CATEGORIES1 (
    cat_id TINYINT PRIMARY KEY AUTO_INCREMENT,
    cat_name VARCHAR(255)
);

INSERT INTO CATEGORIES1 (cat_name) VALUES
('Electronics'),
('Groceries'),
('Clothing'),
('Furniture'),
('Sports'),
('Stationery'),
('Automotive');

-- 3. Employees Table
CREATE TABLE IF NOT EXISTS EMPLOYEES1 (
    emp_id TINYINT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(255),
    hire_date VARCHAR(255)
);
INSERT INTO EMPLOYEES1 (emp_name, hire_date) VALUES
('Rahul Sharma', '2021-02-15'),
('Swathi Reddy', '2020-10-09'),
('Amit Verma', '2022-06-21'),
('Priya Singh', '2019-12-30'),
('Kiran Kumar', '2023-04-18'),
('Neha Joshi', '2021-08-11'),
('Rohit Mehta', '2024-01-05');

-- 4. Customers Table
CREATE TABLE IF NOT EXISTS CUSTOMERS1 (
    cust_id SMALLINT PRIMARY KEY AUTO_INCREMENT,
    cust_name VARCHAR(255),
    address TEXT
);
INSERT INTO CUSTOMERS1 (cust_name, address) VALUES
('Arjun Rao', 'Hyderabad'),
('Meena Devi', 'Chennai'),
('Vikram Patel', 'Mumbai'),
('Sita Ram', 'Bangalore'),
('Lakshmi Narayan', 'Delhi'),
('Rohan Gupta', 'Pune'),
('Kavya Iyer', 'Kolkata');

-- 5. Products Table
CREATE TABLE IF NOT EXISTS PRODUCTS2 (
    prod_id TINYINT PRIMARY KEY AUTO_INCREMENT,
    prod_name VARCHAR(255),
    sup_id TINYINT,
    cat_id TINYINT,
    price DECIMAL(10,2),
    FOREIGN KEY (sup_id) REFERENCES supplier1(sup_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (cat_id) REFERENCES categories1(cat_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO PRODUCTS2 (prod_name, sup_id, cat_id, price) VALUES
('LED TV 42 Inch', 1, 1, 32999.00),
('Organic Rice 10kg', 2, 2, 799.00),
('Men Casual Shirt', 3, 3, 999.00),
('Wooden Dining Table', 4, 4, 15999.00),
('Cricket Bat', 5, 5, 1499.00),
('A4 Paper Pack', 6, 6, 299.00),
('Car Cleaning Kit', 7, 7, 899.00);


-- 6. Orders Table
CREATE TABLE IF NOT EXISTS ORDERS2(
    ord_id SMALLINT PRIMARY KEY AUTO_INCREMENT,
    cust_id SMALLINT,
    emp_id TINYINT,
    order_date VARCHAR(255),
    FOREIGN KEY (cust_id) REFERENCES customers1(cust_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (emp_id) REFERENCES employees1(emp_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO ORDERS2 (cust_id, emp_id, order_date) VALUES
(1, 3, '2024-01-12'),
(2, 1, '2024-02-05'),
(3, 6, '2024-03-18'),
(4, 2, '2024-04-22'),
(5, 7, '2024-05-10'),
(6, 4, '2024-06-14'),
(7, 5, '2024-07-01');


-- 7. Order_Details Table
CREATE TABLE IF NOT EXISTS order_details1 (
    ord_detID SMALLINT AUTO_INCREMENT PRIMARY KEY,
    ord_id SMALLINT,
    prod_id TINYINT,
    quantity TINYINT,
    each_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    FOREIGN KEY (ord_id) REFERENCES orders2(ord_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (prod_id) REFERENCES products2(prod_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO order_details1 (ord_id, prod_id, quantity, each_price, total_price) VALUES
(1, 1, 1, 32999.00, 32999.00),     
(2, 2, 2, 799.00, 1598.00),        
(3, 3, 3, 999.00, 2997.00),        
(4, 4, 1, 15999.00, 15999.00),     
(5, 5, 2, 1499.00, 2998.00),       
(6, 6, 5, 299.00, 1495.00),       
(7, 7, 1, 899.00, 899.00);       

-- 1️. Customer Insights
-- How many unique customers have placed orders?
SELECT COUNT(DISTINCT C.CUST_ID) AS UNIQUECUSTOMERS
FROM CUSTOMERS1 C
JOIN ORDERS2 O
ON C.CUST_ID=O.CUST_ID;

-- Which customers have placed the highest number of orders?
SELECT C.CUST_ID,C.CUST_NAME,COUNT(O.ORD_ID) AS TOTALORDERS
FROM CUSTOMERS1 C
JOIN ORDERS2 O
ON C.CUST_ID=O.CUST_ID
GROUP BY C.CUST_ID
ORDER BY TOTALORDERS DESC
LIMIT 3;

-- What is the total and average purchase value per customer?
SELECT C.CUST_NAME,SUM(OD.TOTAL_PRICE) AS TOTALPRICE,AVG(OD.TOTAL_PRICE) AS AVERAGEPRICE
FROM CUSTOMERS1 C
JOIN ORDERS2 O
ON C.CUST_ID=O.CUST_ID
JOIN ORDER_DETAILS1 OD
ON OD.ORD_ID=OD.ORD_ID
GROUP BY C.CUST_ID,C.CUST_NAME;

-- Who are the top 5 customers by total purchase amount?
SELECT C.CUST_ID,C.CUST_NAME,SUM(OD.TOTAL_PRICE) AS TOTALAMOUNT
FROM CUSTOMERS1 C
JOIN ORDERS2 O
ON C.CUST_ID=O.CUST_ID
JOIN ORDER_DETAILS1 OD
ON O.ORD_ID=OD.ORD_ID
GROUP BY C.CUST_ID,C.CUST_NAME
ORDER BY TOTALAMOUNT DESC
LIMIT 5;

-- 2. Product Performance
-- How many products exist in each category?
SELECT C.CAT_NAME,COUNT(P.PROD_ID) AS TOTALPRODUCTS
FROM CATEGORIES1 C 
LEFT JOIN PRODUCTS2 P
ON C.CAT_ID=P.CAT_ID
GROUP BY C.CAT_ID,C.CAT_NAME;

-- What is the average price of products by category?

SELECT C.CAT_NAME,AVG(P.PRICE) AS AVERAGEPRICE
FROM CATEGORIES1 C
JOIN PRODUCTS2 P 
ON C.CAT_ID=P.CAT_ID
GROUP BY C.CAT_NAME;

-- Which products have the highest total sales volume (by quantity)?
select p.prod_name,
sum(od.quantity) as total_quantity_sold
from products2 p
join order_details1 od on p.prod_id = od.prod_id
group by p.prod_id, p.prod_name
order by total_quantity_sold desc;

-- What is the total revenue generated by each product?
SELECT P.prod_name,SUM(OD.total_price) AS total_revenue
FROM products2 P
JOIN order_details1 OD ON P.prod_id = OD.prod_id
GROUP BY P.prod_id, P.prod_name;


-- How do product sales vary by category and supplier?
SELECT C.cat_name,S.sup_name,
SUM(OD.total_price) AS total_sales,
SUM(OD.quantity) AS total_quantity_sold
FROM categories1 C
JOIN products2 P ON C.cat_id = P.cat_id
JOIN supplier1 S  ON P.sup_id = S.sup_id
JOIN order_details1 OD ON P.prod_id = OD.prod_id
GROUP BY C.cat_name, S.sup_name
ORDER BY C.cat_name, total_sales DESC;

-- . Sales and Order Trends
-- How many orders have been placed in total?
SELECT  COUNT(*) AS TOTALORDERS
FROM ORDERS2;

-- What is the average value per order?
SELECT SUM(total_price) AS order_total,
AVG(each_price) AS average_unit_price
FROM order_details1;

-- On which dates were the most orders placed?
SELECT ORDER_DATE,COUNT(*) AS MAXORDERS
FROM ORDERS2 
GROUP BY ORDER_DATE
ORDER BY MAXORDERS DESC;

-- What are the monthly trends in order volume and revenue?
SELECT MONTH(O.ORDER_DATE) AS MONTHLYTRENDS, SUM(OD.QUANTITY) AS ORDERVOLUME,
SUM(OD.TOTAL_PRICE) AS REVENUE
FROM ORDERS2 O
JOIN ORDER_DETAILS1 OD
ON O.ORD_ID=OD.ORD_ID
GROUP BY MONTH(O.ORDER_DATE)
ORDER BY MONTH(O.ORDER_DATE);

-- How do order patterns vary across weekdays and weekends?
SELECT 
    DAYNAME(order_date) AS weekday_name,
    COUNT(*) AS total_orders
FROM ORDERS2
GROUP BY DAYNAME(order_date)
ORDER BY FIELD(weekday_name, 
        'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

-- 4️. Supplier Contribution
-- How many suppliers are there in the database?
SELECT COUNT(*) FROM SUPPLIER1;

-- Which supplier provides the most products?
SELECT S.sup_name,
       S.sup_id,
       COUNT(P.prod_id) AS product_counts
FROM supplier1 S
JOIN products2 P ON P.sup_id = S.sup_id
GROUP BY S.sup_id, S.sup_name
ORDER BY product_counts DESC
LIMIT 1;

-- What is the average price of products from each supplier?
SELECT S.SUP_ID,S.SUP_NAME,AVG(P.PRICE) AS AVGPRICE
FROM PRODUCTS2 P
JOIN SUPPLIER1 S
ON S.SUP_ID=P.SUP_ID
GROUP BY S.SUP_ID;

-- Which suppliers contribute the most to total product sales (by revenue)?
SELECT S.sup_id,S.sup_name,SUM(OD.total_price) AS total_revenue
FROM SUPPLIER1 S
JOIN PRODUCTS2 P
ON S.sup_id = P.sup_id
JOIN ORDER_DETAILS1 OD
ON P.prod_id = OD.prod_id
GROUP BY S.sup_id
ORDER BY total_revenue DESC
LIMIT 1;

-- 5️. Employee Performance
-- How many employees have processed orders?
SELECT COUNT(DISTINCT emp_id)
FROM ORDERS2;

-- Which employees have handled the most orders?
SELECT E.emp_name,
       E.emp_id,
       COUNT(O.ord_id) AS most_orders
FROM employees1 E
JOIN orders2 O ON E.emp_id = O.emp_id
GROUP BY E.emp_id, E.emp_name
ORDER BY most_orders DESC
LIMIT 1;


-- What is the total sales value processed by each employee?
SELECT E.EMP_ID,E.emp_name,SUM(OD.total_price) AS total_sales_value
FROM EMPLOYEES1 E
JOIN ORDERS2 O
ON E.emp_id = O.emp_id
JOIN ORDER_DETAILS1 OD
ON O.ord_id = OD.ord_id
GROUP BY E.emp_id, E.emp_name
ORDER BY total_sales_value DESC;

-- What is the average order value handled per employee?
SELECT E.emp_name,AVG(OD.total_price) AS total_sales_value
FROM EMPLOYEES1 E
JOIN ORDERS2 O
ON E.emp_id = O.emp_id
JOIN ORDER_DETAILS1 OD
ON O.ord_id = OD.ord_id
GROUP BY E.emp_id, E.emp_name
ORDER BY total_sales_value DESC;

-- 6️. Order Details Deep Dive
-- What is the relationship between quantity ordered and total price?
SELECT quantity,
AVG(total_price) AS avg_total_price,
SUM(total_price) AS sum_total_price
FROM ORDER_DETAILS1
GROUP BY quantity
ORDER BY quantity;

-- What is the average quantity ordered per product?
SELECT P.PROD_NAME,AVG(OD.quantity) AS avg_total_price
FROM PRODUCTS2 P
JOIN ORDER_DETAILS1 OD
ON P.PROD_ID=OD.PROD_ID
GROUP BY P.PROD_NAME
ORDER BY avg_total_price DESC;

-- How does the unit price vary across products and orders?
SELECT P.prod_name,OD.ord_id,P.price AS product_list_price,
OD.each_price AS order_unit_price
FROM PRODUCTS2 P
JOIN ORDER_DETAILS1 OD
ON P.prod_id = OD.prod_id
ORDER BY P.prod_name, OD.ord_id;