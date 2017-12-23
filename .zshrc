# enable Emacs key bind
bindkey -e

# enable colors
autoload -Uz colors; colors

# change directory without cd
setopt auto_cd

# list files when changes directory
function chpwd() {
  if [ `ls -Al | wc -l` -eq 0 ]; then
    echo "\n\nempty directory";
  else
    ls
  fi
}

# prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'

function precmd() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

PROMPT="%(?.%F{green}%}.%F{magenta})%n@%m%f $ "

RPROMPT="%F{cyan}[%~]%f %1(v|%F{green}%1v%f|)"

# zplug
source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"

zplug load
