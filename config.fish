# alias
alias gs 'git status'
alias gb 'git branch'
alias ga 'git add .'
alias gc 'git branch | fzf | xargs git checkout'
alias wttr 'curl wttr.in/tokyo'
alias gt "git log --graph --pretty='format:%C(yellow)%h%Creset %s %Cgreen(%an)%Creset %Cred%d%Creset'"
alias gbm 'git branch --merged'
alias dm 'diesel migration'

# exec ls after cd
function cd
  builtin cd $argv
  ls -a
end

# env
set -x PATH $HOME/.nodebrew/current/bin $PATH
set -x GOENV_DISABLE_GOPATH 1
set -x GOPATH $HOME/dev/go
set -x PATH $GOPATH/bin $PATH
set -x PATH $HOME/.goenv/bin $PATH
set -x PATH $HOME/.cargo/bin $PATH
set -x PATH /usr/local/Cellar/postgresql/11.4/bin $PATH
set -x PATH $HOME/.pyenv/bin $PATH

status --is-interactive; and source (goenv init -|psub)

