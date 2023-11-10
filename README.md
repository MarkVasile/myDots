# myDots
my linux dot files

## To create your own

First run the `setupMyDots.sh` in your terminal. The script sets up a bare git repo in `~/.mydots` and an alias command `config` which you can then use in your home folder exactly as you would use it in a git repository. For example:

`config status`

`config add .vimrc`

`config commit -m 'vimrc updated.'`

`config remote add origin git@github.com:<YourAccount>/myDots.git`

`config push -u origin main`

## To install your dot files onto a new system

First create the alias again, by hand:

`alias config='/usr/bin/git --git-dir=$HOME/.mydots --work-tree=$HOME'`

Then add a gitignore file to avoid an infinite recursive git:

`echo '.mydots' >> .gitignore`

And remove the existing `.bashrc` and other dot files (maybe back them up if you prefer).

Then you're ready to clone the repo and setup your new system:

```
git clone --bare git@github.com:<YourAccount>/myDots.git $Home/.mydots
config checkout
```

You'll need to instruct the local repo again to not track all files:

`config config --local status.showUntrackedFiles no`
