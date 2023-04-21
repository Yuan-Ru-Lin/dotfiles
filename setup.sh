#!/bin/bash

for f in $(git ls-tree -r HEAD --name-only); do
    if [[ $f == .* ]]; then
        if [[ -f $HOME/$f ]]; then
            rm $HOME/$f;
        fi
        ln $f $HOME/$f;
    fi;
done

if [ ! -d $HOME/.julia/config ]; then mkdir -p $HOME/.julia/config; fi
ln startup.jl $HOME/.julia/config/startup.jl
if [ ! -d $HOME/.config/nvim ]; then mkdir -p $HOME/.config/nvim; fi
ln init.vim $HOME/.config/nvim/init.vim
