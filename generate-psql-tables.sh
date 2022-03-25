#!/bin/bash

dbName="thecocktaildb"

dir="$(dirname "$(which "$0")")"
sqlFile="table.sql"

createDB () {
    echo "Creating $dbName..."
    $( psql -c "CREATE DATABASE $dbName" )
    if [ $? = 1 ]
    then
        exit
    fi
    echo -e "\n"
}

populateTables() {
    echo "Inserting drinks"
    $( cd $dir/drinks && psql --quiet -d $dbName -f $sqlFile &> /dev/null )
    numDrinks=$( psql --quiet -d thecocktaildb -c "SELECT COUNT(*) FROM drinks" )
    echo -e "$numDrinks\n"

    echo "Inserting ingredients"
    $( cd $dir/ingredients && psql --quiet -d $dbName -f $sqlFile &> /dev/null )
    numIngredients=$( psql --quiet -d thecocktaildb -c "SELECT COUNT(*) FROM ingredients" )
    echo -e "$numIngredients\n"

    echo "Inserting categories"
    $( cd $dir/categories && psql --quiet -d $dbName -f $sqlFile &> /dev/null )
    numCategories=$( psql --quiet -d thecocktaildb -c "SELECT COUNT(*) FROM categories" )
    echo -e "$numCategories\n"

    echo "Inserting glasses"
    $( cd $dir/glasses && psql --quiet -d $dbName -f $sqlFile &> /dev/null )
    numGlasses=$( psql --quiet -d thecocktaildb -c "SELECT COUNT(*) FROM glasses" )
    echo -e "$numGlasses\n"
}

# Create database thecocktaildb if it doens't already exist.
if [ "$( psql -tAc "SELECT 1 FROM pg_database WHERE datname='$dbName'" )" = '1' ]
then
    echo -e "Database $dbName already exists.\n"
else
    echo -e "Database $dbName does not exist.\n"
    createDB
fi

populateTables
