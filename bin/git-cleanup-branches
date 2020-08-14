#!/bin/sh

# from https://github.com/maxjacobson/dotfiles/blob/6d1124eca7d3b097ac244c1d14d607fea1c3dd2a/bin/git-cleanup-branches
# see https://www.hardscrabble.net/2018/git-cleanup-branches/

set -euo pipefail

file="/tmp/git-cleanup-branches-$(uuidgen)"

function removeCurrentBranch {
  sed -E '/\*/d'
}

function leftTrim {
  sed -E 's/\*?[[:space:]]+//'
}


all_branches=$(git branch | removeCurrentBranch | leftTrim)

# write branches to file
for branch in $all_branches; do
  echo "keep $branch" >> $file
done

# write instructions to file
echo "

# All of your branches are listed above
# (except for the current branch, which you can't delete)
# change keep to d to delete the branch
# all other lines are ignored" >> $file

# prompt user to edit file
$EDITOR "$file"

# check each line of the file
cat $file | while read -r line; do

  # if the line starts with "d "
  if echo $line | grep --extended-regexp "^d "; then
    # delete the branch
    branch=$(echo $line | sed -E 's/^d //')

    git branch -D $branch
  fi
done

# clean up
rm $file
