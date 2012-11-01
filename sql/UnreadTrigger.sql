USE Turbo;

DELIMITER //

CREATE TRIGGER unread_trig BEFORE UPDATE ON comics
FOR EACH ROW
BEGIN

	IF NEW.last_updated <> OLD.last_updated THEN
		UPDATE subscriptions 
		SET 
			read_latest_comic = 0
		WHERE comicID = NEW.id;
	END IF;
END//
DELIMITER ;