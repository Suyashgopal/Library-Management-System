-- ============================================
-- Library Management System - JOIN Queries
-- ============================================

USE library_db;

-- ============================================
-- INNER JOIN Queries
-- ============================================

-- 1. Get all books with their category names
SELECT b.book_id, b.title, b.author, c.category_name, b.price
FROM books b
INNER JOIN categories c ON b.category_id = c.category_id
ORDER BY c.category_name, b.title;

-- 2. Get all transactions with book and member details
SELECT 
    t.transaction_id,
    b.title AS book_title,
    m.name AS member_name,
    s.name AS staff_name,
    t.borrow_date,
    t.due_date,
    t.status
FROM transactions t
INNER JOIN books b ON t.book_id = b.book_id
INNER JOIN members m ON t.member_id = m.member_id
INNER JOIN staff s ON t.staff_id = s.staff_id
ORDER BY t.borrow_date DESC;

-- 3. Get fines with transaction and member details
SELECT 
    f.fine_id,
    m.name AS member_name,
    m.email,
    b.title AS book_title,
    f.fine_amount,
    f.payment_status,
    t.due_date,
    t.return_date
FROM fines f
INNER JOIN transactions t ON f.transaction_id = t.transaction_id
INNER JOIN members m ON t.member_id = m.member_id
INNER JOIN books b ON t.book_id = b.book_id
ORDER BY f.fine_amount DESC;

-- ============================================
-- LEFT JOIN Queries
-- ============================================

-- 4. Get all members and their transaction count (including members with no transactions)
SELECT 
    m.member_id,
    m.name,
    m.email,
    COUNT(t.transaction_id) AS total_transactions
FROM members m
LEFT JOIN transactions t ON m.member_id = t.member_id
GROUP BY m.member_id, m.name, m.email
ORDER BY total_transactions DESC;

-- 5. Get all books and their borrow count (including never borrowed books)
SELECT 
    b.book_id,
    b.title,
    b.author,
    COUNT(t.transaction_id) AS times_borrowed,
    b.available_copies
FROM books b
LEFT JOIN transactions t ON b.book_id = t.book_id
GROUP BY b.book_id, b.title, b.author, b.available_copies
ORDER BY times_borrowed DESC;

-- 6. Get all categories with book count
SELECT 
    c.category_id,
    c.category_name,
    COUNT(b.book_id) AS total_books,
    SUM(b.total_copies) AS total_copies
FROM categories c
LEFT JOIN books b ON c.category_id = b.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_books DESC;

-- ============================================
-- RIGHT JOIN Queries
-- ============================================

-- 7. Get all transactions and member details (show all transactions even if member deleted)
SELECT 
    t.transaction_id,
    t.borrow_date,
    t.due_date,
    m.name AS member_name,
    m.email
FROM members m
RIGHT JOIN transactions t ON m.member_id = t.member_id
ORDER BY t.borrow_date DESC;

-- ============================================
-- Multiple JOIN Queries
-- ============================================

-- 8. Get complete transaction details with all related information
SELECT 
    t.transaction_id,
    b.title AS book_title,
    b.author,
    c.category_name,
    m.name AS member_name,
    m.email AS member_email,
    m.phone AS member_phone,
    s.name AS staff_name,
    s.position AS staff_position,
    t.borrow_date,
    t.due_date,
    t.return_date,
    t.status,
    DATEDIFF(COALESCE(t.return_date, CURDATE()), t.due_date) AS days_difference
FROM transactions t
INNER JOIN books b ON t.book_id = b.book_id
INNER JOIN categories c ON b.category_id = c.category_id
INNER JOIN members m ON t.member_id = m.member_id
INNER JOIN staff s ON t.staff_id = s.staff_id
ORDER BY t.borrow_date DESC;

-- 9. Get reservations with book and member details
SELECT 
    r.reservation_id,
    b.title AS book_title,
    b.author,
    c.category_name,
    m.name AS member_name,
    m.email,
    r.reservation_date,
    r.status,
    b.available_copies
FROM reservations r
INNER JOIN books b ON r.book_id = b.book_id
INNER JOIN categories c ON b.category_id = c.category_id
INNER JOIN members m ON r.member_id = m.member_id
ORDER BY r.reservation_date DESC;

-- 10. Get overdue books with member and fine details
SELECT 
    t.transaction_id,
    b.title AS book_title,
    m.name AS member_name,
    m.phone AS member_phone,
    t.borrow_date,
    t.due_date,
    DATEDIFF(CURDATE(), t.due_date) AS days_overdue,
    COALESCE(f.fine_amount, 0) AS fine_amount,
    COALESCE(f.payment_status, 'Not Calculated') AS payment_status
FROM transactions t
INNER JOIN books b ON t.book_id = b.book_id
INNER JOIN members m ON t.member_id = m.member_id
LEFT JOIN fines f ON t.transaction_id = f.transaction_id
WHERE t.return_date IS NULL AND t.due_date < CURDATE()
ORDER BY days_overdue DESC;

-- ============================================
-- SELF JOIN Queries
-- ============================================

-- 11. Find members who borrowed the same book
SELECT DISTINCT
    m1.name AS member1,
    m2.name AS member2,
    b.title AS book_title
FROM transactions t1
INNER JOIN transactions t2 ON t1.book_id = t2.book_id AND t1.member_id < t2.member_id
INNER JOIN members m1 ON t1.member_id = m1.member_id
INNER JOIN members m2 ON t2.member_id = m2.member_id
INNER JOIN books b ON t1.book_id = b.book_id
ORDER BY b.title, m1.name;

-- ============================================
-- Complex JOIN with Subqueries
-- ============================================

-- 12. Get members with their most recent transaction
SELECT 
    m.name AS member_name,
    b.title AS last_borrowed_book,
    t.borrow_date AS last_borrow_date,
    t.status
FROM members m
INNER JOIN transactions t ON m.member_id = t.member_id
INNER JOIN books b ON t.book_id = b.book_id
WHERE t.borrow_date = (
    SELECT MAX(t2.borrow_date)
    FROM transactions t2
    WHERE t2.member_id = m.member_id
)
ORDER BY t.borrow_date DESC;

-- 13. Get books borrowed by active members only
SELECT DISTINCT
    b.title,
    b.author,
    c.category_name,
    COUNT(t.transaction_id) AS borrow_count
FROM books b
INNER JOIN transactions t ON b.book_id = t.book_id
INNER JOIN members m ON t.member_id = m.member_id
INNER JOIN categories c ON b.category_id = c.category_id
WHERE m.membership_status = 'Active'
GROUP BY b.book_id, b.title, b.author, c.category_name
ORDER BY borrow_count DESC;
