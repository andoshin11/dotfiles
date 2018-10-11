# alias
alias gs 'git status'
alias gb 'git branch'
alias ga 'git add .'

# exec ls after cd
function cd
  builtin cd $argv
  ls -a
end
