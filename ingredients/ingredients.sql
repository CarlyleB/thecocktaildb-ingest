CREATE TABLE IF NOT EXISTS ingredients (
    name VARCHAR(255),
    thumbnailUrl VARCHAR(500)
);

\copy ingredients FROM 'ingredients.csv' WITH (format csv, header false);
