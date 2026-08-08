create database Retail_Store;
use Retail_Store;
create table customers (
	customer_id int auto_increment primary key ,
    Name varchar(100) not null,
    email varchar(100) unique not null,
    phone varchar(15),
    created_at datetime	default current_timestamp
    );
 
create table orders (
	order_id int auto_increment primary key,
	customer_id int ,
	order_date datetime default current_timestamp,
    status varchar(20) default('pending'),
    total_amount decimal(10,2),
    
		constraint fk_orders_customers
		foreign key(customer_id)
		references customers (customer_id)
	);
create table order_items (
	order_item_id int auto_increment primary key,
    order_id int ,
    product_id int,
    quantity int not null check(quantity>0),
    item_price decimal(10,2) not null,
		
        constraint fk_order_items_orders
		foreign key (order_id)
        references orders (order_id),
        constraint fk_order_items_product
        foreign key (product_id)
        references product (product_id)
	);
    
create table payments (
	payment_id int auto_increment primary key,
    order_id int,
    payment_date datetime default current_timestamp,
    amount_paid decimal(10,2) not null check(amount_paid>0),
    method varchar(20) not null,
		
       foreign key payments (order_id)
       references orders (order_id)
	);



   
create table products (
	product_id int unique auto_increment primary key,
    Name varchar(100) not null,
    category varchar(50) not null,
    price decimal(10,2) not null check(price>0),
    stock_quantity int not null default(0) ,
    added_on datetime default current_timestamp
    );
    
    
    create table order_items (
	order_item_id int auto_increment primary key,
    order_id int ,
    product_id int,
    quantity int not null check(quantity>0),
    item_price decimal(10,2) not null,
		
        constraint fk_order_items_orders
		foreign key (order_id)
        references orders (order_id),
        constraint fk_order_items_product
        foreign key (product_id)
        references products (product_id)
	);
    
use retail_store;

create table product_reviews (
	review_id int auto_increment primary key,
    product_id int,
    customer_id int,
    rating int not null check(rating between 1 and 5),
    review_text text,
    review_date datetime default CURRENT_TIMESTAMP,
    
		foreign key (product_id)
        references products (product_id),
        foreign key (customer_id)
        references customers (customer_id)
        );
        
# 1. Retrieve customer names and emails for email marketing
select name, email
from customers;

# 2. View complete product catalog with all available details
select *
from products;

# 3. List all unique product categories
select distinct category
from products;

# 4. Show all products priced above ₹1,000
select name
from products
where price >1000;

# 5. Display products within a mid-range price bracket (₹2,000 to ₹5,000)
select product_id,Name, category, price 
from products
where price between 2000 and 5000;

# 6. Fetch data for specific customer IDs (e.g., from loyalty program list)
select customer_id, count(order_id) as number_of_orders
from orders
group by customer_id
order by number_of_orders DESC;

# 7. Identify customers whose names start with the letter ‘A’
select name
from customers
where name like "A%"
limit 10;

# 8. List electronics products priced under ₹3,000
select name, category, price
from products
where category = "electronics"
and price < 3000;

#9. Display product names and prices in descending order of price
select p. name as product_name, p. price as product_price
from products as p
order by p. price desc;

#10. Display product names and prices, sorted by price and then by name
select name, price
from products
order by price, name ASC;

#11. Retrieve orders where customer information is missing (possibly due to data migration ordeletion)
select order_id
from Orders
where customer_id is null;

#12. Display customer names and emails using column aliases for frontend readability
select c. name as customer_name, c. email as customer_email
from customers as c;

#13. Calculate total value per item ordered by multiplying quantity and item price
select
    order_item_id AS Order_Item_ID,
    order_id AS Order_ID,
    quantity AS Quantity,
    item_price AS Item_Price,
    quantity * item_price AS Total_Value
from order_items;


#14. Combine customer name and phone number in a single column
select concat(name," - ",phone) as customer_details
from customers;

#15. Extract only the date part from order timestamps for date-wise reporting
select order_id,date(order_date) AS Order_Date,status,total_amount
from orders;


#16. List products that do not have any stock left
select product_id, Name, category, stock_quantity
from products
where stock_quantity = 0;

use retail_store;

#17. Count the total number of orders placed
select count(order_id) as Total_orders
from orders;

#18. Calculate the total revenue collected from all orders
SELECT SUM(total_amount) AS Total_Revenue
from orders;



#19.Calculate the average order value
select avg(total_amount) as average_order_value
from orders;


#20. Count the number of customers who have placed at least one order
SELECT customer_id,
    COUNT(order_id) AS Total_Orders
FROM orders
GROUP BY customer_id;
      
#21. Find the number of orders placed by each customer
SELECT
    c.customer_id,
    c.Name AS Customer_Name,
    COUNT(o.order_id) AS Total_Orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.Name;

#22. Find total sales amount made by each customer
SELECT
    c.customer_id,
    c.Name AS Customer_Name,
    SUM(o.total_amount) AS Total_Sales
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.Name;

#23. List the number of products sold per category
SELECT
    p.category,
    SUM(oi.quantity) AS Products_Sold
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category;

#24. Find the average item price per category
SELECT
    p.category,
    AVG(oi.item_price) AS Average_Item_Price
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category;
    
#25. Show number of orders placed per day
SELECT
    DATE(order_date) AS Order_Date,
    COUNT(order_id) AS Total_Orders
FROM orders
GROUP BY DATE(order_date);

#26. List total payments received per payment method
SELECT
    method,
    SUM(amount_paid) AS Total_Payments
FROM payments
GROUP BY method;

#27. Retrieve order details along with the customer name (INNER JOIN)
SELECT
    o.order_id,
    c.Name AS Customer_Name,
    o.order_date,
    o.status,
    o.total_amount
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;	

#Get list of products that have been sold (INNER JOIN with order_items)
SELECT
    p.product_id,
    p.Name AS Product_Name,
    p.category,
    oi.quantity
FROM products p
INNER JOIN order_items oi
ON p.product_id = oi.product_id;

#List all orders with their payment method (INNER JOIN)
SELECT
    o.order_id,
    o.order_date,
    p.method AS Payment_Method,
    p.amount_paid
FROM orders o
INNER JOIN payments p
ON o.order_id = p.order_id;

# Get list of customers and their orders (LEFT JOIN)
SELECT
    c.customer_id,
    c.Name AS Customer_Name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

#List all products along with order item quantity (LEFT JOIN)
SELECT
    p.product_id,
    p.Name AS Product_Name,
    p.category,
    oi.quantity
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id;

#List all payments including those with no matching orders (RIGHT JOIN)
SELECT
    o.order_id,
    p.payment_id,
    p.amount_paid,
    p.method
FROM orders o
RIGHT JOIN payments p
ON o.order_id = p.order_id;

#Combine data from three tables: customer, order, and payment
SELECT
    c.customer_id,
    c.Name AS Customer_Name,
    o.order_id,
    o.order_date,
    p.method AS Payment_Method,
    p.amount_paid
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
INNER JOIN payments p
ON o.order_id = p.order_id;

#List all products priced above the average product price
SELECT
    product_id,
    Name,
    category,
    price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);

#Find customers who have placed at least one order
SELECT
    customer_id,
    Name,
    email
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);

#Show orders whose total amount is above the average for that customer
SELECT
    order_id,
    customer_id,
    total_amount
FROM orders o
WHERE total_amount >
(
    SELECT AVG(total_amount)
    FROM orders
    WHERE customer_id = o.customer_id
);


#Display customers who haven’t placed any orders
SELECT
    customer_id,
    Name,
    email
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);

#Show products that were never ordered
SELECT
    product_id,
    Name,
    category
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.product_id
);


#Show highest value order per customer
	SELECT
		customer_id,
		(
			SELECT MAX(total_amount)
			FROM orders o2
			WHERE o2.customer_id = o1.customer_id
		) AS Highest_Order
	FROM orders o1
	GROUP BY customer_id;


#Highest Order Per Customer (Including Names)
SELECT
    c.customer_id,
    c.Name,
    (
        SELECT MAX(total_amount)
        FROM orders o
        WHERE o.customer_id = c.customer_id
    ) AS Highest_Order
FROM customers c;

#List all customers who have either placed an order or written a product review
SELECT
    customer_id,
    Name
FROM customers
WHERE customer_id IN
(
    SELECT customer_id
    FROM orders

    UNION

    SELECT customer_id
    FROM product_reviews
);

#List all customers who have placed an order as well as reviewed a product
SELECT DISTINCT
    c.customer_id,
    c.Name
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
INNER JOIN product_reviews pr
ON c.customer_id = pr.customer_id;








    


    
    
    
    
