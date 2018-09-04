#!/bin/bash
cd "$(dirname "$0")"
cd ../app-web-campaign-manager
node build/build.js
cp -r dist/* ../gh-pages/cm


