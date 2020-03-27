syntax on
set background=dark
set grepprg=grep\ -nH\ $*
color dracula

filetype plugin indent on

" keyboard mappings for tabs
nnoremap th  :tabfirst<CR>
nnoremap tk  :tabnext<CR>
nnoremap tj  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<CR>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>

" <Ctrl-l> redraws the screen and removes any search highlighting
nnoremap <silent> <C-l> :nohl<CR><C-l>

" show custom status line 
set laststatus=2

" indent lines/code blocks in visual mode using < and > 
vnoremap < <gv
vnoremap > >gv

" disable swap and backup files
set nobackup
set nowritebackup
set noswapfile

" tab completion in command mode
set wildmenu
set showcmd

" search settings
set ignorecase
set smartcase
set incsearch
set hlsearch

" tab/spaces settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab
set smarttab
set nolist

" margins
set wrap
set wrapmargin=0
set linebreak
set textwidth=0

set nu
set numberwidth=2

" cursorline
set cursorline

" statusline
set statusline=%t       " filename
set statusline+=\ %{&ff}  " file format
set statusline+=\ %y     " filetype
set statusline+=%=      " separator
set statusline+=C:%c      " cursor column
set statusline+=\ L:%l/%L  " cursor line/total lines
set statusline+=\ %P    " percentage through file

highlight LineNr ctermfg=darkgrey
highlight Search ctermfg=white ctermbg=darkgrey
highlight IncSearch ctermfg=white ctermbg=darkgrey
highlight StatusLine ctermbg=black ctermfg=grey
highlight CursorLine cterm=bold
