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

	echo "${transformed}" > ${dir}/drinks/data.csv

}

### Ingredients ###
fetchIngredients () {
	url="$baseUrl/list.php?i=list"

	content=$(curl -s $url)
	
	transformed=$( jq -r '.drinks[]?
		| [.strIngredient1, "https://www.thecocktaildb.com/images/ingredients/" + .strIngredient1 + ".png"]
		| @csv' <<< "${content}"
	)

	echo "${transformed}" > ${dir}/ingredients/data.csv
}

### Categories ###
fetchCategories () {
    url="$baseUrl/list.php?c=list"

	content=$(curl -s $url)
	
	transformed=$( jq -r '.drinks[]? | [.strCategory] | @csv' <<< "${content}")

	echo "${transformed}" > ${dir}/categories/data.csv
}

### Glasses ###
fetchGlasses () {
    url="$baseUrl/list.php?g=list"

	content=$(curl -s $url)
	
	transformed=$( jq -r '.drinks[]? | [.strGlass] | @csv' <<< "${content}")

	echo "${transformed}" > ${dir}/glasses/data.csv
}

fetchDrinks
fetchCategories
fetchGlasses
fetchIngredients
