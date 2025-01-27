#!/bin/bash

# Function to download index for a specific country
download_index() {
    local country_code=$1
    local user_agent="docker: smennig/photon-geocoder"
    local base_url="http://download1.graphhopper.com/public/extracts/by-country-code"
    local target_url="${base_url}/${country_code}/photon-db-${country_code}-latest.tar.bz2"

    echo "Downloading search index for country: $country_code"
    
    wget --user-agent="$user_agent" -O - "$target_url" | bzip2 -cd | tar x
    
    if [ $? -ne 0 ]; then
        echo "Failed to download or extract index for country: $country_code"
    else
        echo "Successfully downloaded and extracted index for country: $country_code"
    fi
}

# Default to Germany if no country codes are provided
if [ $# -eq 0 ]; then
    echo "No country codes provided. Defaulting to Germany (de)."
    set -- de
fi

# Check for the existence of the elasticsearch index directory
if [ ! -d "/photon/photon_data/elasticsearch" ]; then
    echo "Elasticsearch index directory does not exist. Proceeding with download."
    echo "Countries to download $@"

    # Loop through the provided country codes and download each index
    for country_code in "$@"; do
        download_index "$country_code"
    done
else
    echo "Elasticsearch index directory already exists. Skipping download."
fi

# Start photon if the elasticsearch directory exists
if [ -d "/photon/photon_data/elasticsearch" ]; then
    echo "Starting Photon service."
    java -jar photon.jar "$@"
else
    echo "Could not start Photon, the search index could not be found."
fi
