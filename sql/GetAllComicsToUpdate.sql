USE Turbo;

CREATE OR REPLACE VIEW all_comics_to_update
AS 
SELECT 
    c.id,
    c.name,
    c.site,
    c.feed,
    c.last_updated AS lastUpdated
FROM comics c
WHERE IFNULL(c.schedule, 127) & POWER(2, DATE_FORMAT(DATE(NOW()) , '%w')) > 0
AND DATE_FORMAT(c.last_updated, '%Y%m%d') <> DATE_FORMAT(DATE(NOW()), '%Y%m%d')