#!/bin/bash
cd "$(dirname "$0")"
cd ..
if [[ ! -d ./gh-pages ]]; then
    git clone git@github.com:perki/pryv-web-demoflow.git --branch gh-pages --single-branch ./gh-pages
fi
