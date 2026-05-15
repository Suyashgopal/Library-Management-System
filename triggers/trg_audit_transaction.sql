-- ============================================
-- Trigger: Audit Transaction
-- Purpose: Log all new transactions to audit_log
-- ============================================

USE library_db;

DELIMITER $$

DROP TRIGGER IF EXISTS trg_audit_transaction$$

CREATE TRIGGER trg_audit_transaction
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (transaction_id, action, details)
    VALUES (
        NEW.transaction_id,
        'BOOK_BORROWED',
        CONCAT('Book ID: ', NEW.book_id, ', Member ID: ', NEW.member_id, 
               ', Staff ID: ', NEW.staff_id, ', Due Date: ', NEW.due_date)
    );
END$$

DELIMITER ;

-- Display success message
SELECT 'Trigger trg_audit_transaction created successfully!' AS Status;
