CREATE TABLE IF NOT EXISTS ingredients (
    name VARCHAR(255),
    thumbnailUrl VARCHAR(500)
);

TRUNCATE TABLE ingredients;

\copy ingredients FROM 'data.csv' WITH (format csv, header false);
