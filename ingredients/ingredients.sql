CREATE TABLE IF NOT EXISTS ingredients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

\copy ingredients FROM 'ingredients.csv' WITH (format csv, header false);
