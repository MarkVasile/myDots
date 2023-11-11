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

## My toolset

For X I'm using [Hyprland](https://hyprland.org/), with a very simple configuration (for now), while I"m learning about it. I'm trying to stay as much as possible in the Wayland realm, but for apps that are not yet ported to Wayland I of course have to use Xwayland. I keep an eye on which apps use XWayland, from time to time, using `xlsclients`.

I use [alacritty](https://github.com/alacritty/alacritty) for my terminal, with [alacritty-themes](https://github.com/rajasegar/alacritty-themes) to change the mood every now and then. If you prefer to start the terminal directly in tmux, you can uncomment the `-e tmux` in the `hyprland.conf` file.

You may notice I also have an Apple magic keyboard plugged in to my (PC) linux box, because it's the most efficient way to keep my finger reflexes intact while switching from laptop to PC every day. With one difference, unlike the macbook laptop, on the PC I've installed [KMonad]([KMonad](https://github.com/kmonad/kmonad)) to have some fun with keyboard layers, but at the moment all I've done with it is change the CAPS LOCK to CTRL. One day...

My always-on apps are:

- [Spacemacs](https://www.spacemacs.org/), with a wayland version of emacs, rather than the default one
- [Firefox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/) for web development, videos, and fancy websites.
- [Qutebrowser](https://qutebrowser.org/) for research and general browsing. I fell in love with cutebrowser thanks to its keyboard shortcuts for everything you might dream of doing in a browser.

