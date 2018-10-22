# alias
alias gs 'git status'
alias gb 'git branch'
alias ga 'git add .'
alias wttr 'curl wttr.in/tokyo'
alias gt "git log --graph --pretty='format:%C(yellow)%h%Creset %s %Cgreen(%an)%Creset %Cred%d%Creset'"

# exec ls after cd
function cd
  builtin cd $argv
  ls -a
end

# env
set -x PATH $HOME/.nodebrew/current/bin $PATH
set -x GOPATH $HOME/dev/go
set -x PATH $GOPATH/bin $PATH
