#!/bin/sh

set -e
set -x

root=$(dirname "$0")/../
mkdir $root/pngtmp/

for f in $(ls $root/app/assets/images/*/*.png); do
  name=(basename $f)
  zopflipng $f $root/pngtmp/$name
  mv $root/pngtmp/$name $f
done

rm -rf $root/pngtmp/
