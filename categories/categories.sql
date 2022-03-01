CREATE TABLE IF NOT EXISTS categories (
    name VARCHAR(255)
);

\copy categories FROM 'categories.csv' WITH (format csv, header false);
