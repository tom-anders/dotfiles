#!/usr/bin/env zsh

commit=${1:0:7} #Convert to short form

# Iterate over the branches
git branch -v | tr "*" " " | while read l; do
    #Get hash of this branches commit
    c=$(echo $l | awk '{print $2}') 

    # If the commit matches, checkout the branch
    if [[ $c = $commit ]]; then
        branch=$(echo $l | awk '{print $1}')
        echo "Found matching branch $branch"
        git rebase -Xours $branch
        return 0
    fi
done

# If we didn't find anything, just checkout the commit
git rebase -Xours $commit
