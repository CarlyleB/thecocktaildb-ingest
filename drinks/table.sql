CREATE TABLE IF NOT EXISTS drinks (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255),
    altName VARCHAR(255),
    tags VARCHAR(255),
    videoUrl VARCHAR(500),
    category VARCHAR(50),
    alcoholStatus VARCHAR(50),
    glass VARCHAR(50),
    instructions VARCHAR,
    thumbnailUrl VARCHAR(500),
    imgSrc VARCHAR(500),
    imgAttribution VARCHAR(255),
    ccConfirmed BOOLEAN,
    dateModified TIMESTAMP,
    recipe VARCHAR
);

TRUNCATE TABLE drinks;

\copy drinks FROM 'data.csv' WITH (format csv, header false);
