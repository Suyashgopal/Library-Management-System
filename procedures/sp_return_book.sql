-- ============================================
-- Stored Procedure: Return Book
-- Purpose: Handle book returns and calculate fines
-- ============================================

USE library_db;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_return_book$$

CREATE PROCEDURE sp_return_book(
    IN p_transaction_id INT,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_book_id INT;
    DECLARE v_due_date DATE;
    DECLARE v_return_date DATE;
    DECLARE v_days_overdue INT;
    DECLARE v_fine_amount DECIMAL(10,2);
    DECLARE v_status VARCHAR(20);
    
    -- Error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_message = 'Error: Transaction failed';
    END;
    
    START TRANSACTION;
    
    -- Get transaction details
    SELECT book_id, due_date, status INTO v_book_id, v_due_date, v_status
    FROM transactions
    WHERE transaction_id = p_transaction_id;
    
    IF v_book_id IS NULL THEN
        SET p_message = 'Error: Transaction not found';
        ROLLBACK;
    ELSEIF v_status = 'Returned' THEN
        SET p_message = 'Error: Book already returned';
        ROLLBACK;
    ELSE
        SET v_return_date = CURDATE();
        
        -- Calculate overdue days
        SET v_days_overdue = DATEDIFF(v_return_date, v_due_date);
        
        IF v_days_overdue > 0 THEN
            -- Calculate fine (₹5 per day)
            SET v_fine_amount = v_days_overdue * 5.00;
            
            -- Insert fine record
            INSERT INTO fines (transaction_id, fine_amount, payment_status)
            VALUES (p_transaction_id, v_fine_amount, 'Pending');
            
            SET p_message = CONCAT('Book returned. Fine: ₹', v_fine_amount, ' (', v_days_overdue, ' days overdue)');
        ELSE
            SET p_message = 'Book returned on time. No fine.';
        END IF;
        
        -- Update transaction
        UPDATE transactions
        SET return_date = v_return_date,
            status = 'Returned'
        WHERE transaction_id = p_transaction_id;
        
        -- Update book availability
        UPDATE books
        SET available_copies = available_copies + 1
        WHERE book_id = v_book_id;
        
        COMMIT;
    END IF;
END$$

DELIMITER ;

-- Test the procedure
-- CALL sp_return_book(1, @msg);
-- SELECT @msg;
