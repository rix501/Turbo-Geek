USE Turbo;

DELIMITER //

DROP PROCEDURE IF EXISTS Get_User;  

CREATE PROCEDURE Get_User(IN p_username VARCHAR(200))
BEGIN

    SELECT
    	id,
    	username,
    	password
    FROM users
    WHERE username = p_username;
END//