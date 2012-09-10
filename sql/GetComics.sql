USE Turbo;

DELIMITER //

DROP PROCEDURE IF EXISTS GetComics;  

CREATE PROCEDURE GetComics(IN userID varchar(200))
BEGIN
    SELECT 
        c.id,
        c.name,
        c.site,
        c.feed,
        c.last_updated AS lastUpdated,
        CASE 
            WHEN ISNULL(u.id) = 0 THEN 1 else 0
        END AS IsMine
    FROM comics c
        LEFT JOIN subscriptions s ON c.id = s.comicID
        LEFT JOIN users u ON s.userID = u.id;
END//