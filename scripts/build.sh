#!/usr/bin/env bash
set -x

for f in ./*; do
    if [ -d "$f" ]; then
        url=$(cat ./${f}/package.yaml | yq r - base)
        mkdir -p $f/charts/
        curl -sLf ${url} | tar xvzf - -C $f/charts/ --strip 1
    fi
done


