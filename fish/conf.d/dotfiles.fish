# Common fish config managed by dotfiles (symlinked into ~/.config/fish/conf.d/).
# Machine-local settings and secrets belong in ~/.config/fish/config.fish, which is not tracked.

# Homebrew
/opt/homebrew/bin/brew shellenv fish | source

# PATH (--global: do not persist into universal fish_user_paths)
fish_add_path --global $HOME/.local/bin # Claude Code native installer
fish_add_path --global $HOME/.nodebrew/current/bin
fish_add_path --global $HOME/go/bin
fish_add_path --global $HOME/.yarn/bin # `yarn global add` binaries
# tfenv's terraform is linked into /opt/homebrew/bin, so no extra PATH is needed

# pyenv (adds ~/.pyenv/shims to PATH)
pyenv init - fish | source

# env
set -gx KUBECONFIG $HOME/.kube/config

# alias
alias gs 'git status'
alias gb 'git branch'
alias ga 'git add .'
alias gc 'git branch | fzf | xargs git checkout'
alias gt "git log --graph --pretty='format:%C(yellow)%h%Creset %s %Cgreen(%an)%Creset %Cred%d%Creset'"
alias gbm 'git branch --merged'
alias gbmd 'git branch --merged | grep -vE "^\\*|^ +(main|master|develop)\$" | xargs -n 1 git branch -d'
alias wttr 'curl wttr.in/tokyo'
alias dr 'docker rm (docker ps -aq)'
alias dri 'docker rmi (docker images -f "dangling=true" -q)'
alias kbb 'kubectl run busybox --restart=Never -it --image=busybox --rm /bin/sh'

# exec ls after cd
function cd
    builtin cd $argv
    and ls -a
end

# completion
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
