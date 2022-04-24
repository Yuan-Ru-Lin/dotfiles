#!/bin/bash

for f in $(git ls-tree -r HEAD --name-only); do
  ln $f $HOME/$f;
done
