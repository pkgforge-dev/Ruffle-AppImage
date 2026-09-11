#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package ruffle-nightly-bin

# If the application needs to be manually built that has to be done down here

echo "Getting app..."
echo "---------------------------------------------------------------"
LINK=$(wget https://api.github.com/repos/ruffle-rs/ruffle/releases -O - \
      | sed 's/[()",{} ]/\n/g' | grep -o -m 1 "https.*linux-${ARCH}.tar.gz")
echo "$LINK" | awk -F'/' '{v=$(NF-1); sub(/nightly-/, "", v); print v; exit}' > ~/version
if ! wget --retry-connrefused --tries=30 "$LINK" -O /tmp/app.tar.gz 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi

mkdir -p ./AppDir/bin
tar -xvf /tmp/app.tar.gz
mv -v ./ruffle ./AppDir/bin
