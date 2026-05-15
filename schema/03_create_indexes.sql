-- ============================================
-- Library Management System - Index Creation
-- Purpose: Improve query performance
-- ============================================

USE library_db;

-- Indexes on foreign keys for faster JOINs
CREATE INDEX idx_books_category ON books(category_id);
CREATE INDEX idx_transactions_book ON transactions(book_id);
CREATE INDEX idx_transactions_member ON transactions(member_id);
CREATE INDEX idx_transactions_staff ON transactions(staff_id);
CREATE INDEX idx_fines_transaction ON fines(transaction_id);
CREATE INDEX idx_reservations_book ON reservations(book_id);
CREATE INDEX idx_reservations_member ON reservations(member_id);

-- Indexes on frequently queried columns
CREATE INDEX idx_members_email ON members(email);
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_author ON books(author);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_due_date ON transactions(due_date);
CREATE INDEX idx_fines_payment_status ON fines(payment_status);

-- Composite indexes for common query patterns
CREATE INDEX idx_transactions_member_status ON transactions(member_id, status);
CREATE INDEX idx_books_category_available ON books(category_id, available_copies);

-- Display success message
SELECT 'All indexes created successfully!' AS Status;
