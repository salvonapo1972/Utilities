# 404NotFound.sh - Web Spider Script

## Overview
`404NotFound.sh` is an interactive shell script that uses `wget` to spider a website and detect broken links (404 errors). It generates logs and creates an HTML report of any broken links found.

## Features
- **Interactive domain input**: Prompts user to enter a domain to scan
- **Recursive website crawling**: Uses wget to recursively traverse the website
- **Broken link detection**: Identifies broken links (404 errors) encountered during the spider crawl
- **Detailed logging**: Saves detailed wget output with timestamps
- **HTML report generation**: Creates an HTML table report listing broken links and their referrers
- **Robots.txt bypass**: Ignores robots.txt to ensure comprehensive crawling

## Requirements
- `wget` - command-line web crawler (must be in the same directory or in PATH)
- `sh` - POSIX-compliant shell interpreter
- Standard Unix utilities: `date`, `grep`, `sed`

## Usage
```bash
./404NotFound.sh
```

### Input
The script will prompt you for:
- **Domain**: Enter the domain to spider (e.g., `example.com`)

### Output
The script generates two types of output files in the `./spider_logs/` directory:

1. **Log file**: `{domain}_{timestamp}.log`
   - Contains full wget debug output and progress information

2. **HTML report** (if broken links found): `brokenlinks_{domain}_{timestamp}.html`
   - HTML table with columns:
     - **Referrer**: The page that linked to the broken link
     - **URL**: The broken link URL

## How It Works
1. Validates the domain input
2. Creates a `spider_logs` directory if it doesn't exist
3. Runs wget in spider mode with the following options:
   - `--spider`: Don't download, only check existence
   - `--recursive`: Crawl recursively through the site
   - `-d`: Enable debug output
   - `-e robots=off`: Ignore robots.txt restrictions
   - `-w 1`: 1-second wait between requests
   - `--local-encoding=utf-8`: Use UTF-8 encoding
4. Saves all output to a timestamped log file
5. Parses the log file to extract broken link information
6. Generates an HTML report with broken links and their referrers

## Example
```bash
$ ./404NotFound.sh
=== Web Spider Script ===

Enter domain to spider (e.g., example.com): example.com

Starting spider for: example.com
Output log: ./spider_logs/example.com_20260131_143022.log
[wget spider output...]

Spider completed. Log saved to: ./spider_logs/example.com_20260131_143022.log
Broken links report saved to: ./spider_logs/brokenlinks_example.com_20260131_143022.html
```

## Notes
- The script uses `tee` to display wget output in real-time while saving to the log file
- Broken link detection relies on parsing wget's debug output for specific patterns
- The `--progress=bar:force:noscroll` option shows a progress bar during crawling
- A 1-second delay between requests (`-w 1`) is implemented to be respectful to the server

## Troubleshooting
- **"wget: command not found"**: Ensure wget is in the same directory or in your system PATH
- **Empty broken links report**: The website may not have broken links, or wget may not have detected them
- **Permission denied**: Make the script executable with `chmod +x 404NotFound.sh`

