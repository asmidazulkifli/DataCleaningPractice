
-- INTERMEDIATE PROBLEMS
 -- You need to combine various concepts covered in the video to solve these

-- 1. Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
-- 2. How many shipments (sales) each of the sales persons had in the month of January 2022?
-- 3. Which product sells more boxes? Milk Bars or Eclairs?
-- 4. Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?
-- 5. Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?

-- 1. Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
select * from sales;

SELECT 
    amount, boxes
FROM
    sales
WHERE
    amount > 2000 AND boxes < 100;

-- 2. How many shipments (sales) each of the sales persons had in the month of January 2022?
select * from sales;

select * from people;

SELECT 
    people.salesperson, COUNT(*) AS shipment_count
FROM
    sales
        JOIN
    people ON sales.SPID = people.SPID
WHERE
    saledate BETWEEN '2022-01-01' AND '2022-01-31'
GROUP BY people.salesperson
ORDER BY shipment_count DESC;

-- 3. Which product sells more boxes? Milk Bars or Eclairs?
select * from products;

select * from sales;

SELECT 
    products.product, SUM(sales.boxes) AS total_boxes
FROM
    products
        JOIN
    sales ON products.PID = sales.PID
WHERE
    products.product IN ('milk bars' , 'eclairs')
GROUP BY products.product;

-- 4. Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?
select * from products;

select * from sales;

SELECT 
    products.product, SUM(sales.boxes) AS total_boxes
FROM
    products
        JOIN
    sales ON products.PID = sales.PID
WHERE
    products.product IN ('milk bars' , 'eclairs') and sales.SaleDate between '2022-02-01' and '2022-02-07'
GROUP BY products.product;

-- 5. Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?
select * from sales;

select * from sales where customers < 100 and boxes < 100;

SELECT 
    *,
    CASE
        WHEN WEEKDAY(SaleDate) = 2 THEN 'Wednesday'
        ELSE 'unknwon'
    END AS shipment_day
FROM
    sales
WHERE
    customers < 100 AND boxes < 100
ORDER BY shipment_day DESC;
 
-- count of shipment in Wednesday with condition customers and boxes < 100
SELECT COUNT(*),
	CASE
		WHEN WEEKDAY(SaleDate) = 2 THEN 'Wednesday'
		ELSE 'Unknown'
	END AS shipment_day
FROM sales
WHERE customers < 100 AND boxes < 100
GROUP BY shipment_day
ORDER BY shipment_day DESC;


-- HARD PROBLEMS

-- 1. What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
-- 2. Which salespersons did not make any shipments in the first 7 days of January 2022?
-- 3. How many times we shipped more than 1,000 boxes in each month?
-- 4. Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?
-- 5. India or Australia? Who buys more chocolate boxes on a monthly basis?

-- 1. What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
select * from people;

select * from sales;

select people.Salesperson, sales.Boxes from people join sales on people.SPID=sales.SPID
where sales.boxes > 1 and sales.SaleDate between '2022-01-01' and '2022-01-07'
order by boxes desc;

-- there is duplicate data in salesperson column and to remove the sales.boxes column as the qs only ask for the names of salesperson
SELECT DISTINCT
    (people.Salesperson)
FROM
    people
        JOIN
    sales ON people.SPID = sales.SPID
WHERE
    sales.boxes > 1
        AND sales.SaleDate BETWEEN '2022-01-01' AND '2022-01-07'
ORDER BY people.Salesperson;

-- 2. Which salespersons did not make any shipments in the first 7 days of January 2022?
select * from people;

select * from sales;

SELECT 
    p.salesperson
FROM
    people p
WHERE
    p.spid NOT IN (SELECT DISTINCT
            s.spid
        FROM
            sales s
        WHERE
            s.SaleDate BETWEEN '2022-01-01' AND '2022-01-07');

-- 3. How many times we shipped more than 1,000 boxes in each month?
select * from sales;

SELECT 
    YEAR(saledate) AS 'Year',
    MONTH(saledate) AS 'Month',
    COUNT(*) AS 'Times we shipped 1k boxes'
FROM
    sales
WHERE
    boxes > 1000
GROUP BY YEAR(saledate) , MONTH(saledate)
ORDER BY YEAR(saledate) , MONTH(saledate);

-- 4. Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?
select * from geo;

select * from products;

select * from sales;

SELECT 
    YEAR(sales.saledate) AS 'Year',
    MONTH(sales.saledate) AS 'Month',
    IF(SUM(sales.boxes) > 1, 'Yes', 'No') AS 'Status'
FROM
    sales
        JOIN
    products ON products.PID = sales.PID
        JOIN
    geo ON geo.GeoID = sales.GeoID
WHERE
    products.product = 'After Nines'
        AND geo.geo = 'New Zealand'
GROUP BY YEAR(sales.saledate) , MONTH(sales.saledate)
ORDER BY YEAR(sales.saledate) , MONTH(sales.saledate);

-- 5. India or Australia? Who buys more chocolate boxes on a monthly basis?
select * from geo;

select year(sales.saledate) as 'Year', month(sales.saledate) as 'Month',
sum(CASE WHEN geo.geo= 'India' = 1 THEN boxes ELSE 0 END) as 'India Boxes',
sum(CASE WHEN geo.geo= 'Australia' = 1 THEN boxes ELSE 0 END) as 'Australia Boxes'
from sales
join geo on geo.GeoID=sales.GeoID
group by year(sales.saledate), month(sales.saledate)
order by year(sales.saledate), month(sales.saledate);

-- to create new column to determine which country buys more
SELECT 
  year(sales.saledate) as 'Year', 
  month(sales.saledate) as 'Month',
  sum(CASE WHEN geo.geo= 'India' THEN boxes ELSE 0 END) as 'India Boxes',
  sum(CASE WHEN geo.geo= 'Australia' THEN boxes ELSE 0 END) as 'Australia Boxes',
  CASE 
    WHEN sum(CASE WHEN geo.geo = 'India' THEN boxes ELSE 0 END) > sum(CASE WHEN geo.geo = 'Australia' THEN boxes ELSE 0 END) THEN 'India'
    ELSE 'Australia'
  END as 'More Purchases'
FROM sales
JOIN geo on geo.GeoID=sales.GeoID
GROUP BY year(sales.saledate), month(sales.saledate)
ORDER BY year(sales.saledate), month(sales.saledate);







