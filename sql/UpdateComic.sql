USE Turbo;

DELIMITER //

DROP PROCEDURE IF EXISTS Update_Comic;  

CREATE PROCEDURE Update_Comic(IN p_comicID INT, IN p_pubDate TIMESTAMP, IN p_guid VARCHAR(300))
BEGIN
    DECLARE EXIT handler for sqlexception ROLLBACK;

    START TRANSACTION;
        UPDATE comics
        SET
            last_updated = p_pubDate,
            last_guid = p_guid
        WHERE id = p_comicID;

        UPDATE subscriptions 
        SET 
        	read_latest_comic = 0
        WHERE comicID = p_comicID;
    COMMIT;
END//