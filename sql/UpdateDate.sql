USE Turbo;

DELIMITER //

DROP PROCEDURE IF EXISTS Subscribe;  

CREATE PROCEDURE Update_Date(IN p_comicID INT, IN p_pubDate TIMESTAMP)
BEGIN
    DECLARE EXIT handler for sqlexception ROLLBACK;

    START TRANSACTION;
        UPDATE comics
        SET
            last_updated = p_pubDate
        WHERE id = p_comicID;
    COMMIT;
END//