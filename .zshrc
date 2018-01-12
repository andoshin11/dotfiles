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
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "${fg[yellow]}"
zstyle ':vcs_info:git:*' unstagedstr "${fg[red]}+"
zstyle ':vcs_info:*' formats "${fg[blue]}%c%u(%b)${reset_color}"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

precmd () { vcs_info }

PROMPT='%{$fg[green]%}[%n@%m]%{$reset_color%}'
PROMPT=$PROMPT'${vcs_info_msg_0_} %{${fg[red]}%}%}$%{${reset_color}%} '

RPROMPT="%F{blue}[%~]%f"

# zplug
source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"

zplug load

# load config
source ~/.zsh_alias
