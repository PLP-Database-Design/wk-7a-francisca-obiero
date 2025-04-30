-- Disable foreign key checks to drop tables safely
SET FOREIGN_KEY_CHECKS = 0;

-- Drop the tables if they already exist
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS ProductDetail;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;


-- Question 1: Achieving 1NF

-- Create the original table (ProductDetail) - for demonstration
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(255),
    Products VARCHAR(255)
);

-- Insert the provided data into the ProductDetail table
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Create the OrderDetails table (to store normalized data)
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255),
    Quantity INT
);

-- Insert the provided data into the OrderDetails table
INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);


-- Question 2: Achieving 2NF

-- Create the Orders table (to store OrderID and CustomerName)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Populate the Orders table by selecting distinct OrderID and CustomerName from OrderDetails
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create the OrderItems table (to store OrderID, Product, and Quantity)
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),  -- Composite primary key
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) -- Foreign key to link to Orders
);

-- Populate the OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Drop the original OrderDetails table (optional, but good practice)
DROP TABLE IF EXISTS OrderDetails;

-- Verify the result in 2NF (Orders and OrderItems tables)
SELECT * FROM Orders;
SELECT * FROM OrderItems;