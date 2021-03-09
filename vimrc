filetype plugin indent on
set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'

Plug 'itchyny/lightline.vim'

Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

Plug 'dense-analysis/ale'

Plug 'tpope/vim-unimpaired'

call plug#end()

syntax on

colorscheme gruvbox
set background=dark

let @/='' " Clear register to avoid hlsearch after sourcing vimrc

set updatetime=250

" WSL hack
if $TERM =~ 'xterm-256color'
  set noek
endif

" Diff settings
set diffopt+=context:3,foldcolumn:1,internal,indent-heuristic,algorithm:patience

" Whitespace symbols
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:·

set ruler
set number relativenumber

set shortmess+=I  " Disable startup message

set hidden
set confirm

set completeopt-=preview

set tagbsearch
set tags=tags,./tags " Search from the current file folder up to working dir

set colorcolumn=81

set backspace=indent,eol,start " Allow backspace over lines

set wildmenu
set wildmode=list:longest,full

set showcmd
set laststatus=2

set splitbelow splitright

set ttimeoutlen=5 " Reduce keycode timeout to avoid delay with <Esc>

set backupdir=~/.vim/tmp//,.
set directory=~/.vim/tmp//,.
if has('persistent_undo')
  set undodir=~/.vim/tmp,.
  set undofile
endif

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

set autoindent
set smartindent

set scrolloff=5

set incsearch
set hlsearch
set ignorecase
set smartcase
set nowrapscan

" Change cursorline depends on the insert mode
augroup aug_cursor_line
  au!
  au InsertEnter * setlocal nocursorline
  au InsertLeave * setlocal cursorline
augroup end

" General mappings
" TODO: Move to the separated file
nnoremap <Space> <Nop>
let g:mapleader=' '

nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>

nnoremap <Leader>. :tabedit $MYVIMRC<CR>

nnoremap <silent> <Leader>w :up<CR>
nnoremap <silent> <Leader>W :wall<CR>
nnoremap <silent> <Leader>q :q<CR>
nnoremap <silent> <Leader>Q :confirm qall<CR>

nnoremap <silent> <CR> :noh<CR><CR>

nnoremap <silent> <Leader>ll :lopen<CR>
nnoremap <silent> <Leader>lq :copen<CR>

nnoremap j gj
nnoremap k gk

nnoremap Y y$

nnoremap * *zz
nnoremap # #zz
nnoremap ]} ]}zz
nnoremap [{ [{zz
nnoremap } }zz
nnoremap { {zz

nnoremap <Backspace> i<Backspace>

nnoremap <C-a> <C-^>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <Leader>> <C-w>5>
nnoremap <Leader>< <C-w>5<
nnoremap <Leader>- <C-w>5-
nnoremap <Leader>+ <C-w>5+

nnoremap <silent><Leader>c :lclose<bar>cclose<bar>pclose<CR>

inoremap <C-e> <C-o>A
inoremap <C-a> <C-o>I
inoremap <C-f> <C-o>l
inoremap <C-b> <C-o>b
inoremap <C-k> <C-o>d$

inoremap <silent><expr> <Tab> 
  \ pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-Tab> 
  \ pumvisible() ? "\<C-p>" : "\<C-h>"


" { FZF
let g:fzf_command_prefix = 'Fzf'
let g:fzf_buffers_jump = 1

let g:fzf_layout = { 'down': '40%' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
  \   'bg':      ['bg', 'Normal'],
  \   'hl':      ['fg', 'Comment'],
  \   'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \   'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \   'hl+':     ['fg', 'Statement'],
  \   'info':    ['fg', 'PreProc'],
  \   'border':  ['fg', 'Ignore'],
  \   'prompt':  ['fg', 'Conditional'],
  \   'pointer': ['fg', 'Exception'],
  \   'marker':  ['fg', 'Keyword'],
  \   'spinner': ['fg', 'Label'],
  \   'header':  ['fg', 'Comment'] }

nnoremap <silent> <Leader>o :FzfFiles<CR>
nnoremap <silent> <Leader>p :FzfHistory<CR>
nnoremap <silent> <Leader>r :FzfHistory:<CR>
nnoremap <silent> <Leader>a :FzfBuffers<CR>
nnoremap <silent> <Leader>t :FzfBTags<CR>

imap  <C-x><C-k> <Plug>(fzf-complete-word)
imap  <C-x><C-f> <Plug>(fzf-complete-path)
imap  <C-x><C-l> <Plug>(fzf-complete-buffer-line)
" }

" { ALE
let g:ale_linters = {'rust': ['analyzer']}
let g:ale_fixers = {'rust': ['rustfmt']}
let g:ale_completion_enabled = 1
let g:ale_sign_column_always = 1

function! s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    ALEHover
  endif
endfunction

nnoremap <silent><buffer> K :call <SID>show_documentation()<CR>
nnoremap <buffer> gd :ALEGoToDefinition<CR>
nnoremap <buffer> gr :ALEFindReferences<CR>
nmap <buffer> ]G <Plug>(ale_last)
nmap <buffer> [G <Plug>(ale_first)
nmap <buffer> ]g <Plug>(ale_next_wrap)
nmap <buffer> [g <Plug>(ale_previous_wrap)

" }
