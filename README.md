# thecocktaildb-ingest

Fetches available
* drinks
* ingredients
* glasses
* categories

from [TheCocktailDB](https://thecocktaildb.com/), transforms the data into a (subjectively) friendlier format, and dumps it all into CSVs.

**The goal is to use TheCocktailDB data without having to rely on its limited API.**

## Requirements
`jq` must be installed on your system

## Usage

If an api key isn't provided, the free testing api key "1" will be used, so the data returned by TheCocktailDB will be limited. API keys are available for TheCocktailDB patreon supporters.

### Generating CSVs
```
./generate-csvs.sh <api_key>
```

This will add a `data.csv` file under each relevant directory (ex - `drinks/data.csv`, `ingredients/data.csv`, etc.). These CSVs can then be used to populate a datastore.

### Populating PostgreSQL tables
Once `generate-csvs` completes, those csvs can be used to populate PostgreSQL tables.

If a local psql instance exists, run `./generate-psql-tables.sh` to create a database called `thecocktaildb` and populate tables.

Otherwise, the individual tables may be manually created. For example, to create the `drinks` table:

`cd drinks && psql -h <host> -U <user> -d <database> -f table.sql`
