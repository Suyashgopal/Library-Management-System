-- ============================================
-- Library Management System - Basic Queries
-- ============================================

USE library_db;

-- ============================================
-- SELECT Queries
-- ============================================

-- 1. Get all books
SELECT * FROM books;

-- 2. Get all active members
SELECT * FROM members WHERE membership_status = 'Active';

-- 3. Get books by specific category
SELECT b.title, b.author, c.category_name, b.available_copies
FROM books b
JOIN categories c ON b.category_id = c.category_id
WHERE c.category_name = 'Technology';

-- 4. Get all borrowed books (currently not returned)
SELECT t.transaction_id, b.title, m.name AS member_name, t.borrow_date, t.due_date
FROM transactions t
JOIN books b ON t.book_id = b.book_id
JOIN members m ON t.member_id = m.member_id
WHERE t.return_date IS NULL;

-- 5. Get books with price greater than ₹500
SELECT title, author, price FROM books WHERE price > 500 ORDER BY price DESC;

-- ============================================
-- INSERT Queries
-- ============================================

-- 6. Add a new member
INSERT INTO members (name, email, phone, address, membership_status)
VALUES ('Neha Kapoor', 'neha.kapoor@email.com', '9876543220', '852 Linking Road, Mumbai', 'Active');

-- 7. Add a new book
INSERT INTO books (title, author, isbn, category_id, publisher, publication_year, total_copies, available_copies, price)
VALUES ('The Lean Startup', 'Eric Ries', '9780307887894', 8, 'Crown Business', 2011, 5, 5, 550.00);

-- 8. Add a new category
INSERT INTO categories (category_name, description)
VALUES ('Philosophy', 'Books on philosophical thoughts and theories');

-- ============================================
-- UPDATE Queries
-- ============================================

-- 9. Update member phone number
UPDATE members 
SET phone = '9999999999' 
WHERE email = 'rahul.sharma@email.com';

-- 10. Update book price
UPDATE books 
SET price = 450.00 
WHERE title = 'Clean Code';

-- 11. Update member status to inactive
UPDATE members 
SET membership_status = 'Inactive' 
WHERE member_id = 5;

-- 12. Increase book copies
UPDATE books 
SET total_copies = total_copies + 2,
    available_copies = available_copies + 2
WHERE book_id = 10;

-- ============================================
-- DELETE Queries
-- ============================================

-- 13. Delete a reservation (cancelled)
DELETE FROM reservations 
WHERE reservation_id = 5 AND status = 'Cancelled';

-- 14. Delete old audit logs (older than 1 year)
DELETE FROM audit_log 
WHERE action_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- ============================================
-- WHERE Clause with Multiple Conditions
-- ============================================

-- 15. Get available books in Fiction category
SELECT title, author, available_copies, price
FROM books
WHERE category_id = 1 AND available_copies > 0
ORDER BY title;

-- 16. Get members who joined in 2024 and are active
SELECT name, email, membership_date
FROM members
WHERE YEAR(membership_date) = 2024 AND membership_status = 'Active'
ORDER BY membership_date;

-- ============================================
-- LIKE and Pattern Matching
-- ============================================

-- 17. Find books with 'The' in title
SELECT title, author, price FROM books WHERE title LIKE '%The%';

-- 18. Find members with Gmail addresses
SELECT name, email FROM members WHERE email LIKE '%@email.com';

-- ============================================
-- BETWEEN and IN Operators
-- ============================================

-- 19. Get books published between 2000 and 2020
SELECT title, author, publication_year, price
FROM books
WHERE publication_year BETWEEN 2000 AND 2020
ORDER BY publication_year DESC;

-- 20. Get books in specific categories
SELECT b.title, c.category_name, b.price
FROM books b
JOIN categories c ON b.category_id = c.category_id
WHERE c.category_name IN ('Technology', 'Science', 'Business')
ORDER BY c.category_name, b.title;

-- ============================================
-- ORDER BY and LIMIT
-- ============================================

-- 21. Get top 5 most expensive books
SELECT title, author, price FROM books ORDER BY price DESC LIMIT 5;

-- 22. Get recently joined members
SELECT name, email, membership_date 
FROM members 
ORDER BY membership_date DESC 
LIMIT 10;

-- ============================================
-- DISTINCT
-- ============================================

-- 23. Get unique authors
SELECT DISTINCT author FROM books ORDER BY author;

-- 24. Get unique member statuses
SELECT DISTINCT membership_status FROM members;

-- ============================================
-- NULL Handling
-- ============================================

-- 25. Get transactions without return date (currently borrowed)
SELECT t.transaction_id, b.title, m.name, t.borrow_date, t.due_date
FROM transactions t
JOIN books b ON t.book_id = b.book_id
JOIN members m ON t.member_id = m.member_id
WHERE t.return_date IS NULL;

-- 26. Get books without ISBN
SELECT title, author FROM books WHERE isbn IS NULL;
