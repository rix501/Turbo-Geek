USE Turbo;

DELIMITER //

DROP PROCEDURE IF EXISTS Subscribe;  

CREATE PROCEDURE Subscribe(IN p_userID INT, IN p_comicID INT)
BEGIN
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