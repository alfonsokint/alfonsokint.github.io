#!/usr/bin/env bash
set -euo pipefail

# Optimize the top N largest images (jpg/jpeg/png) under images/
# Usage: ./scripts/optimize_top_images.sh [N]
# Default N=5

TOP_N=${1:-5}
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "Finding top $TOP_N largest jpg/png images under images/"
mapfile -t files < <(find images -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -printf '%s\t%p\n' 2>/dev/null | sort -rn | head -n "$TOP_N" | cut -f2-)

if [ ${#files[@]} -eq 0 ]; then
  echo "No images found under images/"
  exit 0
fi

echo "Will optimize the following files:" 
printf '%s
' "${files[@]}"

for f in "${files[@]}"; do
  # Remove leading/trailing whitespace
  f=$(echo "$f" | sed -e 's/^\s\+//' -e 's/\s\+$//')
  if [ ! -f "$f" ]; then
    echo "Skipping missing file: $f"
    continue
  fi
  ext="${f##*.}"
  ext_lc=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
  echo "Processing: $f"
  # backup if no existing .bak
  if [ ! -f "${f}.bak" ]; then
    cp -p "$f" "${f}.bak" || true
  fi
  if [[ "$ext_lc" == "jpg" || "$ext_lc" == "jpeg" ]]; then
    # jpegoptim: strip metadata, set max quality 85 (near-lossless)
    if command -v jpegoptim >/dev/null 2>&1; then
      jpegoptim --strip-all --max=85 "$f" || echo "jpegoptim failed for $f"
    else
      echo "jpegoptim not found; skipping $f"
    fi
  elif [[ "$ext_lc" == "png" ]]; then
    if command -v pngquant >/dev/null 2>&1; then
      # pngquant writes to stdout or to output file; use --output to overwrite
      tmpfile="${f}.pngquant.tmp"
      pngquant --quality=65-90 --strip --force --output "$tmpfile" -- "$f" || { echo "pngquant failed for $f"; rm -f "$tmpfile"; continue; }
      mv "$tmpfile" "$f"
    else
      echo "pngquant not found; skipping $f"
    fi
  else
    echo "Unsupported extension for file: $f"
  fi
done

echo "Optimization complete. Backups created with .bak suffix next to each optimized file."
