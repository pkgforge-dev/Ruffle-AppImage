#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/ruffle-rs/ruffle/fcdfc1cb8fce14e821dd63ead25c60809a120050/desktop/packages/linux/rs.ruffle.Ruffle.svg
export DESKTOP=https://raw.githubusercontent.com/ruffle-rs/ruffle/refs/heads/master/desktop/packages/linux/rs.ruffle.Ruffle.desktop
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1

# Deploy dependencies
quick-sharun ./AppDir/bin/ruffle

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
