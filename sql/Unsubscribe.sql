USE Turbo;

DELIMITER //

DROP PROCEDURE IF EXISTS Unsubscribe;  

CREATE PROCEDURE Unsubscribe(IN p_userID INT, IN p_comicID INT)
BEGIN
	DECLARE EXIT handler for 1062 
	BEGIN
	    SELECT "Duplicate entry in table" AS error;
	    ROLLBACK;
	END;
	DECLARE EXIT handler for 1048
	BEGIN
	    SELECT "Trying to populate a non-null column with null value" AS error;
	    ROLLBACK;
	END;
    DECLARE EXIT handler for sqlexception ROLLBACK;

    START TRANSACTION;
        DELETE FROM subscriptions
        WHERE userID = p_userID
        AND comicID = p_comicID;
    COMMIT;
END//