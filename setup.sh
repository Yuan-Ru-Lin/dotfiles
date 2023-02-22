#!/bin/bash

for f in $(git ls-tree -r HEAD --name-only); do
    if [[ $f == .* ]]; then
        rm $HOME/$f;
        ln $f $HOME/$f;
    fi;
done

ln startup.jl $HOME/.julia/config/startup.jl
