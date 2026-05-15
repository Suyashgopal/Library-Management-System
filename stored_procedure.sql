-- Stored Procedure: Borrow a Book
USE library_db;

DELIMITER $$

CREATE PROCEDURE sp_borrow_book(
    IN p_book_id INT,
    IN p_member_id INT
)
BEGIN
    DECLARE v_available BOOLEAN;
    
    -- Check if book is available
    SELECT available INTO v_available 
    FROM books 
    WHERE book_id = p_book_id;
    
    IF v_available = TRUE THEN
        -- Insert transaction record
        INSERT INTO transactions (book_id, member_id, borrow_date, due_date)
        VALUES (p_book_id, p_member_id, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY));
        
        -- Update book availability
        UPDATE books 
        SET available = FALSE 
        WHERE book_id = p_book_id;
        
        SELECT 'Book borrowed successfully!' AS message;
    ELSE
        SELECT 'Book is not available!' AS message;
    END IF;
END$$

DELIMITER ;

-- Example: How to call the stored procedure
-- CALL sp_borrow_book(6, 5);
