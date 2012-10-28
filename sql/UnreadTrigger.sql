DELIMITER //

CREATE TRIGGER unread_trig AFTER UPDATE ON 'comics'
FOR EACH ROW
BEGIN
    UPDATE subscriptions
		SET read_latest = 0
    WHERE NEW.id = subscriptions.comic_id;
END//
DELIMITER ;