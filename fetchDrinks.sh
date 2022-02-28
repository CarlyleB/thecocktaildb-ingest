#!/bin/bash

content=$(curl -s  -X GET -H "Header:Value" curl https://www.thecocktaildb.com/api/json/v2/$1/search.php?f=a)
transformed=$( jq -r --arg ingredientPrefix 'strIngredient' --arg measurementPrefix 'strMeasure' '[.drinks[] |
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
		recipe: [(. as $original
			| ($original | keys) as $keys
			| $keys[]
			| select(startswith($ingredientPrefix) and $original[.] != null) as $ingredientKeys
			| [$ingredientKeys] | map({
				ingredient: $original[.],
				measurement: $original[$measurementPrefix + .[-1:]]
			})[]
		)]
	}]' <<< "${content}" )

echo "${transformed}"
