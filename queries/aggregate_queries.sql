-- ============================================
-- Library Management System - Aggregate Queries
-- ============================================

USE library_db;

-- ============================================
-- COUNT Function
-- ============================================

-- 1. Count total books in library
SELECT COUNT(*) AS total_books FROM books;

-- 2. Count books by category
SELECT c.category_name, COUNT(b.book_id) AS book_count
FROM categories c
LEFT JOIN books b ON c.category_id = b.category_id
GROUP BY c.category_id, c.category_name
ORDER BY book_count DESC;

-- 3. Count active vs inactive members
SELECT membership_status, COUNT(*) AS member_count
FROM members
GROUP BY membership_status;

-- 4. Count transactions by status
SELECT status, COUNT(*) AS transaction_count
FROM transactions
GROUP BY status;

-- 5. Count books borrowed by each member
SELECT m.name, m.email, COUNT(t.transaction_id) AS books_borrowed
FROM members m
LEFT JOIN transactions t ON m.member_id = t.member_id
GROUP BY m.member_id, m.name, m.email
ORDER BY books_borrowed DESC;

-- ============================================
-- SUM Function
-- ============================================

-- 6. Calculate total value of all books
SELECT SUM(price * total_copies) AS total_inventory_value FROM books;

-- 7. Calculate total fines collected
SELECT SUM(fine_amount) AS total_fines_collected
FROM fines
WHERE payment_status = 'Paid';

-- 8. Calculate pending fines
SELECT SUM(fine_amount) AS total_pending_fines
FROM fines
WHERE payment_status = 'Pending';

-- 9. Calculate total copies by category
SELECT c.category_name, SUM(b.total_copies) AS total_copies
FROM categories c
JOIN books b ON c.category_id = b.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_copies DESC;

-- 10. Calculate total salary expense
SELECT SUM(salary) AS total_salary_expense FROM staff;

-- ============================================
-- AVG Function
-- ============================================

-- 11. Calculate average book price
SELECT AVG(price) AS average_book_price FROM books;

-- 12. Calculate average book price by category
SELECT c.category_name, AVG(b.price) AS avg_price
FROM categories c
JOIN books b ON c.category_id = b.category_id
GROUP BY c.category_id, c.category_name
ORDER BY avg_price DESC;

-- 13. Calculate average fine amount
SELECT AVG(fine_amount) AS average_fine FROM fines;

-- 14. Calculate average staff salary by position
SELECT position, AVG(salary) AS avg_salary, COUNT(*) AS staff_count
FROM staff
GROUP BY position
ORDER BY avg_salary DESC;

-- ============================================
-- MAX and MIN Functions
-- ============================================

-- 15. Find most expensive and cheapest books
SELECT 
    MAX(price) AS most_expensive,
    MIN(price) AS cheapest,
    AVG(price) AS average_price
FROM books;

-- 16. Find highest and lowest fine amounts
SELECT 
    MAX(fine_amount) AS highest_fine,
    MIN(fine_amount) AS lowest_fine
FROM fines;

-- 17. Find oldest and newest members
SELECT 
    MIN(membership_date) AS oldest_member_date,
    MAX(membership_date) AS newest_member_date
FROM members;

-- ============================================
-- GROUP BY with Multiple Columns
-- ============================================

-- 18. Count transactions by member and status
SELECT 
    m.name AS member_name,
    t.status,
    COUNT(*) AS transaction_count
FROM members m
JOIN transactions t ON m.member_id = t.member_id
GROUP BY m.member_id, m.name, t.status
ORDER BY m.name, t.status;

-- 19. Calculate total and available copies by category
SELECT 
    c.category_name,
    SUM(b.total_copies) AS total_copies,
    SUM(b.available_copies) AS available_copies,
    SUM(b.total_copies - b.available_copies) AS borrowed_copies
FROM categories c
JOIN books b ON c.category_id = b.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_copies DESC;

-- ============================================
-- HAVING Clause
-- ============================================

-- 20. Find members who borrowed more than 2 books
SELECT 
    m.name,
    m.email,
    COUNT(t.transaction_id) AS books_borrowed
FROM members m
JOIN transactions t ON m.member_id = t.member_id
GROUP BY m.member_id, m.name, m.email
HAVING COUNT(t.transaction_id) > 2
ORDER BY books_borrowed DESC;

-- 21. Find categories with average book price > ₹400
SELECT 
    c.category_name,
    AVG(b.price) AS avg_price,
    COUNT(b.book_id) AS book_count
FROM categories c
JOIN books b ON c.category_id = b.category_id
GROUP BY c.category_id, c.category_name
HAVING AVG(b.price) > 400
ORDER BY avg_price DESC;

-- 22. Find books borrowed more than 3 times
SELECT 
    b.title,
    b.author,
    COUNT(t.transaction_id) AS borrow_count
FROM books b
JOIN transactions t ON b.book_id = t.book_id
GROUP BY b.book_id, b.title, b.author
HAVING COUNT(t.transaction_id) > 3
ORDER BY borrow_count DESC;

-- 23. Find members with pending fines > ₹100
SELECT 
    m.name,
    m.email,
    SUM(f.fine_amount) AS total_pending_fines
FROM members m
JOIN transactions t ON m.member_id = t.member_id
JOIN fines f ON t.transaction_id = f.transaction_id
WHERE f.payment_status = 'Pending'
GROUP BY m.member_id, m.name, m.email
HAVING SUM(f.fine_amount) > 100
ORDER BY total_pending_fines DESC;

-- ============================================
-- Complex Aggregate Queries
-- ============================================

-- 24. Monthly transaction statistics
SELECT 
    DATE_FORMAT(borrow_date, '%Y-%m') AS month,
    COUNT(*) AS total_transactions,
    COUNT(CASE WHEN status = 'Returned' THEN 1 END) AS returned,
    COUNT(CASE WHEN status = 'Borrowed' THEN 1 END) AS currently_borrowed,
    COUNT(CASE WHEN status = 'Overdue' THEN 1 END) AS overdue
FROM transactions
GROUP BY DATE_FORMAT(borrow_date, '%Y-%m')
ORDER BY month DESC;

-- 25. Staff performance - transactions handled
SELECT 
    s.name AS staff_name,
    s.position,
    COUNT(t.transaction_id) AS transactions_handled,
    COUNT(DISTINCT t.member_id) AS unique_members_served
FROM staff s
LEFT JOIN transactions t ON s.staff_id = t.staff_id
GROUP BY s.staff_id, s.name, s.position
ORDER BY transactions_handled DESC;

-- 26. Book utilization rate by category
SELECT 
    c.category_name,
    COUNT(DISTINCT b.book_id) AS total_books,
    SUM(b.total_copies) AS total_copies,
    COUNT(t.transaction_id) AS total_borrows,
    ROUND(COUNT(t.transaction_id) / SUM(b.total_copies), 2) AS utilization_rate
FROM categories c
JOIN books b ON c.category_id = b.category_id
LEFT JOIN transactions t ON b.book_id = t.book_id
GROUP BY c.category_id, c.category_name
ORDER BY utilization_rate DESC;

-- 27. Member engagement summary
SELECT 
    CASE 
        WHEN COUNT(t.transaction_id) = 0 THEN 'No Activity'
        WHEN COUNT(t.transaction_id) BETWEEN 1 AND 2 THEN 'Low Activity'
        WHEN COUNT(t.transaction_id) BETWEEN 3 AND 5 THEN 'Medium Activity'
        ELSE 'High Activity'
    END AS engagement_level,
    COUNT(DISTINCT m.member_id) AS member_count
FROM members m
LEFT JOIN transactions t ON m.member_id = t.member_id
GROUP BY engagement_level
ORDER BY member_count DESC;
