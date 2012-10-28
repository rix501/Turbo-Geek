USE Turbo;

DELIMITER //

DROP PROCEDURE IF EXISTS GetNewComics;  

CREATE PROCEDURE GetNewComics(IN p_userID varchar(200))
BEGIN
    SELECT 
        c.id,
        c.name,
        c.site,
        c.feed,
        c.store,
        c.lastGuid,
        c.lastUpdated,
        s.read_latest_comic as readLatestComic,
        CASE 
            WHEN u.id = IFNULL(p_userID, 0) THEN 1 else 0
        END AS subscribed
    FROM new_comics c
        LEFT JOIN subscriptions s ON c.id = s.comicID
        LEFT JOIN users u ON s.userID = u.id;
END//