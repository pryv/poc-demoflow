#!/bin/bash
cd "$(dirname "$0")"
cd ..
if [[ ! -d ./gh-pages ]]; then
    git clone git@github.com:perki/pryv-web-demoflow.git --branch gh-pages --single-branch ./gh-pages
fi
if [[ ! -d ./gh-pages ]]; then
    git clone git@github.com:pryv/app-web-campaign-manager.git --branch app-web-demoflow --single-branch ./app-web-campaign-manager
    cd app-web-campaign-manager
    yarn install
fi