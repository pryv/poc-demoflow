#!/bin/bash
cd "$(dirname "$0")"
cd ..
if [[ ! -d ./gh-pages ]]; then
    git clone git@github.com:pryv/poc-demoflow.git --branch gh-pages --single-branch ./gh-pages
fi
