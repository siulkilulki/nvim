call plug#begin('~/.config/nvim/plugged')
" Plugins {
  " ctrl-p is a fuzzy file finder.
  Plug 'kien/ctrlp.vim'
  " airline is a better status line and a tab-bar for nvim.
  Plug 'bling/vim-airline'
  " gruvbox colorscheme. Seems to work the best for me.
  Plug 'morhetz/gruvbox'
  " autocomplete
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " autocomplete for c
  Plug 'zchee/deoplete-clang'
  " autoinclude
  Plug 'Shougo/neocomplete.vim'
  " snippets
  " Plug 'Shougo/neosnippet'
  " Plug 'Shougo/neosnippet-snippets'
  " autocomplete for Python
  Plug 'zchee/deoplete-jedi'
  " markdown preview
  Plug 'iamcco/markdown-preview.vim', {'dir': '~/.config/nvim/_vimrc'}
  " tree file view for vim
  Plug 'scrooloose/nerdtree'
  " functions outline on right side of vim
  Plug 'majutsushi/tagbar'
  " automatically manage swapfiles
  Plug 'gioele/vim-autoswap'
"}
call plug#end()

if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" ipdb debug abrreviation
  ab ip import ipdb; ipdb.set_trace(context=12)

" Map the leader key to ,
  let mapleader="\<SPACE>"

" General {
  set smarttab
  "set noautoindent        " I indent my code myself.
  set nocindent           " I indent my code myself.
  set smartindent        " Or I let the smartindent take care of it.

  set nrformats-=octal
  set ttimeout
  set ttimeoutlen=100
" }

" Cursor {
"  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0
" }

" Search {
  set ignorecase          " Make searching case insensitive
  set smartcase           " ... unless the query has capital letters.
  set gdefault            " Use 'g' flag by default with :s/foo/bar/.
  set magic               " Use 'magic' patterns (extended regular expressions).

  " Use <C-l> to clear the highlighting of :set hlsearch.
  if maparg('<C-l>', 'n') ==# ''
    nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
  endif
" }

" Formatting {
  set showcmd             " Show (partial) command in status line.
"  set showmatch           " Show matching brackets.
  set showmode            " Show current mode.
  set ruler               " Show the line and column numbers of the cursor.
  set number              " Show the line numbers on the left side.
  set formatoptions+=o    " Continue comment marker in new lines.
  set textwidth=0         " Hard-wrap long lines as you type them.
  set expandtab           " Insert spaces when TAB is pressed.
  set tabstop=4           " Render TABs using this many spaces.
  set shiftwidth=4        " Indentation amount for < and > commands.

  set noerrorbells        " No beeps.
  set modeline            " Enable modeline.
  set esckeys             " Cursor keys in insert mode.
  set linespace=0         " Set line-spacing to minimum.
  set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)

  " More natural splits
  set splitbelow          " Horizontal split below current.
  set splitright          " Vertical split to right of current.

  if !&scrolloff
    set scrolloff=3       " Show next 3 lines while scrolling.
  endif
  if !&sidescrolloff
    set sidescrolloff=5   " Show next 5 columns while side-scrolling.
  endif
  set display+=lastline
  set nostartofline       " Do not jump to first character with page commands.

  " Tell Vim which characters to show for expanded TABs,
  " trailing whitespace, and end-of-lines. VERY useful
  if &listchars ==# 'eol:$'
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
  endif
  set list                " Show problematic characters.

  " Also highlight all tabs and trailing whitespace characters.
  highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
  match ExtraWhitespace /\s\+$\|\t/

" }

" Configuration {
  if has('path_extra')
    setglobal tags-=./tags tags^=./tags;
  endif

  set autochdir           " Switch to current file's parent directory.

  " Remove special characters for filename
  set isfname-=:
  set isfname-==
  set isfname-=+

  " Map ; to :
  nnoremap ; :

  if &history < 1000
    set history=1000      " Number of lines in command history.
  endif
  if &tabpagemax < 50
    set tabpagemax=50     " Maximum tab pages.
  endif

  if &undolevels < 200
    set undolevels=200    " Number of undo levels.
  endif

  " create undo directory
  silent !mkdir -p ~/.vimundo
  " tell it to use an undo file
  set undofile
  " set a directory to store the undo history
  set undodir=~/.vimundo/

  " Path/file expansion in colon-mode.
  set wildmenu
  set wildmode=list:longest
  set wildchar=<TAB>

  if !empty(&viminfo)
    set viminfo^=!        " Write a viminfo file with registers.
  endif
  set sessionoptions-=options

  " Allow color schemes to do bright colors without forcing bold.
  if &t_Co == 8 && $TERM !~# '^linux'
    set t_Co=16
  endif

  " Remove trailing spaces before saving text files
  " http://vim.wikia.com/wiki/Remove_trailing_spaces
  autocmd BufWritePre * :call StripTrailingWhitespace()
  function! StripTrailingWhitespace()
    if !&binary && &filetype != 'diff'
      normal mz
      normal Hmy
      if &filetype == 'mail'
  " Preserve space after e-mail signature separator
        %s/\(^--\)\@<!\s\+$//e
      else
        %s/\s\+$//e
      endif
      normal 'yz<Enter>
      normal `z
    endif
  endfunction

  " Diff options
  set diffopt+=iwhite

  "Enter to go to EOF and backspace to go to start
  nnoremap <CR> G
  nnoremap <BS> gg
  " Stop cursor from jumping over wrapped lines
  nnoremap j gj
  nnoremap k gk
  " Make HOME and END behave like shell
  inoremap <C-E> <End>
  inoremap <C-A> <Home>
" }

" UI Options {

  " Colorscheme options.
  set bg=dark
  colorscheme gruvbox

  " Relative numbering
  function! NumberToggle()
    if(&relativenumber == 1)
      set nornu
      set number
    else
      set rnu
    endif
  endfunc

  " Toggle between normal and relative numbering.
  nnoremap <leader>r :call NumberToggle()<cr>

  " Sets a status line. If in a Git repository, shows the current branch.
  " Also shows the current file name, line and column number.
  "if has('statusline')
  "    set laststatus=2

  "    " Broken down into easily includeable segments
  "    set statusline=%<%f\                     " Filename
  "    set statusline+=%w%h%m%r                 " Options
  "    "set statusline+=%{fugitive#statusline()} " Git Hotness
  "    set statusline+=\ [%{&ff}/%Y]            " Filetype
  "    set statusline+=\ [%{getcwd()}]          " Current dir
  "    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
  "endif
" }

" Keybindings {
  " Save file
  nnoremap <Leader>w :w<CR>
  "Copy and paste from system clipboard
  vmap <Leader>y "+y
  vmap <Leader>d "+d
  nmap <Leader>p "+p
  nmap <Leader>P "+P
  vmap <Leader>p "+p
  vmap <Leader>P "+P

  " Move between buffers
  nmap <Leader>l :bnext<CR>
  nmap <Leader>h :bprevious<CR>
" }


" Experimental {
  " Search and Replace
  nmap <Leader>s :%s//c<Left><Left>
" }

" Plugin Settings {
  " Airline {
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    let g:airline#extensions#tabline#fnamemod = ':t'
    let g:airline#extensions#tabline#left_sep = ''
    let g:airline#extensions#tabline#left_alt_sep = ''
    let g:airline#extensions#tabline#right_sep = ''
    let g:airline#extensions#tabline#right_alt_sep = ''
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_theme= 'gruvbox'
  " }
  " CtrlP {
    " Open file menu
    nnoremap <Leader>o :CtrlP<CR>
    " Open buffer menu
    nnoremap <Leader>b :CtrlPBuffer<CR>
    " Open most recently used files
    nnoremap <Leader>f :CtrlPMRUFiles<CR>
  " }
  " Deoplete {
    "Use deoplete.
      let g:deoplete#enable_at_startup = 1

    " Deoplete-clang {
      let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-3.8/lib/libclang.so.1'
      let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-3.8/lib/clang'

      " let g:deoplete#sources#clang#std = {'c':'c11'}
      " The sorting algorithm for libclang completion results.
      " By defalut ('') use the deoplete.nvim sort algorithm.
      " priority sorts the way libclang determines priority
      " alphabetical sorts by alphabetical order.
      " let g:deoplete#sources#clang#sort_algo = 'priority'
    " }

    " Deoplete-jedi {
      " Python path
      let g:deoplete#sources#jedi#python_path = '/usr/bin/python3'
    " }

    " auto close preview window when autocomplete is done
      autocmd CompleteDone * pclose
    " close popup when open with enter
      inoremap <expr> <CR> pumvisible()? deoplete#mappings#close_popup() : "\<CR>"
      set completeopt+=noinsert
  " }
  " NERDTree {
      " open NERDTree with ctrl-n
      map <C-n> :NERDTreeToggle<CR>
      " open a NERDTree automatically when vim starts up if no files were specified
       " autocmd StdinReadPre * let s:std_in=1
       " autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
      " close vim if the only window left open is a NERDTree
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  " }
  " Tagbar {
    " open tagbar with ctrl-t
    map <C-t> :TagbarToggle<CR>
  " }
  " yapf auto formatting python code
  autocmd FileType python nnoremap <leader>y :0,$!yapf<Cr>
" }

" vim:set ft=vim sw=2 ts=2:
