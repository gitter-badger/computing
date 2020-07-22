# Private Development of Course Material

## Initial Setup

For course material development, some content such as homework solutions need to be kept private (at least temporarily). This note explains how two repositories can be used in concert to simplify private development of public course content.

The material on [this posting](https://github.community/t5/How-to-use-Git-and-GitHub/Project-setup-question-with-public-and-private-quot-branches/m-p/26789/highlight/true#M7600) has been adapted for my purposes.

### Two Remote Repositories: Public and Private 

Suppose you have two Github repositories:
* Public repo is at `https://github.com/username/public-repo.git`
* Private repo is at `https://github.com/username/private-repo.git`

The public repo will be open to the students, whereas the private repo will be used for development and testing (shared with TAs etc.)

### Local Repository with Public and Private Remotes

Create a local repository and set target repositories

```bash
mkdir ~/local-repo && cd ~/local-repo
git init
git remote add public https://github.com/username/public-repo.git
git remote add private https://github.com/username/private-repo.git
```

Add first public file in `master` branch and push to `public-repo`:

```bash
# cd ~/local-repo && git checkout master

echo "README" >> README.md
git add README.md
git commit -m"first commit"

git push public master
git push private master
```
Now, `public-repo/master` and `private-repo/master` on Github are identical.

Create a local development branch: `private-branch`  

```bash
# cd ~/local-repo && git checkout master
git checkout -b private-branch

echo "handout" > homework1-handout.md
echo "solutions" > homework1-solution.md
git add homework1-handout.md homework1-solution.md 
git commit -m"private development"

git push -u private private-branch
```
Here `private-branch` branch syncs with `private-repo/private-branch` (remote branch name defaults to `private-branch`)






## Publishing content to public repository

**Do not `merge` but `checkout`** relevant files into `public-repo/master`:

```bash
# cd ~/public-repo && git checkout master

git checkout private-branch homework1-handout.md
git add homework1-handout.md
git commit -m"release homework1"
git push
```
Note the line `git checkout private-branch homework1-handout.md` overwrites (or creates) `homework1-handout.md` in `public-repo/master`.

### Using different remote vs. local branch names (Optional) 

A local branch (you would like to keep private) can have any name. For example, create a local branch named `new-branch` to sync with `private-repo/private-branch`:

```bash
# cd ~/public-repo && git checkout master

git checkout --orphan new-branch
git pull private private-branch
# make some changes
git push private new-branch:private-branch
```
Any changes in `new-branch` branch will now push to `private-repo/private-branch`.

_Note: upstream tracking doesn't seem to stick with '-u'._

### Setting default `push` behavior (Optional) 

To me, the default behaviors of `git pull` and `git push` are strange. I kept on using `git push [remote] [branch]` above because even setting upstream with `-u` does not behave as I expect it to.

However, configuring [`git config push.default upstream`](https://git-scm.com/docs/git-config#Documentation/git-config.txt-pushdefault) seems much more intuitive to me.

Also, forcing checkout seems to simplify the process of cloning `private/feature` to a new local branch and sets the upstream:

```bash
git config push.default upstream --local
git checkout -f -b new-branch private/feature
echo "fix problems" >> homework1-handout.md
git add -u
git commit -m"fix homework1-handout"
git push -v
```
Above will push our local `new-branch` to `private/feature` branch.








## Duplicating Dual Remote Setup

Clone public repository and add private repository as remote:

```bash
git clone https://github.com/username/public-repo.git ~/public-repo
cd ~/public-repo

# set local master branch to track public master branch
git remote rm origin # to explicitly differentiate public vs private repos
git remote add public https://github.com/username/public-repo.git
git push -u public master 
```

Sync a local `private-branch` with `private-repo/private-branch`:

```bash
# cd ~/public-repo && git checkout master

git checkout --orphan private-branch 

git remote add private https://github.com/username/private-repo.git
git pull private private-branch

echo "add solutions" >> homework1-solution.md
git add -u
git commit -m"modify homework 1 solution"

git push -u private private-branch
```

Check pushing is setup properly with a dry run: `git push -n -v`


## Adding Branches

If multiple people are working on this repository, multiple branches need to be created.
To create additional branches to the private repository, simply create a branch from `private-branch`:

```bash
# cd ~/public-repo && git checkout private-branch

git checkout -b new-private-branch
echo "newfile" > newfile.txt
git add newfile.txt
git commit -m'adding a new file'

git remote add private new-private-branch
git push --set-upstream private new-private-branch
```

