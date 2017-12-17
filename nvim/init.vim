let s:dein_path = expand('~/.vim/dein')

if &compatible
  set nocompatible
endif

set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state(s:dein_path)
  call dein#begin(s:dein_path)

  call dein#add('Shougo/dein.vim')

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on

syntax enable
