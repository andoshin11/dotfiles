# Quick Start

Execute command below to make magic happen!

```shell
$ curl -L raw.github.com/andoshin11/dotfiles/master/install.sh | bash
```

# Keep in mind :warning:
These scripts are not tested to work on every platforms therefore *very* have high possibility to cause serious damage to your machine.

I strongly recommend to fork and personalize scripts before you actually run them on your machines.


# What's happening?

`install.sh` will clone or download this repository whichever platform you are on.

## Initialization
Triggered by `make init` command, all the scripts under `./script` will be executed for the purpose of initialization.

- Installing Homebrew :beer:
- Setup fish shell :fish:
- Install powerline font and fish theme
- Download apps :apple:
- Setup dein.vim
- Setup Node environment
- Setup Go environment
- Setup VSCode


## Deployement
Triggered by `make deploy` command, symbolic links are made for all the dotfiles.

- .gitconfig
- .tmux.conf
- .vimrc
- .zshrc

