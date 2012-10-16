USE Turbo;

CREATE OR REPLACE VIEW new_comics
AS 
SELECT 
	c.id, 
	c.name, 
	c.site, 
	c.feed, 
	c.last_updated AS lastUpdated
FROM comics c
WHERE DATE_FORMAT(DATE(NOW()), '%Y%m%d') = DATE_FORMAT(c.last_updated, '%Y%m%d')