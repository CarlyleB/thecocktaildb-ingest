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

baseUrl="https://www.thecocktaildb.com/api/json/${apiVersion}/${apiKey}"

fetchAllGlasses () {
	url="$baseUrl/list.php?g=list"

	content=$(curl -s $url)
	
	transformed=$( jq -r '.drinks[]? | [.strGlass] | @csv' <<< "${content}")

	echo "${transformed}"
}

dir="$(dirname "$(which "$0")")"
fetchAllGlasses > ${dir}/glasses.csv
