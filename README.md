# Quick Start

Run the command below to make magic happen! :heart_eyes::sparkles:

```shell
$ xcode-select --install
$ curl -fsSL https://raw.githubusercontent.com/andoshin11/dotfiles/master/install.sh | ROLE=server bash
```

`ROLE` is required:

- `client`: a laptop you sit in front of. SSH keys come from the 1Password SSH agent.
- `server`: an always-on machine (Mac mini) operated remotely. Uses a dedicated passphrase-less key for GitHub so nothing waits for interactive approval.

# Keep in mind :warning:
These scripts are not tested to work on every platforms, therefore contain **very** high possibility to cause serious damage to your machine. :computer:

I strongly recommend to fork and personalize scripts before you actually run them on your machines.


# What's happening?

`install.sh` will clone or download this repository whichever platform you are on.

## Initialization
Triggered by `make init` command, all the scripts under `./script` will be executed for the purpose of initialization.

- Copy `etc/ssh/config.$ROLE` to `~/.ssh/config` as an initial template (skipped if it already exists; add machine-local hosts there directly); on `server`, generate a dedicated GitHub key :key:
- Installing Homebrew :beer:
- Setup fish shell :fish:
- Install powerline font and fish theme :art:
- Download apps :apple:
- Setup dein.vim :pencil2:
- Setup Node environment :earth_asia:
- Setup Go environment :muscle:
- Setup VSCode :pencil:
- Setup Google Cloud SDK :cloud:


## Deployement
Triggered by `make deploy` command, symbolic links are made for all the dotfiles.

- .gitconfig
- .tmux.conf
- .vimrc
- .zshrc

# Contact
Shin Ando (andoshin11)

<shinglish11@gmail.com>

