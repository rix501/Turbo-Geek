USE Turbo;

DELIMITER //

DROP PROCEDURE IF EXISTS Mark_Subscription_Read;  

CREATE PROCEDURE Mark_Subscription_Read(IN p_userID INT, IN p_comicID INT)
BEGIN
    DECLARE EXIT handler for sqlexception ROLLBACK;

    START TRANSACTION;
        UPDATE subscriptions
        SET
            read_latest_comic = 1
        WHERE comicID = p_comicID
        AND userID = p_userID;
    COMMIT;
END//