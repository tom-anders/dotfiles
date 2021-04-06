#!/usr/bin/env bash

fullPath=$(echo $1 | awk '{print $2}')
echo $(realpath --relative-to $(git rev-parse --show-toplevel) $fullPath)
~/.vim/plugged/fzf.vim/bin/preview.sh $fullPath
