USE Turbo;

DELIMITER //

DROP PROCEDURE IF EXISTS GetUserComics;  

CREATE PROCEDURE GetUserComics(IN p_userID varchar(200))
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
        1 AS subscribed
    FROM all_comics c
        INNER JOIN subscriptions s ON c.id = s.comicID
        INNER JOIN users u ON s.userID = u.id
    WHERE u.id = p_userID;
END//