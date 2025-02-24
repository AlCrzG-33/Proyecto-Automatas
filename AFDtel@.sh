#^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
#!/bin/bash

input=$1
echo "Input received: $input"

# More flexible email regex
email_regex="[[:alnum:]._-]+@[[:alnum:].-]+\.[[:alpha:]]+"

# More flexible phone regex that matches your format
phone_regex="[\(]?[0-9]{3}[\)]?[0-9\s-]+"

if [[ -f "$input" ]]; then
    echo "Processing file: $input"
    echo -e "\nPhone Numbers:"
    echo "-------------"
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Extract phone numbers first
        if [[ "$line" =~ $phone_regex ]]; then
            phone_part=$(echo "$line" | grep -o -E "$phone_regex")
            echo "$phone_part"
        fi
    done < "$input"
    
    echo -e "\nEmail Addresses:"
    echo "---------------"
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Then extract emails
        if [[ "$line" =~ $email_regex ]]; then
            email_part=$(echo "$line" | grep -o -E "$email_regex")
            echo "$email_part"
        fi
    done < "$input"
else
    echo "Invalid input"
fi
