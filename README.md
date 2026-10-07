# Quick Start

Run the command below to make magic happen! :heart_eyes::sparkles:

```shell
$ xcode-select --install
$ curl -fsSL https://raw.githubusercontent.com/andoshin11/dotfiles/master/install.sh | ROLE=server bash
```

`ROLE` is required:

- `client`: a laptop you sit in front of. SSH keys come from the 1Password SSH agent.
- `server`: an always-on machine (Mac mini) operated remotely. Uses a dedicated passphrase-less key for GitHub so nothing waits for interactive approval.

# Manual steps after install :hand:

These steps cannot be scripted. Do them once after `install.sh` finishes.

## SSH (`client`)

1. Open 1Password, sign in, and enable the SSH agent in **Settings > Developer**.
2. (Optional) To reduce approval prompts, set **Settings > Developer > Remember key approval** to a fixed time (4/12/24 hours) and **Ask approval for each new** to *For each new application*.
3. Verify:
   ```shell
   $ ssh -T git@github.com
   ```

## SSH (`server`)

1. Register the generated public key on GitHub (**Settings > SSH and GPG keys > New SSH key**). Use a title that identifies this machine (e.g. `mac-mini-server`) so it can be revoked on its own.
   ```shell
   $ cat ~/.ssh/id_ed25519_github.pub
   ```
2. Verify:
   ```shell
   $ ssh -T git@github.com
   ```

The key has no passphrase so unattended jobs never block. If the machine is lost or compromised, revoke this key on GitHub immediately.

## SSH (both roles)

- `~/.ssh/config` is copied from `etc/ssh/config.$ROLE` only when it does not exist. Machine-local hosts (work bastions etc.) go directly in `~/.ssh/config`, never in this repo.
- If the file already existed, install skips it. Compare with the template and merge by hand:
  ```shell
  $ diff etc/ssh/config.$ROLE ~/.ssh/config
  ```

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

