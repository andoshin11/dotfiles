set tabstop=2
set shiftwidth=2
syntax on
set number
set expandtab
set smartindent
set list
set listchars=tab:^\ ,trail:~
inoremap { {}<LEFT>
inoremap ( ()<LEFT>
set cursorline

" enable scroll
set mouse=a

" save backup file in ~/.vim/backup
set backup
set backupdir=$HOME/.vim/backup

" automatically reload file when it is detected to have been changed outside of Vim
set autoread

" display only part of long lines
set nowrap

" set the number of history lines that are remembered
set history=2000

" recover cursor position on opening a file
augroup recover_cursor_position
  autocmd!
  autocmd BufReadPost *
    \ if &filetype != 'gitcommit' && line("'\"") > 1 && line("'\"") <= line('$') |
    \   exe "normal! g`\"" |
    \ endif
augroup END

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/shin/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/Users/shin/.vim/dein')
  call dein#begin('/Users/shin/.vim/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/Users/shin/.vim/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/vimproc.vim', {'build': 'make'})
  call dein#add('Shougo/neomru.vim')

  " You can specify revision/branch/tag.
  call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

"Unite Vim--------------------------------
let g:unite_enable_start_insert=1
nmap <silent> <C-u><C-b> :<C-u>Unite buffer<CR>
nmap <silent> <C-u><C-f> :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nmap <silent> <C-u><C-r> :<C-u>Unite -buffer-name=register register<CR>
nmap <silent> <C-u><C-m> :<C-u>Unite file_mru<CR>
nmap <silent> <C-u><C-u> :<C-u>Unite buffer file_mru<CR>
nmap <silent> <C-u><C-a> :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
au FileType unite nmap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite imap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite nmap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite imap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite nmap <silent> <buffer> <ESC><ESC> q
au FileType unite imap <silent> <buffer> <ESC><ESC> <ESC>q

" Markdown settings
set syntax=markdown
au BufRead,BufNewFile *.md set filetype=markdown


