let s:dein_path = expand('~/.vim/dein')

" dein Scripts-----------------------------------------------
if &compatible
	set nocompatible
endif

" Required:
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

" Let dein mange itself
if dein#load_state(s:dein_path)
	" Required:
	call dein#begin(s:dein_path)

	" Add or remove your plugins here:
	call dein#add('Shougo/dein.vim')
	call dein#add('scrooloose/nerdtree')
  call dein#add('Xuyuanp/nerdtree-git-plugin')
	call dein#add('mattn/emmet-vim')
	call dein#add('posva/vim-vue')

	" Required:
	call dein#end()
	call dein#save_state()
endif

" Install uninstalled plugins on startup
if dein#check_install()
	call dein#install()
endif

" Required:
filetype plugin indent on
" End dein Scripts-------------------------------------------

syntax enable

" Configure emmet-vim
" set trigger key
let g:user_emmet_leader_key='<C-e>'

" Configure NERDTree
" set trigger key
map <C-t> :NERDTreeToggle<CR>

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
  exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
  exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction
call NERDTreeHighlightFile('py',     'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('md',     'blue',    'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml',    'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('config', 'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('conf',   'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('json',   'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('html',   'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('styl',   'cyan',    'none', 'cyan',    '#151515')
call NERDTreeHighlightFile('css',    'cyan',    'none', 'cyan',    '#151515')
call NERDTreeHighlightFile('rb',     'Red',     'none', 'red',     '#151515')
call NERDTreeHighlightFile('js',     'Red',     'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php',    'Magenta', 'none', '#ff00ff', '#151515')
call NERDTreeHighlightFile('vue',    'Green',   'none', '#4fc08d', '#4fc08d')

" configure nerdtree-git-plugin
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }

" show hidden files on default
let NERDTreeShowHidden=1

" display line number
set number

" display ^ for tabs, ~ for trailing spaces
set list
set listchars=tab:^\ ,trail:~

" Number of spaces a tab in the file counts for
set tabstop=2

" Number of spaces to use for each step if (auto)indent
set shiftwidth=2
set expandtab

" do smart autoindenting when starting a new line
set smartindent

" recover cursor position on opening a file
augroup recover_cursor_position
  autocmd!
  autocmd BufReadPost *
    \ if &filetype != 'gitcommit' && line("'\"") > 1 && line("'\"") <= line('$') |
    \   exe "normal! g`\"" |
    \ endif
augroup END

" Don't highlight paren
let loaded_matchparen=1

" autohighlight vue file
autocmd FileType vue syntax sync fromstart

" autofill paren
inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap ( ()<Left>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
inoremap <? <??><Left><Left><Space><Left>
