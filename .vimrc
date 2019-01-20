set encoding=utf-8

" Color Scheme
set background=dark
colorscheme molokai

" Indentation
filetype plugin indent on
set shiftwidth=2
set tabstop=2
set softtabstop=2
set smartindent
set smarttab
set expandtab

" moving
set nocompatible
" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" searching
set hlsearch
set ignorecase
set smartcase
set incsearch
set showmatch
set magic
set gdefault

" UI stuff
syntax on
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
set laststatus=2
set mouse=a
set noerrorbells
set nostartofline
set ruler
set number
set cursorline
set shortmess=atI
set showmode
set title
set showcmd
set scrolloff=3
set clipboard=unnamed
set wildmenu
set backspace=indent,eol,start
set ttyfast
set encoding=utf-8 nobomb
set binary
set noeol

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

call plug#begin('~/.vim/plugged')

Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-sleuth'

Plug 'ctrlpvim/ctrlp.vim'
Plug 'imkmf/ctrlp-branches'
Plug 'hara/ctrlp-colorscheme'

Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue'] }

call plug#end()

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

map <C-n> :NERDTreeToggle<CR>

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
let g:ctrlp_show_hidden = 1


let g:ycm_key_list_stop_completion = ['<CR>']

function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd FileType sh,python,c,java,javascript  :call <SID>StripTrailingWhitespaces()

nmap <C-_> <leader>c<Space>
vmap <C-_> <leader>c<Space>


