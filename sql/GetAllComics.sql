USE Turbo;

CREATE OR REPLACE VIEW all_comics
AS 
SELECT 
    c.id,
    c.name,
    c.site,
    c.feed,
    c.last_updated AS lastUpdated
FROM comics c