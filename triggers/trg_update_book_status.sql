-- ============================================
-- Trigger: Update Book Status
-- Purpose: Update transaction status to 'Overdue' when return date is updated
-- ============================================

USE library_db;

DELIMITER $$

DROP TRIGGER IF EXISTS trg_update_book_status$$

CREATE TRIGGER trg_update_book_status
BEFORE UPDATE ON transactions
FOR EACH ROW
BEGIN
    -- If return date is being set and it's after due date, mark as overdue
    IF NEW.return_date IS NOT NULL AND OLD.return_date IS NULL THEN
        IF NEW.return_date > NEW.due_date THEN
            SET NEW.status = 'Returned'; -- Still mark as returned, fine will be calculated
        ELSE
            SET NEW.status = 'Returned';
        END IF;
    END IF;
    
    -- If book is not returned and past due date, mark as overdue
    IF NEW.return_date IS NULL AND NEW.due_date < CURDATE() THEN
        SET NEW.status = 'Overdue';
    END IF;
END$$

DELIMITER ;

-- Display success message
SELECT 'Trigger trg_update_book_status created successfully!' AS Status;
