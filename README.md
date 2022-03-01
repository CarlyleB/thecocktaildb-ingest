# thecocktaildb-ingest

## Usage
Get all available...
* drinks
* ingredients
* glasses
* categories
...from thecocktaildb, transform the data to a more friendly format, and output to `<type_directory>/data.csv`.

If an api key isn't provided, the free testing api key "1" will be used and the response will be limited.

```
./generate-csvs <api_key>
```

The resulting `data.csv` files can then be used to populate a datastore.

Specific postgresql support for creating and populating tables located in `<type_directory>/table.sql`.

Invoke after `./generate-csvs` has completed.

For example:

```
cd drinks
psql -h <host> -U <user> -d <database> -f table.sql
```
