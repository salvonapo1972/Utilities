#!/bin/sh

# Interactive web spider using wget

echo "=== Web Spider Script ==="
echo

# Ask for domain
echo -n "Enter domain to spider (e.g., example.com): "
read domain

# Validate domain
if [ -z "$domain" ]; then
    echo "Error: Domain cannot be empty"
    exit 1
fi

# Create log directory
log_dir="./spider_logs"
mkdir -p "$log_dir"

# Define log file with timestamp
timestamp=$(date +%Y%m%d_%H%M%S)
log_file="$log_dir/${domain}_${timestamp}.log"

echo
echo "Starting spider for: $domain"
echo "Output log: $log_file"
echo

# Run wget spider
./wget --spider --recursive --local-encoding=utf-8 -d -e robots=off -w 1 -r -p  --show-progress --progress=bar:force:noscroll   "https://$domain" 2>&1 | tee $log_file 

# Display summary
echo
echo "Spider completed. Log saved to: $log_file"


#broken_links_section=$(sed -n '/Broken links/,/broken links/p' "www.fiscooggi.it_20260124_115816.log")
broken_links_section=$(grep -A 1000 'broken links.' $log_file)

if [ -n "$broken_links_section" ]; then
    output_file="$log_dir/brokenlinks_${domain}_$timestamp.html"

    echo "<table border=\"2\">" >> "$output_file"
    echo "<tr><th>Referrer</th>" >> "$output_file"
    echo "<th>URL</th></tr>" >> "$output_file"
    while IFS= read -r line; do
        # Check if line is a URL (starts with http)
        if [[ "$line" =~ ^https?:// ]]; then
            url="$line"
            # Find the referer line for this URL
            echo $url
            referer=$(grep -A 10 "$(echo "$url" | sed 's/[&/\]/\\&/g')" $log_file | grep "Referer:" | tail -1)
            #referer=$(echo "$referer" | sed -i 's/Referer/''/' ) 
            referer=$(echo "${referer//"Referer:"/ }")
            echo $referer
            echo "<tr>" >> "$output_file"
            echo "<td> <a href="$referer"> $referer</a></td>" >> "$output_file"
            echo "<td> <a href="$url">$url</td>" >> "$output_file"
            echo "</tr>" >> "$output_file"
            
        fi
    done <<< "$broken_links_section"
    
    echo "Broken links report saved to: $output_file"
fi
echo "</table>" >> "$output_file"


