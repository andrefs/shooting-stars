#!/usr/bin/env bash
# Rename item images to <md5>.jpg so they match the imagePath values
# stored in the shooting-stars-prod MongoDB database.
#
# The API serves /items/images/* from <app>/images (mounted to
# ./data/items/images), and item.imagePath in the DB uses the md5 hash
# of each image's bytes. This script makes the on-disk filenames match.
#
# Usage: scripts/normalize-images.sh [dir]
#   dir defaults to data/items/images (relative to repo root).
#
# Idempotent and dependency-free (uses md5sum).
set -euo pipefail

DIR="${1:-data/items/images}"
cd "$(dirname "$0")/.."

shopt -s nullglob
files=("$DIR"/*.jpg)
if [ ${#files[@]} -eq 0 ]; then
  echo "No .jpg files found in $DIR"
  exit 0
fi

for f in "${files[@]}"; do
  [ -e "$f" ] || continue
  md5=$(md5sum "$f" | cut -d' ' -f1)
  base=$(basename "$f")
  [ "$base" = "$md5.jpg" ] && continue
  mv "$f" "$DIR/$md5.jpg"
done

echo "Normalized images in $DIR"
