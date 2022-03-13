CREATE TABLE IF NOT EXISTS glasses (
    name VARCHAR(255)
);

TRUNCATE TABLE glasses;

\copy glasses FROM 'data.csv' WITH (format csv, header false);
