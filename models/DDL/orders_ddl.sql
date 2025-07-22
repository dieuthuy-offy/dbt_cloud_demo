CREATE OR REPLACE TABLE orders (
    order_id INT AUTOINCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status STRING,
    total_amount FLOAT
);

INSERT INTO orders (customer_id, order_date, order_status, total_amount)
VALUES 
  (101, '2025-07-01', 'Shipped', 120.50),
  (102, '2025-07-02', 'Processing', 85.00),
  (103, '2025-07-03', 'Delivered', 230.75),
  (104, '2025-07-04', 'Cancelled', 0),
  (105, '2025-07-05', 'Shipped', 410.20),
  (106, '2025-07-06', 'Delivered', 59.99),
  (107, '2025-07-07', 'Returned', 0),
  (108, '2025-07-08', 'Processing', 95.00),
  (109, '2025-07-09', 'Shipped', 180.10),
  (110, '2025-07-10', 'Delivered', 145.00),
  (111, '2025-07-11', 'Shipped', 300.00),
  (112, '2025-07-12', 'Cancelled', 0),
  (113, '2025-07-13', 'Processing', 210.00),
  (114, '2025-07-14', 'Delivered', 89.90),
  (115, '2025-07-15', 'Shipped', 470.45),
  (116, '2025-07-16', 'Returned', 0),
  (117, '2025-07-17', 'Delivered', 320.00),
  (118, '2025-07-18', 'Shipped', 150.75),
  (119, '2025-07-19', 'Processing', 90.00),
  (120, '2025-07-20', 'Delivered', 275.30);