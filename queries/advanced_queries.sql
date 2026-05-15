-- ============================================
-- Library Management System - Advanced Queries
-- ============================================

USE library_db;

-- ============================================
-- Subqueries - Scalar Subqueries
-- ============================================

-- 1. Find books more expensive than average
SELECT title, author, price
FROM books
WHERE price > (SELECT AVG(price) FROM books)
ORDER BY price DESC;

-- 2. Find members who borrowed more books than average
SELECT m.name, COUNT(t.transaction_id) AS books_borrowed
FROM members m
JOIN transactions t ON m.member_id = t.member_id
GROUP BY m.member_id, m.name
HAVING COUNT(t.transaction_id) > (
    SELECT AVG(borrow_count)
    FROM (
        SELECT COUNT(*) AS borrow_count
        FROM transactions
        GROUP BY member_id
    ) AS avg_borrows
)
ORDER BY books_borrowed DESC;

-- 3. Find the most expensive book in each category
SELECT b.title, b.author, c.category_name, b.price
FROM books b
JOIN categories c ON b.category_id = c.category_id
WHERE b.price = (
    SELECT MAX(price)
    FROM books b2
    WHERE b2.category_id = b.category_id
)
ORDER BY c.category_name;

-- ============================================
-- Subqueries - IN and NOT IN
-- ============================================

-- 4. Find members who have never borrowed a book
SELECT name, email, membership_date
FROM members
WHERE member_id NOT IN (
    SELECT DISTINCT member_id FROM transactions
)
ORDER BY membership_date;

-- 5. Find books that have never been borrowed
SELECT title, author, available_copies
FROM books
WHERE book_id NOT IN (
    SELECT DISTINCT book_id FROM transactions
)
ORDER BY title;

-- 6. Find members who borrowed Technology books
SELECT DISTINCT m.name, m.email
FROM members m
WHERE m.member_id IN (
    SELECT t.member_id
    FROM transactions t
    JOIN books b ON t.book_id = b.book_id
    WHERE b.category_id = (SELECT category_id FROM categories WHERE category_name = 'Technology')
)
ORDER BY m.name;

-- ============================================
-- Correlated Subqueries
-- ============================================

-- 7. Find books with above-average copies in their category
SELECT b.title, c.category_name, b.total_copies
FROM books b
JOIN categories c ON b.category_id = c.category_id
WHERE b.total_copies > (
    SELECT AVG(total_copies)
    FROM books b2
    WHERE b2.category_id = b.category_id
)
ORDER BY c.category_name, b.total_copies DESC;

-- 8. Find members with overdue books
SELECT m.name, m.email, m.phone
FROM members m
WHERE EXISTS (
    SELECT 1
    FROM transactions t
    WHERE t.member_id = m.member_id
    AND t.return_date IS NULL
    AND t.due_date < CURDATE()
)
ORDER BY m.name;

-- 9. Find books currently borrowed
SELECT b.title, b.author, b.available_copies
FROM books b
WHERE EXISTS (
    SELECT 1
    FROM transactions t
    WHERE t.book_id = b.book_id
    AND t.status = 'Borrowed'
)
ORDER BY b.title;

-- ============================================
-- Subqueries with FROM Clause
-- ============================================

-- 10. Get category-wise borrowing statistics
SELECT 
    cat_stats.category_name,
    cat_stats.total_books,
    cat_stats.total_borrows,
    ROUND(cat_stats.total_borrows / cat_stats.total_books, 2) AS avg_borrows_per_book
FROM (
    SELECT 
        c.category_name,
        COUNT(DISTINCT b.book_id) AS total_books,
        COUNT(t.transaction_id) AS total_borrows
    FROM categories c
    JOIN books b ON c.category_id = b.category_id
    LEFT JOIN transactions t ON b.book_id = t.book_id
    GROUP BY c.category_id, c.category_name
) AS cat_stats
ORDER BY avg_borrows_per_book DESC;

-- 11. Find top 3 members by borrowing activity
SELECT name, email, books_borrowed, total_fines
FROM (
    SELECT 
        m.name,
        m.email,
        COUNT(t.transaction_id) AS books_borrowed,
        COALESCE(SUM(f.fine_amount), 0) AS total_fines
    FROM members m
    LEFT JOIN transactions t ON m.member_id = t.member_id
    LEFT JOIN fines f ON t.transaction_id = f.transaction_id
    GROUP BY m.member_id, m.name, m.email
    ORDER BY books_borrowed DESC
    LIMIT 3
) AS top_members;

-- ============================================
-- CASE Statements
-- ============================================

-- 12. Categorize books by price range
SELECT 
    title,
    author,
    price,
    CASE 
        WHEN price < 300 THEN 'Budget'
        WHEN price BETWEEN 300 AND 600 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS price_category
FROM books
ORDER BY price;

-- 13. Member activity status
SELECT 
    m.name,
    m.membership_status,
    COUNT(t.transaction_id) AS total_borrows,
    CASE 
        WHEN COUNT(t.transaction_id) = 0 THEN 'Inactive User'
        WHEN COUNT(t.transaction_id) BETWEEN 1 AND 3 THEN 'Casual Reader'
        WHEN COUNT(t.transaction_id) BETWEEN 4 AND 6 THEN 'Regular Reader'
        ELSE 'Avid Reader'
    END AS reader_type
FROM members m
LEFT JOIN transactions t ON m.member_id = t.member_id
GROUP BY m.member_id, m.name, m.membership_status
ORDER BY total_borrows DESC;

-- 14. Book availability status with recommendations
SELECT 
    title,
    author,
    total_copies,
    available_copies,
    CASE 
        WHEN available_copies = 0 THEN 'Out of Stock - Order More'
        WHEN available_copies <= 2 THEN 'Low Stock - Consider Reordering'
        ELSE 'Adequate Stock'
    END AS stock_status
FROM books
ORDER BY available_copies;

-- ============================================
-- Window Functions (MySQL 8.0+)
-- ============================================

-- 15. Rank books by price within each category
SELECT 
    c.category_name,
    b.title,
    b.price,
    RANK() OVER (PARTITION BY c.category_id ORDER BY b.price DESC) AS price_rank
FROM books b
JOIN categories c ON b.category_id = c.category_id
ORDER BY c.category_name, price_rank;

-- 16. Calculate running total of fines collected
SELECT 
    fine_id,
    payment_date,
    fine_amount,
    SUM(fine_amount) OVER (ORDER BY payment_date) AS running_total
FROM fines
WHERE payment_status = 'Paid' AND payment_date IS NOT NULL
ORDER BY payment_date;

-- 17. Member borrowing trends with row numbers
SELECT 
    m.name,
    b.title,
    t.borrow_date,
    ROW_NUMBER() OVER (PARTITION BY m.member_id ORDER BY t.borrow_date DESC) AS borrow_sequence
FROM transactions t
JOIN members m ON t.member_id = m.member_id
JOIN books b ON t.book_id = b.book_id
ORDER BY m.name, borrow_sequence;

-- ============================================
-- Complex Multi-level Queries
-- ============================================

-- 18. Find books borrowed by members with pending fines
SELECT DISTINCT b.title, b.author, c.category_name
FROM books b
JOIN transactions t ON b.book_id = t.book_id
WHERE t.member_id IN (
    SELECT DISTINCT t2.member_id
    FROM transactions t2
    JOIN fines f ON t2.transaction_id = f.transaction_id
    WHERE f.payment_status = 'Pending'
)
ORDER BY b.title;

-- 19. Category performance analysis
SELECT 
    c.category_name,
    COUNT(DISTINCT b.book_id) AS total_books,
    SUM(b.total_copies) AS total_copies,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(AVG(b.price), 2) AS avg_book_price,
    COALESCE(SUM(CASE WHEN t.status = 'Overdue' THEN 1 ELSE 0 END), 0) AS overdue_count
FROM categories c
LEFT JOIN books b ON c.category_id = b.category_id
LEFT JOIN transactions t ON b.book_id = t.book_id
GROUP BY c.category_id, c.category_name
ORDER BY total_transactions DESC;

-- 20. Member fine analysis with payment behavior
SELECT 
    m.name,
    m.email,
    COUNT(f.fine_id) AS total_fines,
    SUM(f.fine_amount) AS total_fine_amount,
    SUM(CASE WHEN f.payment_status = 'Paid' THEN f.fine_amount ELSE 0 END) AS paid_amount,
    SUM(CASE WHEN f.payment_status = 'Pending' THEN f.fine_amount ELSE 0 END) AS pending_amount,
    ROUND(
        SUM(CASE WHEN f.payment_status = 'Paid' THEN f.fine_amount ELSE 0 END) / 
        NULLIF(SUM(f.fine_amount), 0) * 100, 
        2
    ) AS payment_rate_percentage
FROM members m
JOIN transactions t ON m.member_id = t.member_id
JOIN fines f ON t.transaction_id = f.transaction_id
GROUP BY m.member_id, m.name, m.email
HAVING COUNT(f.fine_id) > 0
ORDER BY total_fine_amount DESC;

-- ============================================
-- Date and Time Functions
-- ============================================

-- 21. Books borrowed in the last 30 days
SELECT 
    b.title,
    m.name AS member_name,
    t.borrow_date,
    DATEDIFF(CURDATE(), t.borrow_date) AS days_ago
FROM transactions t
JOIN books b ON t.book_id = b.book_id
JOIN members m ON t.member_id = m.member_id
WHERE t.borrow_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY t.borrow_date DESC;

-- 22. Monthly borrowing trends
SELECT 
    DATE_FORMAT(borrow_date, '%Y-%m') AS month,
    COUNT(*) AS total_borrows,
    COUNT(DISTINCT member_id) AS unique_members,
    COUNT(DISTINCT book_id) AS unique_books
FROM transactions
GROUP BY DATE_FORMAT(borrow_date, '%Y-%m')
ORDER BY month DESC;

-- 23. Staff tenure and performance
SELECT 
    name,
    position,
    hire_date,
    TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_of_service,
    TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) % 12 AS additional_months,
    salary,
    (SELECT COUNT(*) FROM transactions WHERE staff_id = s.staff_id) AS transactions_handled
FROM staff s
ORDER BY years_of_service DESC, additional_months DESC;

-- ============================================
-- UNION Queries
-- ============================================

-- 24. Combined list of all people (members and staff)
SELECT name, email, 'Member' AS type, phone FROM members
UNION
SELECT name, email, 'Staff' AS type, phone FROM staff
ORDER BY name;

-- 25. Books status summary
SELECT 'Total Books' AS metric, COUNT(*) AS count FROM books
UNION
SELECT 'Available Books', SUM(CASE WHEN available_copies > 0 THEN 1 ELSE 0 END) FROM books
UNION
SELECT 'Out of Stock', SUM(CASE WHEN available_copies = 0 THEN 1 ELSE 0 END) FROM books
UNION
SELECT 'Total Copies', SUM(total_copies) FROM books;
