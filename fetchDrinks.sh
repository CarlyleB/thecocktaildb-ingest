#!/bin/bash

display_usage() {
	echo -e "\nUsage: $0 <api_key>"
}

if [[ ( $# == "--help") ||  $# == "-h" ]]
then
	display_usage
	exit 0
fi

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

baseUrl="https://www.thecocktaildb.com/api/json/${apiVersion}/${apiKey}"

fetchAllDrinks () {
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

	echo "${transformed}"
}

fetchAllDrinks > drinks.csv
