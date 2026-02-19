CREATE DATABASE ecommerce_db;
USE ecommerce_db;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    created_at DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


INSERT INTO customers (name, email, city, created_at) VALUES
('Rahul', 'rahul@gmail.com', 'Hyderabad', '2024-01-10'),
('Priya', 'priya@gmail.com', 'Mumbai', '2024-02-15'),
('Arjun', 'arjun@gmail.com', 'Delhi', '2024-03-01'),
('Sneha', 'sneha@gmail.com', 'Hyderabad', '2024-04-12');

INSERT INTO products (product_name, category, price, stock) VALUES
('Laptop', 'Electronics', 60000, 10),
('Mobile', 'Electronics', 20000, 25),
('Headphones', 'Accessories', 2000, 50),
('Shoes', 'Fashion', 3000, 40);
INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2024-05-01', 'Completed'),
(2, '2024-05-02', 'Completed'),
(1, '2024-05-10', 'Pending'),
(3, '2024-05-15', 'Completed');
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1),
(3, 4, 2),
(4, 2, 1);
SELECT * FROM customers
WHERE city = 'Hyderabad';
SELECT product_name, price
FROM products
ORDER BY price DESC;
SELECT p.product_name,
       SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;
SELECT c.name, o.order_id, o.order_date
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;
SELECT c.customer_id, c.name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;
SELECT 
    SUM(p.price * oi.quantity) / COUNT(DISTINCT o.customer_id) 
    AS avg_revenue_per_user
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;
CREATE VIEW revenue_summary AS
SELECT c.name,
       SUM(p.price * oi.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.name;
SELECT * FROM revenue_summary;
CREATE INDEX idx_customer_id ON orders(customer_id);
CREATE INDEX idx_product_id ON order_items(product_id);


