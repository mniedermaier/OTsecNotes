#!/bin/bash
# Generate search index from PDF files
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

    # Extract text content using pdftotext
    # -layout preserves layout, -nopgbrk removes page breaks
    content=$(pdftotext -layout -nopgbrk "$pdf" - 2>/dev/null | \
        # Remove control characters and normalize whitespace
        tr -d '\000-\010\013\014\016-\037' | \
        tr '\n\r\t' '   ' | \
        sed 's/  */ /g' | \
        # Escape special JSON characters (backslash first, then quotes)
        sed 's/\\/\\\\/g' | \
        sed 's/"/\\"/g' | \
        # Limit content length to avoid huge index (keep first ~15000 chars)
        cut -c1-15000)

    # Add comma before all but first entry
    if [ "$first" = true ]; then
        first=false
    else
        echo ',' >> "$OUTPUT"
    fi

    # Write JSON object
    cat >> "$OUTPUT" << JSONEOF
  {
    "id": "$filename",
    "num": "$doc_num",
    "title": "$title",
    "category": "$category",
    "content": "$content"
  }
JSONEOF

    echo "  Indexed: $filename"
done

# Close JSON array
echo '' >> "$OUTPUT"
echo ']' >> "$OUTPUT"

# Get file size
size=$(ls -lh "$OUTPUT" | awk '{print $5}')
count=$(grep -c '"id"' "$OUTPUT")

echo "Search index generated: $OUTPUT ($size, $count documents)"
