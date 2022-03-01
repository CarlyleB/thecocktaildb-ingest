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

fetchAllIngredients () {
	url="$baseUrl/list.php?i=list"

	content=$(curl -s $url)
	
	transformed=$( jq -r '[.drinks[]? | .strIngredient1] | to_entries | map([.key, .value])[] | @csv' <<< "${content}")

	echo "${transformed}"
}

dir="$(dirname "$(which "$0")")"
fetchAllIngredients > ${dir}/ingredients.csv
