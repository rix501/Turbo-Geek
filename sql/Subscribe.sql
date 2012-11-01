USE Turbo;

DELIMITER //

DROP PROCEDURE IF EXISTS Subscribe;  

CREATE PROCEDURE Subscribe(IN p_userID INT, IN p_comicID INT)
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
        INSERT INTO subscriptions
        (
            userID,
            comicID
        )
        VALUES
        (
            p_userID,
            p_comicID
        );
    COMMIT;
END//