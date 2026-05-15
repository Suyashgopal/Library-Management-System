-- Trigger: Calculate Fine on Book Return
USE library_db;

DELIMITER $$

CREATE TRIGGER trg_calculate_fine
BEFORE UPDATE ON transactions
FOR EACH ROW
BEGIN
    -- Only calculate fine when return_date is being set
    IF NEW.return_date IS NOT NULL AND OLD.return_date IS NULL THEN
        -- If returned after due date, calculate fine (Rs. 10 per day)
        IF NEW.return_date > NEW.due_date THEN
            SET NEW.fine = DATEDIFF(NEW.return_date, NEW.due_date) * 10;
        ELSE
            SET NEW.fine = 0;
        END IF;
        
        -- Mark book as available again
        UPDATE books 
        SET available = TRUE 
        WHERE book_id = NEW.book_id;
    END IF;
END$$

DELIMITER ;

-- Example: How the trigger works automatically
-- UPDATE transactions SET return_date = '2024-05-20' WHERE transaction_id = 2;
