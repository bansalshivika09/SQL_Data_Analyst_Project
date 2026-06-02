-- Create Database
CREATE DATABASE OnlineBookstore;
-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1. Retrieve all books in the "Fiction" genre
SELECT * FROM Books WHERE Genre = 'Fiction'; 

-- 2. Find books published after year 1950 :
SELECT * FROM Books WHERE Published_Year > '1950';

-- 3. List all the Customers From Canada
SELECT * FROM Customers WHERE Country = 'Canada';

-- 4. Show orders placed in November 2023:
SELECT * FROM Orders WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5. Retrieve the total stopck of books available:
SELECT SUM(stock) AS Total_Stock FROM Books;

-- 6. Find the details of the most expensive books :
SELECT * FROM Books ORDER BY Price DESC LIMIT 1;

-- 7. Show all the customers who ordered more than 1 quantity of a book :
SELECT * FROM Orders WHERE quantity > 1 ;

-- 8. Retrieve all orders where the total amount exceeds $20 :
SELECT * FROM Orders WHERE total_amount > 20;

-- 9 . List all the genres available in Books table :
SELECT distinct(Genre) FROM Books;

-- 10. Find the book with lowest stock
SELECT * FROM Books ORDER BY stock LIMIT 1;

-- 11. Calculate the total revenue generated from all orders
SELECT SUM(total_amount) AS total_revenue FROM Orders ;

-- Advanced Questions
-- 1. Retrieve total amount of book sold for each genre
SELECT b.Genre , SUM(o.Quantity) AS Total_books FROM Orders AS o JOIN Books AS b ON b.Book_ID = o.Book_Id GROUP BY b.Genre;

-- 2. Find the average price of books in the "Fantasy" genre :
SELECT b.Genre , AVG(b.Price) AS Avg_Price FROM Books AS b GROUP BY b.Genre HAVING b.Genre= 'Fantasy';

-- 3. List the customers who have placed atleast 2 orders :
SELECT customer_id , COUNT(order_id) AS Order_Count FROM Orders GROUP BY customer_id HAVING COUNT(order_id) >= 2;

-- 4. Find the most frequently ordered book:
SELECT Book_Id, COUNT(Order_ID) AS Frequently_ordered FROM Orders GROUP BY Book_ID ORDER BY Frequently_ordered DESC LIMIT 1;

-- 5. Show the top 3 most expensive books of 'Fantasy' genre :
SELECT * FROM Books WHERE Genre = 'Fantasy' ORDER BY Price DESC LIMIT 3;

-- 6. Retrieve the total quantity of books sold by each customer :
SELECT b.Author , SUM(o.quantity) AS Total_Books_Sold FROM Orders o JOIN Books b ON o.Book_Id = b.Book_Id GROUP BY b.Author;

-- 7. List the cities where customers who spent over $30 are located :
SELECT DISTINCT(c.City) , total_amount FROM orders o JOIN customers c ON o.Customer_ID = c.Customer_ID WHERE o.Total_Amount > 30;

-- 8. Find the customer who spent most on orders :
SELECT c.customer_id , c.name , SUM(o.total_amount) AS Total_Spent FROM Orders o JOIN customers c ON o.customer_id = c.customer_id GROUP BY c.customer_id , c.name ORDER BY Total_Spent DESC LIMIT 1;

-- 9. Calculate the stock remaining after fulfilling all orders :
SELECT b.Book_Id, b.title , b.stock , coalesce(SUM(o.quantity),0) AS Order_Quantity , b.stock - coalesce(SUM(o.quantity),0) AS Remaining_Quantity   FROM Books b LEFT JOIN Orders o ON b.Book_Id = o.Book_Id GROUP BY b.Book_Id;