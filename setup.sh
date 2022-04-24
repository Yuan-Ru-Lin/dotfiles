#!/bin/bash

for f in $(git ls-tree -r HEAD --name-only); do
    if [[ $f == .* ]]; then
        ln $f $HOME/$f;
    fi;
done
