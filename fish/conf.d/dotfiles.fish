# Common fish config managed by dotfiles (symlinked into ~/.config/fish/conf.d/).
# Machine-local settings and secrets belong in ~/.config/fish/config.fish, which is not tracked.

# Homebrew
/opt/homebrew/bin/brew shellenv fish | source

# PATH (--global: do not persist into universal fish_user_paths)
fish_add_path --global $HOME/.local/bin # Claude Code native installer
fish_add_path --global $HOME/.nodebrew/current/bin
fish_add_path --global $HOME/go/bin
fish_add_path --global $HOME/.yarn/bin # `yarn global add` binaries
fish_add_path --global /opt/homebrew/share/google-cloud-sdk/bin # extra gcloud components

# env
set -gx KUBECONFIG $HOME/.kube/config
set -gx LANGUAGE ja
set -gx TIMEZONE Asia/Tokyo
set -gx TFENV_CONFIG_DIR $HOME/.tfenv # keep Terraform versions outside the Homebrew Cellar

# 1Password service account (server): pass the token to `op` only, not to every process
if test -f $HOME/.config/op/service-account-token
    function op
        OP_SERVICE_ACCOUNT_TOKEN=(cat $HOME/.config/op/service-account-token) command op $argv
    end
end

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
