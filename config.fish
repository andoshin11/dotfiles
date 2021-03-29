# alias
alias gs 'git status'
alias gb 'git branch'
alias ga 'git add .'
alias gc 'git branch | fzf | xargs git checkout'
alias wttr 'curl wttr.in/tokyo'
alias gt "git log --graph --pretty='format:%C(yellow)%h%Creset %s %Cgreen(%an)%Creset %Cred%d%Creset'"
alias gbm 'git branch --merged'
alias dm 'diesel migration'
alias dr 'docker rm (docker ps -aq)'
alias dri 'docker rmi (docker images -f "dangling=true" -q)'
alias goland '/usr/local/bin/goland'
alias kbb 'kubectl run busybox --restart=Never -it --image=busybox --rm /bin/sh'

# exec ls after cd
function cd
  builtin cd $argv
  ls -a
end

# env
set -x KUBECONFIG $HOME/.kube/config
set -x PATH $HOME/.nodebrew/current/bin $PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f $HOME/google-cloud-sdk/path.fish.inc ]; . $HOME/google-cloud-sdk/path.fish.inc; end
