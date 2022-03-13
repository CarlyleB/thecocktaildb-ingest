CREATE TABLE IF NOT EXISTS categories (
    name VARCHAR(255)
);

TRUNCATE TABLE categories;

\copy categories FROM 'data.csv' WITH (format csv, header false);
