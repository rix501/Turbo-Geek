USE Turbo;

DELIMITER //

DROP PROCEDURE IF EXISTS CreateUser;  

CREATE PROCEDURE CreateUser(IN p_username VARCHAR(20), IN p_password VARCHAR(24))
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
        INSERT INTO users
        (
            username,
            password
        )
        VALUES
        (
            p_username,
            p_password
        );
    COMMIT;
END//