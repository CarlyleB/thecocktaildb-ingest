# thecocktaildb-ingest

Gets available
* drinks
* ingredients
* glasses
* categories

from [TheCocktailDB](https://thecocktaildb.com/), transforms the data into a (subjectively) friendlier format, and dumps it all into CSVs.

**The goal is to use TheCocktailDB data without having to rely on its limited API.**

## Usage

### Generating CSVs
```
# If an api key isn't provided, the free testing api key "1" will be used, so the data returned by TheCocktailDB will be limited. API keys are available for TheCocktailDB patreon supporters.

./generate-csvs <api_key>
```

This will add a `data.csv` file under each relevant directory (ex - `drinks/data.csv`, `ingredients/data.csv`, etc.). These CSVs can then be used to populate a datastore.

### Populating PostgreSQL tables
Support for creating and populating PostgreSQL tables is located in `<type_directory>/table.sql`.

Invoke after `./generate-csvs` has completed.

For example:

```
cd drinks
psql -h <host> -U <user> -d <database> -f table.sql
```
