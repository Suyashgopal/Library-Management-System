-- 10 Basic SQL Queries for Library Management System
USE library_db;

-- Query 1: Display all available books
SELECT book_id, title, author, price 
FROM books 
WHERE available = TRUE;

-- Query 2: Display all members who joined in 2024
SELECT member_id, name, email, join_date 
FROM members 
WHERE YEAR(join_date) = 2024 
ORDER BY join_date;

-- Query 3: Show books with their categories (INNER JOIN)
SELECT b.book_id, b.title, b.author, c.category_name, b.price
FROM books b
INNER JOIN categories c ON b.category_id = c.category_id
ORDER BY c.category_name;

-- Query 4: Count total books in each category
SELECT c.category_name, COUNT(b.book_id) AS total_books
FROM categories c
LEFT JOIN books b ON c.category_id = b.category_id
GROUP BY c.category_name;

-- Query 5: Show all active borrowings (not yet returned)
SELECT t.transaction_id, b.title, m.name, t.borrow_date, t.due_date
FROM transactions t
INNER JOIN books b ON t.book_id = b.book_id
INNER JOIN members m ON t.member_id = m.member_id
WHERE t.return_date IS NULL;

-- Query 6: Calculate total fine collected
SELECT SUM(fine) AS total_fine_collected 
FROM transactions 
WHERE fine > 0;

-- Query 7: Find members who have borrowed books
SELECT DISTINCT m.member_id, m.name, m.email
FROM members m
INNER JOIN transactions t ON m.member_id = t.member_id;

-- Query 8: Show most expensive books
SELECT title, author, price 
FROM books 
ORDER BY price DESC 
LIMIT 3;

-- Query 9: Count total transactions per member
SELECT m.name, COUNT(t.transaction_id) AS total_borrowed
FROM members m
LEFT JOIN transactions t ON m.member_id = t.member_id
GROUP BY m.member_id, m.name
ORDER BY total_borrowed DESC;

-- Query 10: Show overdue books (not returned and past due date)
SELECT b.title, m.name, t.borrow_date, t.due_date,
       DATEDIFF(CURDATE(), t.due_date) AS days_overdue
FROM transactions t
INNER JOIN books b ON t.book_id = b.book_id
INNER JOIN members m ON t.member_id = m.member_id
WHERE t.return_date IS NULL AND t.due_date < CURDATE();
