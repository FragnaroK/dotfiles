#!/bin/bash

# This script finds all the adobe stock links in each page of a unit, 
# removes duplicated links and then open all the links on Google Chrome 

# Note: Script was partially made with AI for Ubuntu and adapted manually for MacOS and
#       does not require third-party pkgs nor admin permission

set -euo pipefail
shopt -s nullglob

# Create temporary files for all links and unique links
temp_links=$(mktemp /tmp/links_found.XXXXXX)
temp_unique=$(mktemp /tmp/unique_links.XXXXXX)

# Ensure temporary files are removed upon exit (even on error)
cleanup() {
    rm -f "$temp_links" "$temp_unique"
}
trap cleanup EXIT

echo "Starting link extraction from HTML files..."
sleep 2

# Gather all HTML files in current directory
html_files=(*.html)
if [[ ${#html_files[@]} -eq 0 ]]; then
    echo "No HTML files found in the current directory. Exiting."
    exit 1
fi

# Process each HTML file and extract href attributes and links in comments.
for html_file in "${html_files[@]}"; do
    echo "Processing file: $html_file"
    # Extract href attributes
    if grep -Eo 'href="([^"]+)"' "$html_file" >> "$temp_links"; then
        :  # Matches found; continue.
    else
        rc=$?
        # Only warn if grep failed with an error other than 1 (no match)
        if [[ $rc -ne 1 ]]; then
            echo "Warning: Failed to process file $html_file (error code: $rc)" >&2
        fi
    fi
    # Extract links inside HTML comments
    # This will find URLs inside <!-- ... -->
    if grep -Eo '<!--[^>]*https?://[^ ]+[^>]*-->' "$html_file" | grep -Eo 'https?://[^ >]+' >> "$temp_links"; then
        :  # Matches found; continue.
    fi
done

echo "Extraction complete. Links temporarily saved in: $temp_links"
echo "Cleaning duplicated Adobe Stock links..."
sleep 2

# Extract and transform links, write to temp_unique
while IFS= read -r line || [[ -n "$line" ]]; do
    # Extract Adobe Stock links (if present)
    unique_link=$(grep -Eo 'https:\/\/stock\.adobe\.com[^"]+' <<< "$line" || true)
    if [[ -n "$unique_link" ]]; then
        echo "$unique_link"
    fi

    # Extract ftcdn.net links and generate Adobe Stock links
    ftcdn_link=$(grep -Eo 'https:\/\/as[0-9]+\.ftcdn\.net(\/v2)?\/[a-z]+\/[0-9]+\/[0-9]+\/[0-9]+\/[0-9]+\/1000_F_[0-9]+_[A-Za-z0-9]+\.([a-zA-Z0-9]+)' <<< "$line" || true)
    if [[ -n "$ftcdn_link" ]]; then
        ftcdn_id=$(sed -n 's/.*1000_F_\([0-9]\+\)_.*/\1/p' <<< "$ftcdn_link")
        if [[ -n "$ftcdn_id" ]]; then
            echo "https://stock.adobe.com/au/$ftcdn_id"
        fi
    fi
done < "$temp_links" | sort | uniq > "$temp_unique"

# Check if any Adobe Stock links were found
if [[ ! -s "$temp_unique" ]]; then
    echo "No Adobe Stock links found. Exiting."
    exit 0
fi

echo "Unique Adobe Stock links saved in temporary file: $temp_unique"
echo "Preparing to open links in browser..."
sleep 2 

while IFS= read -r line || [[ -n "$line" ]]; do
    echo "Opening: $line"
    open -n '/Applications/Google Chrome.app' --args  "$line"
done < "$temp_unique"

