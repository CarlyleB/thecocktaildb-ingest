# thecocktaildb-ingest

## Usage
Get all available drinks from thecocktaildb, transform the response to a more friendly format, and output to drinks.csv
If an api key isn't provided, the free testing api key "1" will be used and the response will be limited.

```
./fetchDrinks <_api_key>
```

The resulting `drinks.csv` file can then be used to populate a datastore.

Specific postgresql support for creating and populating a table called `drinks` is provided in `drinks.sql`.
Invoke after `drinks.csv` has been created:

```
psql -h <host> -U <user> -d <database> -f drinks.sql
```
