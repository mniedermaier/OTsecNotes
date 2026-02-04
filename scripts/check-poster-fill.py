#!/usr/bin/env python3
"""Check poster PDF content fill percentage.

Renders the poster to grayscale, then counts how many rows in the
content area (excluding header/footer) have visible content.
Reports the fill percentage and exits non-zero if below threshold.

Usage:
    check-poster-fill.py <poster.pdf> [min-fill-pct]
    check-poster-fill.py --all <pdf-directory> [min-fill-pct]
"""

import sys
import os
import subprocess
import tempfile


def check_fill(pdf_path):
    """Render PDF to grayscale PGM and measure content area fill."""
    with tempfile.TemporaryDirectory() as tmpdir:
        base = os.path.join(tmpdir, "page")
        result = subprocess.run(
            ["pdftoppm", "-gray", "-r", "72", "-f", "1", "-l", "1", pdf_path, base],
            capture_output=True,
        )
        if result.returncode != 0:
            return None, "pdftoppm failed: " + result.stderr.decode()

        # Find the output PGM file
        pgm_file = None
        for f in os.listdir(tmpdir):
            if f.endswith(".pgm"):
                pgm_file = os.path.join(tmpdir, f)
                break

        if not pgm_file:
            return None, "Could not render PDF to PGM"

        with open(pgm_file, "rb") as f:
            # Read PGM P5 header
            magic = f.readline().strip()
            if magic != b"P5":
                return None, "Unexpected PGM format: " + magic.decode()

            # Skip comments
            line = f.readline().strip()
            while line.startswith(b"#"):
                line = f.readline().strip()

            width, height = map(int, line.split())
            maxval = int(f.readline().strip())

            # Read pixel data
            data = f.read()

        # Define content area (skip header bar and footer bar)
        # Header: ~2.8cm top margin + 1.8cm header bar = ~4.6cm
        # Footer: ~1.5cm bottom margin + 0.9cm footer bar = ~2.4cm
        # A4 height = 29.7cm, so content spans ~22.3cm / 29.7cm = ~75%
        # Content starts at ~15.5% from top, ends at ~92% from top
        content_start = int(height * 0.155)
        content_end = int(height * 0.92)
        content_height = content_end - content_start

        if content_height <= 0:
            return None, "Invalid content area dimensions"

        # Count rows that have at least one dark pixel (content)
        threshold = int(maxval * 0.92)  # Pixel must be darker than 92% of white
        rows_with_content = 0

        for row in range(content_start, content_end):
            row_start = row * width
            row_end = row_start + width
            row_data = data[row_start:row_end]

            if any(b < threshold for b in row_data):
                rows_with_content += 1

        fill_pct = (rows_with_content / content_height) * 100
        return fill_pct, None


def main():
    if len(sys.argv) < 2:
        print("Usage: check-poster-fill.py <poster.pdf> [min-fill-pct]")
        print("       check-poster-fill.py --all <pdf-directory> [min-fill-pct]")
        sys.exit(1)

    # Check all posters in a directory
    if sys.argv[1] == "--all":
        if len(sys.argv) < 3:
            print("Usage: check-poster-fill.py --all <pdf-directory> [min-fill-pct]")
            sys.exit(1)
        pdf_dir = sys.argv[2]
        min_fill = int(sys.argv[3]) if len(sys.argv) > 3 else 85
        failed = 0
        checked = 0

        for f in sorted(os.listdir(pdf_dir)):
            if f.endswith("-poster.pdf"):
                pdf_path = os.path.join(pdf_dir, f)
                fill, err = check_fill(pdf_path)
                checked += 1
                if err:
                    print(f"  ERROR: {f}: {err}")
                    failed += 1
                elif fill >= min_fill:
                    print(f"  OK: {f} ({fill:.0f}% filled)")
                else:
                    print(f"  WARN: {f} ({fill:.0f}% filled, below {min_fill}%)")
                    failed += 1

        if checked == 0:
            print("No poster PDFs found.")
        elif failed > 0:
            print(f"{failed}/{checked} poster(s) below {min_fill}% fill threshold.")
            sys.exit(1)
        else:
            print(f"All {checked} poster(s) pass fill check (>= {min_fill}%).")
        sys.exit(0)

    # Check single poster
    pdf_path = sys.argv[1]
    min_fill = int(sys.argv[2]) if len(sys.argv) > 2 else 85

    fill, err = check_fill(pdf_path)
    name = os.path.basename(pdf_path)

    if err:
        print(f"ERROR: {name}: {err}")
        sys.exit(2)

    if fill >= min_fill:
        print(f"OK: {name}: {fill:.0f}% filled (min {min_fill}%)")
        sys.exit(0)
    else:
        print(f"WARN: {name}: {fill:.0f}% filled (below {min_fill}% minimum)")
        sys.exit(1)


if __name__ == "__main__":
    main()
