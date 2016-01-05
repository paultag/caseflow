#!/bin/sh

set -e
set -x

if ! which zopflipng > /dev/null; then
  echo "You should install zopflipng (brew install zopfli, apt-get install zopfli)" >&2
  exit 1
fi

root=$(dirname "$(dirname "$0")")
mkdir "$root/pngtmp/"

for f in $root/app/assets/images/*/*.png; do
  name=$(basename "$f")
  zopflipng "$f" "$root/pngtmp/$name"
  mv "$root/pngtmp/$name" "$f"
done

rm -rf "$root/pngtmp"
