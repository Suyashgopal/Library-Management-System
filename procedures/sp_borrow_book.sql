-- ============================================
-- Stored Procedure: Borrow Book
-- Purpose: Handle book borrowing with validation
-- ============================================

USE library_db;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_borrow_book$$

CREATE PROCEDURE sp_borrow_book(
    IN p_book_id INT,
    IN p_member_id INT,
    IN p_staff_id INT,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_available_copies INT;
    DECLARE v_member_status VARCHAR(20);
    DECLARE v_borrow_date DATE;
    DECLARE v_due_date DATE;
    
    -- Error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_message = 'Error: Transaction failed';
    END;
    
    START TRANSACTION;
    
    -- Check if member exists and is active
    SELECT membership_status INTO v_member_status
    FROM members
    WHERE member_id = p_member_id;
    
    IF v_member_status IS NULL THEN
        SET p_message = 'Error: Member not found';
        ROLLBACK;
    ELSEIF v_member_status != 'Active' THEN
        SET p_message = 'Error: Member is not active';
        ROLLBACK;
    ELSE
        -- Check book availability
        SELECT available_copies INTO v_available_copies
        FROM books
        WHERE book_id = p_book_id;
        
        IF v_available_copies IS NULL THEN
            SET p_message = 'Error: Book not found';
            ROLLBACK;
        ELSEIF v_available_copies <= 0 THEN
            SET p_message = 'Error: Book not available';
            ROLLBACK;
        ELSE
            -- Set dates
            SET v_borrow_date = CURDATE();
            SET v_due_date = DATE_ADD(CURDATE(), INTERVAL 14 DAY);
            
            -- Insert transaction
            INSERT INTO transactions (book_id, member_id, staff_id, borrow_date, due_date, status)
            VALUES (p_book_id, p_member_id, p_staff_id, v_borrow_date, v_due_date, 'Borrowed');
            
            -- Update available copies
            UPDATE books
            SET available_copies = available_copies - 1
            WHERE book_id = p_book_id;
            
            SET p_message = CONCAT('Success: Book borrowed. Due date: ', v_due_date);
            COMMIT;
        END IF;
    END IF;
END$$

DELIMITER ;

-- Test the procedure
-- CALL sp_borrow_book(1, 1, 1, @msg);
-- SELECT @msg;
