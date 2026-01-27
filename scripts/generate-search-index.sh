#!/bin/bash
# Generate search index from PDF files with page-level text extraction
# Usage: ./generate-search-index.sh <pdf-directory> <output-file>

PDF_DIR="${1:-pdf-output}"
OUTPUT="${2:-$PDF_DIR/search-index.json}"

echo "Generating search index from PDFs in $PDF_DIR..."

# Start JSON array
echo '[' > "$OUTPUT"

first=true
for pdf in "$PDF_DIR"/*.pdf; do
    [ -f "$pdf" ] || continue

    filename=$(basename "$pdf" .pdf)

    # Skip the zip file if it somehow got here
    [[ "$filename" == *"all-documents"* ]] && continue

    # Extract document number and title
    doc_num=${filename%%-*}
    # Convert kebab-case to title, fix common abbreviations
    title=$(echo "${filename#*-}" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g' | \
        sed 's/\bIt\b/IT/g; s/\bOt\b/OT/g; s/\bPlc\b/PLC/g; s/\bIec\b/IEC/g; s/\bNist\b/NIST/g' | \
        sed 's/\bDmz\b/DMZ/g; s/\bOpc\b/OPC/g; s/\bUa\b/UA/g; s/\bDnp3\b/DNP3/g; s/\bIds\b/IDS/g' | \
        sed 's/\bNerc\b/NERC/g; s/\bCip\b/CIP/g; s/\bSp\b/SP/g; s/\bIr\b/IR/g; s/\bTrisis\b/TRISIS/g' | \
        sed 's/\bIps\b/IPS/g; s/\bSiem\b/SIEM/g; s/\bHmi\b/HMI/g; s/\bScada\b/SCADA/g' | \
        sed 's/\bSis\b/SIS/g; s/\bS7comm\b/S7comm/g; s/\bBacnet\b/BACnet/g' | \
        sed 's/ Vs / vs /g; s/ And / and /g; s/ Or / or /g; s/ The / the /g; s/ A / a /g; s/ An / an /g; s/ In / in /g; s/ For / for /g; s/ To / to /g')

    # Determine category based on document number
    num_int=$((10#$doc_num))
    if [ $num_int -lt 100 ]; then
        category="Fundamentals"
    elif [ $num_int -lt 200 ]; then
        category="Standards & Compliance"
    elif [ $num_int -lt 300 ]; then
        category="Protocols & Technologies"
    elif [ $num_int -lt 400 ]; then
        category="Architecture & Design"
    elif [ $num_int -lt 500 ]; then
        category="Threats & Attacks"
    elif [ $num_int -lt 600 ]; then
        category="Detection & Monitoring"
    elif [ $num_int -lt 700 ]; then
        category="Incident Response"
    elif [ $num_int -lt 800 ]; then
        category="Assessments"
    else
        category="Solutions & Tools"
    fi

    # Get total page count
    total_pages=$(pdfinfo "$pdf" 2>/dev/null | grep "^Pages:" | awk '{print $2}')

    if [ -z "$total_pages" ] || [ "$total_pages" -eq 0 ]; then
        echo "  Skipping $filename (could not determine page count)"
        continue
    fi

    # Add comma before all but first entry
    if [ "$first" = true ]; then
        first=false
    else
        echo ',' >> "$OUTPUT"
    fi

    # Start document object
    cat >> "$OUTPUT" << JSONEOF
  {
    "id": "$filename",
    "num": "$doc_num",
    "title": "$title",
    "category": "$category",
    "totalPages": $total_pages,
    "pages": [
JSONEOF

    # Extract text page by page
    first_page=true
    for ((page=1; page<=total_pages; page++)); do
        # Extract text for this specific page
        page_content=$(pdftotext -f $page -l $page -layout "$pdf" - 2>/dev/null | \
            # Remove control characters and normalize whitespace
            tr -d '\000-\010\013\014\016-\037' | \
            tr '\n\r\t' '   ' | \
            sed 's/  */ /g' | \
            # Escape special JSON characters (backslash first, then quotes)
            sed 's/\\/\\\\/g' | \
            sed 's/"/\\"/g' | \
            # Limit content per page (keep first ~5000 chars per page)
            cut -c1-5000)

        # Skip empty pages
        if [ -z "$(echo "$page_content" | tr -d ' ')" ]; then
            continue
        fi

        # Add comma before all but first page
        if [ "$first_page" = true ]; then
            first_page=false
        else
            echo ',' >> "$OUTPUT"
        fi

        # Write page object
        cat >> "$OUTPUT" << JSONEOF
      {"page": $page, "text": "$page_content"}
JSONEOF
    done

    # Close pages array and document object
    echo '' >> "$OUTPUT"
    echo '    ]' >> "$OUTPUT"
    echo -n '  }' >> "$OUTPUT"

    echo "  Indexed: $filename ($total_pages pages)"
done

# Close JSON array
echo '' >> "$OUTPUT"
echo ']' >> "$OUTPUT"

# Get file size
size=$(ls -lh "$OUTPUT" | awk '{print $5}')
count=$(grep -c '"id"' "$OUTPUT")

echo "Search index generated: $OUTPUT ($size, $count documents)"
