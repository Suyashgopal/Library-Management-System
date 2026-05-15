-- ============================================
-- Library Management System - Views
-- ============================================

USE library_db;

-- ============================================
-- View: Active Borrowings
-- Purpose: Show all currently borrowed books
-- ============================================
CREATE OR REPLACE VIEW vw_active_borrowings AS
SELECT 
    t.transaction_id,
    b.title AS book_title,
    b.author,
    m.name AS member_name,
    m.email AS member_email,
    s.name AS staff_name,
    t.borrow_date,
    t.due_date,
    DATEDIFF(CURDATE(), t.due_date) AS days_overdue,
    t.status
FROM transactions t
JOIN books b ON t.book_id = b.book_id
JOIN members m ON t.member_id = m.member_id
JOIN staff s ON t.staff_id = s.staff_id
WHERE t.status IN ('Borrowed', 'Overdue');

-- ============================================
-- View: Overdue Books
-- Purpose: Show all overdue books with fine calculation
-- ============================================
CREATE OR REPLACE VIEW vw_overdue_books AS
SELECT 
    t.transaction_id,
    b.title AS book_title,
    m.name AS member_name,
    m.phone AS member_phone,
    t.borrow_date,
    t.due_date,
    DATEDIFF(CURDATE(), t.due_date) AS days_overdue,
    DATEDIFF(CURDATE(), t.due_date) * 5.00 AS calculated_fine
FROM transactions t
JOIN books b ON t.book_id = b.book_id
JOIN members m ON t.member_id = m.member_id
WHERE t.return_date IS NULL 
  AND t.due_date < CURDATE();

-- ============================================
-- View: Book Availability
-- Purpose: Show book availability status
-- ============================================
CREATE OR REPLACE VIEW vw_book_availability AS
SELECT 
    b.book_id,
    b.title,
    b.author,
    c.category_name,
    b.total_copies,
    b.available_copies,
    (b.total_copies - b.available_copies) AS borrowed_copies,
    CASE 
        WHEN b.available_copies > 0 THEN 'Available'
        ELSE 'Not Available'
    END AS availability_status
FROM books b
JOIN categories c ON b.category_id = c.category_id;

-- ============================================
-- View: Member Borrowing History
-- Purpose: Show complete borrowing history for members
-- ============================================
CREATE OR REPLACE VIEW vw_member_history AS
SELECT 
    m.member_id,
    m.name AS member_name,
    m.email,
    COUNT(t.transaction_id) AS total_books_borrowed,
    SUM(CASE WHEN t.status = 'Borrowed' THEN 1 ELSE 0 END) AS currently_borrowed,
    SUM(CASE WHEN t.status = 'Returned' THEN 1 ELSE 0 END) AS returned_books,
    SUM(CASE WHEN t.status = 'Overdue' THEN 1 ELSE 0 END) AS overdue_books,
    COALESCE(SUM(f.fine_amount), 0) AS total_fines,
    COALESCE(SUM(CASE WHEN f.payment_status = 'Pending' THEN f.fine_amount ELSE 0 END), 0) AS pending_fines
FROM members m
LEFT JOIN transactions t ON m.member_id = t.member_id
LEFT JOIN fines f ON t.transaction_id = f.transaction_id
GROUP BY m.member_id, m.name, m.email;

-- ============================================
-- View: Popular Books
-- Purpose: Show most borrowed books
-- ============================================
CREATE OR REPLACE VIEW vw_popular_books AS
SELECT 
    b.book_id,
    b.title,
    b.author,
    c.category_name,
    COUNT(t.transaction_id) AS borrow_count,
    b.available_copies
FROM books b
JOIN categories c ON b.category_id = c.category_id
LEFT JOIN transactions t ON b.book_id = t.book_id
GROUP BY b.book_id, b.title, b.author, c.category_name, b.available_copies
ORDER BY borrow_count DESC;

-- ============================================
-- View: Fine Summary
-- Purpose: Show fine collection summary
-- ============================================
CREATE OR REPLACE VIEW vw_fine_summary AS
SELECT 
    f.fine_id,
    t.transaction_id,
    m.name AS member_name,
    b.title AS book_title,
    f.fine_amount,
    f.payment_status,
    f.payment_date,
    t.due_date,
    t.return_date
FROM fines f
JOIN transactions t ON f.transaction_id = t.transaction_id
JOIN members m ON t.member_id = m.member_id
JOIN books b ON t.book_id = b.book_id;

-- ============================================
-- View: Category Statistics
-- Purpose: Show statistics by category
-- ============================================
CREATE OR REPLACE VIEW vw_category_stats AS
SELECT 
    c.category_id,
    c.category_name,
    COUNT(DISTINCT b.book_id) AS total_books,
    SUM(b.total_copies) AS total_copies,
    SUM(b.available_copies) AS available_copies,
    COUNT(t.transaction_id) AS total_transactions
FROM categories c
LEFT JOIN books b ON c.category_id = b.category_id
LEFT JOIN transactions t ON b.book_id = t.book_id
GROUP BY c.category_id, c.category_name;

-- Display success message
SELECT 'All views created successfully!' AS Status;
