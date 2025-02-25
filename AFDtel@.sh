#!/bin/bash

input=$1
echo "Input received: $input"

# Email regex remains the same
email_regex="[[:alnum:]._-]+@[[:alnum:].-]+\.[[:alpha:]]+"

# Strict 10-digit phone number regex
phone_regex='(\([0-9]{3}\)[ ]?|[0-9]{3}[-. ]?)[0-9]{3}[-. ]?[0-9]{4}'

content=""

if [[ -f "$input" ]]; then
    echo "Processing file: $input"
    content=$(cat "$input")
elif [[ "$input" =~ ^https?:// ]]; then
    echo "Processing URL: $input"
    output_file="downloaded.txt"
    curl -s "$input" -o "$output_file"
    if [[ -f "$output_file" ]]; then
        echo "URL content saved to $output_file"
        content=$(cat "$output_file")
    else
        echo "Failed to download URL content"
        exit 1
    fi
else
    echo "Invalid input"
    exit 1
fi

echo -e "\nPhone Numbers:"
echo "-------------"
# Extract and format phone numbers
echo "$content" | grep -oE "$phone_regex" | while read -r phone; do
    # Normalize the number format
    clean_number=$(echo "$phone" | tr -d '[:space:].()' | sed 's/-//g')
    if [[ "${#clean_number}" -eq 10 ]]; then
        echo "$phone"
    fi
done | sort -u

echo -e "\nEmail Addresses:"
echo "---------------"
echo "$content" | grep -Eo "$email_regex" | sort -u