GIT

GIT is a decentralized versioning system.

```sh
# check the changes in a particular commit
git show HEAD
git show 081870e

# change the commit message of the last commit, if you haven't pushed it to the remote yet
git commit --amend -m "new commit message"

# show git diff with colors in less
git diff --color=always <file> | less -R

# show the git diff of the same file in different branches
# while in 'main'
git diff <other_branch> <path/to/file>

# undo an accidental git add
git reset <FILE>
```

#### Branch Management
```sh
# show the local branches and which branch you are on
git branch -v

# create new branch with <branchname>
git branch <branchname>

# create a new branch and immediately checkout to it
git checkout -b <branchname>

# delete <branch>
git branch -d <branch>
```

#### Setting up your GitHub SSH-key
```
# generate a private/public key pair
ssh-keygen -t ed25519 -C "joranmartyn@gmail.com"

# save as '~/.ssh/github_ed25519'

# nevermind a passphrase

# edit your '~/.ssh/config'
Host github.com
    IdentityFile ~/.ssh/github_ed25519
    HostName github.com

# now copy the exact contents of '~/.ssh/github_ed25519.pub'
# (the public key) onto your GitHub account

# Settings -> SSH and GPG keys -> New SSH key -> Add a title -> Paste the public key -> Add SSH key

# in your known_hosts, make sure you have
github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
```



```sh
git init					Initiate a local git repository
git config --global user.name "Joran Martijn"
git config --global user.email joran.martijn@icm.uu.se
git config -l					Some general configuration information of account and repository
git clone https://github.com/novigit/brocode	"Clone" the repository to current directory
git status					Check what has been changed since last update
git add <file|dir> <file|dir> <etc>		"Stage" files for commit, or "add" files to the "staging area", where files are tracked
git add .					Adds all changed files for commit
git diff <file>					Check the changes of a file, between when it was added and now
git commit -m "commit message"			"Commit" the files to your repository
git commit -a -m "commit message"		Will automatically add all tracked files with changes. Will not add untracked files
git log	 					Check your commit log
git show HEAD					Show all changes in the last commit, and the commit details (SHA etc)
git remote -v					Lists remote repositories
git checkout <branch>				Change to a specific branch
git checkout HEAD <file>			Restore <file> to state it was in before last commit. In the working directory
git reset HEAD <file>				Restore staged <file> to state it was in, in the last commit, and remove it from staging area. In the staging area
git reset <commit_SHA>				Restore repository to state it was in, after <commit_SHA>
git push origin master				"Push" changes into repository
git fetch origin master				Downloads the latest master branch to the branch origin/master
git pull origin master				Fetch ánd merge the current master branch with your local copy
git merge <branch>				Merge <branch> with branch you are currently on
git --version					Shows current version of git
```
