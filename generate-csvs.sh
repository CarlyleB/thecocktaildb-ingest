#!/bin/bash

if [ $# -eq 0 ]
then
	echo "No API key provided. Response will be limited to the data available to for test API key (1)."
fi

apiKey="${1:-1}"

if [ $apiKey -eq "1" ]
then
    apiVersion="v1"
else
    apiVersion="v2"
fi

dir="$(dirname "$(which "$0")")"

baseUrl="https://www.thecocktaildb.com/api/json/${apiVersion}/${apiKey}"

### Drinks ###
fetchDrinks () {
	echo "Fetching drinks..."

	url="$baseUrl/search.php?f="

	urls=""
	for letter in {a..z}
	do
		urls+=" ${url}${letter}"
	done

	content=$(curl -s $urls)
	
	transformed=$( jq -r '.drinks[]? |
		{
			id: .idDrink,
			name: .strDrink,
			altName: .strDrinkAlternate,
			tags: .strTags,
			videoUrl: .strVideo,
			category: .strCategory,
			alcoholStatus: .strAlcoholic,
			glass: .strGlass,
			instructions: .strInstructions,
			thumbnailUrl: .strDrinkThumb,
			imgSrc: .strImageSource,
			imgAttribution: .strImageAttribution,
			ccConfirmed: .strCreativeCommonsConfirmed,
			dateModified: .dateModified,
			recipe: ([(. as $original
				| ($original | keys) as $keys
				| $keys[]
				| select(startswith("strIngredient") and $original[.] != null) as $ingredientKeys
				| [$ingredientKeys] | map({
					ingredient: $original[.],
					measurement: $original["strMeasure" + .[-1:]]
				})[]
			)]) | tostring
		} | flatten | @csv' <<< "${content}"
	)

	drinksCsvPath="${dir}/drinks/data.csv"
	echo "${transformed}" > ${drinksCsvPath}	# add drinks to csv

	drinkCount=$(wc -l ${drinksCsvPath} | cut -d " " -f1)
	echo -e "$drinkCount drinks added to $drinksCsvPath\n"	# print drink count to console
}

### Ingredients ###
fetchIngredients () {
	echo "Fetching ingredients..."

	url="$baseUrl/list.php?i=list"

	content=$(curl -s $url)
	
	transformed=$( jq -r '.drinks[]?
		| [.strIngredient1, "https://www.thecocktaildb.com/images/ingredients/" + .strIngredient1 + ".png"]
		| @csv' <<< "${content}"
	)

	ingredientsCsvPath="${dir}/ingredients/data.csv"
	echo "${transformed}" > ${ingredientsCsvPath}	# add ingredients to csv

	ingredientCount=$(wc -l $ingredientsCsvPath | cut -d " " -f1)
	echo -e "$ingredientCount ingredients added to $ingredientsCsvPath\n"	# print ingredient count to console
}

### Categories ###
fetchCategories () {
	echo "Fetching categories..."

    url="$baseUrl/list.php?c=list"

	content=$(curl -s $url)
	
	transformed=$( jq -r '.drinks[]? | [.strCategory] | @csv' <<< "${content}")

	categoriesCsvPath="${dir}/categories/data.csv"
	echo "${transformed}" > ${categoriesCsvPath}	# add categories to csv

	categoryCount=$(wc -l $categoriesCsvPath | cut -d " " -f1)
	echo -e "$categoryCount categories added to $categoriesCsvPath\n"	# print category count to console
}

### Glasses ###
fetchGlasses () {
	echo "Fetching glasses..."

    url="$baseUrl/list.php?g=list"

	content=$(curl -s $url)
	
	transformed=$( jq -r '.drinks[]? | [.strGlass] | @csv' <<< "${content}")

	glassesCsvPath="${dir}/glasses/data.csv"
	echo "${transformed}" > ${glassesCsvPath}	# add glasses to csv

	glassCount=$(wc -l $glassesCsvPath | cut -d " " -f1)
	echo -e "$glassCount glasses added to $glassesCsvPath\n"	# print glass count to console
}

fetchDrinks
fetchIngredients
fetchCategories
fetchGlasses
