#!/bin/bash

# Build script for creating a DEB package for immersionpod

set -euo pipefail

PACKAGE_NAME="immersionpod"
VERSION=${VERSION:?Version is not set.}
VERSION=${VERSION##v}
PACKAGE_DIR="deb_package"
OUTPUT_FILE="${PACKAGE_NAME}.deb"

ROOT_DIR=$(git rev-parse --show-toplevel)
cd -- "$ROOT_DIR" || exit 1

# Clean up previous build
rm -rf -- "$PACKAGE_DIR" "$OUTPUT_FILE"

# Create package directory structure
mkdir -p -- "$PACKAGE_DIR/DEBIAN"
mkdir -p -- "$PACKAGE_DIR/usr/bin"
mkdir -p -- "$PACKAGE_DIR/usr/share/doc/$PACKAGE_NAME"
mkdir -p -- "$PACKAGE_DIR/usr/share/licenses/$PACKAGE_NAME"

# Create control file
cat > "$PACKAGE_DIR/DEBIAN/control" << EOF
Package: $PACKAGE_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: all
Maintainer: Ajatt-Tools and contributors <tatsu@autistici.org>
Depends: bash, file, gawk, ffmpeg, mpd, xdg-user-dirs
Recommends: mpc, libnotify-bin, yt-dlp
Description: AJATT-style passive listening and condensed audio without bloat.
 Immersion pod is a tool for managing passive immersion. It converts
 foreign language movies and TV shows to audio and uses it for passive
 listening. It supports condensed audio and creates it by default
 if it finds subtitles in the container or externally.
Homepage: https://ajatt.top
License: GPL-3.0
EOF

# Copy files to package directory
cp -- impd "$PACKAGE_DIR/usr/bin/"
cp -- README.md "$PACKAGE_DIR/usr/share/doc/$PACKAGE_NAME/"
cp -- LICENSE "$PACKAGE_DIR/usr/share/licenses/$PACKAGE_NAME/"

# Build the DEB package
dpkg-deb --build "$PACKAGE_DIR" "$OUTPUT_FILE"

echo "DEB package created: $OUTPUT_FILE"

# Show package info
echo "Package info:"
dpkg-deb --info "$OUTPUT_FILE"
