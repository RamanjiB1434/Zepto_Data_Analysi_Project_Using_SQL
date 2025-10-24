drop table if exists Zepto;

create table Zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);

-- data exploration ---

-- 1. Count of Rows
SELECT COUNT(*) FROM zepto;

-- 2. Sample Data
SELECt * FROM zepto
LIMIT 5;

-- Checking for Null Values
SELECT * FROM zepto
WHERE name is NULL
OR
category is NULL
OR
mrp is NULL
OR
availableQuantity is NULL
OR
discountedSellingPrice is NULL
OR
weightInGms is NULL
OR
outOfStock is NULL
OR
quantity is NULL;

-- 4. Different Product Categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- 5. Count of different Product categories
SELECT 
    category,
    COUNT( category) AS distinct_category_count
FROM zepto
GROUP BY category
ORDER BY category DESC;

-- 6. Product in Stock vs out of stock
SELECT outOfStock, COUNT(*)
FROM zepto
GROUP BY outOfStock;

-- 7. Product Name present in multiple times
SELECT name as Product_Name,
	COUNT(*) as occurence_count
	FROM zepto
GROUP BY name
HAVING COUNT(*)>1
ORDER BY 2 DESC;

-- Data Cleaning --
-- 1. products with price=0
SELECT * FROM zepto
WHERE mrp=0 OR discountedSellingPrice=0

-- 2. Standardize the data / convert paise to rupees
UPDATE zepto
SET mrp=mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp,discountedSellingPrice FROM zepto;

-- Data Analysis ---
-- 1. Find the top 10 best-value products based on the discount percentage.
SELECT 
	name as Product_Name,
	discountPercent as Discount_Percentage
FROM zepto
ORDER BY 2 DESC
LIMIT 10
				-- OR--
SELECT 
	category,
	name as product_name,
	discountPercent as discount_percentage,
	ROW_NUMBER() OVER (PARTION BY category ORDER BY discount_percentage DESC)
FROM zepto

-- 2.What are the Products with High MRP but Out of Stock
SELECT 
	name as product_name,
	mrp
	from zepto
WHERE outOfStock=true
ORDER BY mrp DESC
LIMIT 10;

-- 3. Calculate Estimated Revenue for each category
SELECT
	category,
	SUM(availableQuantity * discountedSellingPrice) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- 4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT
	name AS product_name,
	mrp,
	discountPercent
FROM zepto
WHERE mrp>500 AND discountPercent<10.00
ORDER BY mrp DESC,discountPercent DESC;

-- 5. Identify the top 5 categories offering the highest average discount percentage.
SELECT
	category,
	ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- 6. Find the price per gram for products above 100g and sort by best value.
SELECT
	name as product_name,
	weightInGms,
	discountedSellingPrice,
	ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >=100
ORDER BY price_per_gram DESC;

-- 7. Group the products into categories like Low, Medium, Bulk.
SELECT 
	DISTINCT name AS product_name,
	weightInGms,
	CASE
		WHEN weightInGms<1000 THEN 'Low'
		WHEN weightInGms<5000 THEN 'Medium'
		ELSE 'Bulk'
		END AS weight_category
FROM zepto;

-- 8. What is the Total Inventory Weight Per Category 
SELECT
	category,
	SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;

select * from zepto
ORDER BY mrp desc
limit 10;


