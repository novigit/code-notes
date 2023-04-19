#!/bin/bash

```sh
# check the changes in a particular commit
git show HEAD
git show 081870e

# change the commit message of the last commit, if you haven't pushed it to the remote yet
git commit --amend -m "new commit message"

# show git diff with colors in less
git diff --color=always <file> | less -R
```

