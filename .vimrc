" Color Scheme
set background=dark
colorscheme molokai

" Indentation
set shiftwidth=2
set tabstop=2
set softtabstop=2
set smartindent
set smarttab

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
set esckeys
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

