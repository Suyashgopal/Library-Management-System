-- ============================================
-- Stored Procedure: Calculate Fine
-- Purpose: Calculate fine for a specific transaction
-- ============================================

USE library_db;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_calculate_fine$$

CREATE PROCEDURE sp_calculate_fine(
    IN p_transaction_id INT,
    OUT p_fine_amount DECIMAL(10,2),
    OUT p_days_overdue INT
)
BEGIN
    DECLARE v_due_date DATE;
    DECLARE v_return_date DATE;
    DECLARE v_status VARCHAR(20);
    
    -- Get transaction details
    SELECT due_date, return_date, status 
    INTO v_due_date, v_return_date, v_status
    FROM transactions
    WHERE transaction_id = p_transaction_id;
    
    -- If book not returned yet, use current date
    IF v_return_date IS NULL THEN
        SET v_return_date = CURDATE();
    END IF;
    
    -- Calculate days overdue
    SET p_days_overdue = DATEDIFF(v_return_date, v_due_date);
    
    -- Calculate fine (₹5 per day, minimum 0)
    IF p_days_overdue > 0 THEN
        SET p_fine_amount = p_days_overdue * 5.00;
    ELSE
        SET p_fine_amount = 0.00;
        SET p_days_overdue = 0;
    END IF;
END$$

DELIMITER ;

-- Test the procedure
-- CALL sp_calculate_fine(6, @fine, @days);
-- SELECT @fine AS Fine_Amount, @days AS Days_Overdue;
