filetype plugin indent on
set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'

Plug 'itchyny/lightline.vim'

Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'

Plug 'rhysd/vim-lsp-ale'

Plug 'cespare/vim-toml'

Plug 'liuchengxu/vista.vim'

Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

Plug 'dense-analysis/ale'

Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'

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

function! Cls()
  if get(s:, 'started_as_diff', 0)
    exec 'qa'
  else
    exec 'q'
  endif
endfunction

function! GrepFunc(...)
  execute 'silent grep ' .  a:1 | redraw! | cwindow
endfunction

command! -nargs=+ Grep call GrepFunc(<q-args>)

set splitbelow splitright

set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m

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

let g:c_syntax_for_h = 1

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
nnoremap <silent> <Leader>q :call Cls()<CR>
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

cnoremap <C-a> <C-b>

inoremap <C-a> <C-o>I
inoremap <C-e> <C-o>A

inoremap <C-b> <C-o>h
cnoremap <C-b> <Left>

inoremap <C-f> <C-o>l
cnoremap <C-f> <Right>

inoremap f <C-o>w
cnoremap f <C-Right>

inoremap b <C-o>b
cnoremap b <C-Left>

inoremap <C-k> <C-o>d$

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

cnoremap <C-c> <C-f>

nnoremap <Leader>> <C-w>5>
nnoremap <Leader>< <C-w>5<
nnoremap <Leader>- <C-w>5-
nnoremap <Leader>+ <C-w>5+

nnoremap <silent><Leader>c :lclose<bar>cclose<bar>pclose<CR>

inoremap <silent><expr> <Tab>
  \ pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab>
  \ pumvisible() ? "\<C-p>" : "\<C-h>"

" { FZF

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

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
nnoremap <silent> <Leader>s :FzfTags<CR>
nnoremap <silent> <Leader>/ :FifBLines<CR>
nnoremap <silent> <Leader>F :FzfRg<CR>
nnoremap <silent> <Leader>f :FzfRg <C-r><C-w><CR>

imap  <C-x><C-k> <Plug>(fzf-complete-word)
imap  <C-x><C-f> <Plug>(fzf-complete-path)
imap  <C-x><C-l> <Plug>(fzf-complete-buffer-line)
" }

" { ALE
let g:ale_echo_msg_format='[%linter%][%severity%] %s %code%'
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let g:ale_linters = {
  \ 'rust': ['vim-lsp'],
  \ 'cpp': ['clangtidy', 'cppcheck', 'vim-lsp'],
  \ 'c': ['clangtidy', 'vim-lsp']
  \ }
let g:ale_fixers = {
  \ 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'cpp': ['clang-format', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'c': ['clang-format', 'trim_whitespace', 'remove_trailing_lines']
  \ }

let g:ale_c_clangformat_executable = 'clang-format-12'
let g:ale_c_clangformat_use_local_file = 1
let g:ale_c_clangformat_style_option = '{
  \ SpaceAfterTemplateKeyword:        false,
  \ ColumnLimit:                      80,
  \ BreakBeforeBraces:                Linux,
  \ AlwaysBreakTemplateDeclarations:  Yes,
  \ AllowShortBlocksOnASingleLine:    Empty,
  \ AllowShortFunctionsOnASingleLine: Inline,
  \ PointerAlignment:                 Left,
  \ }'
let g:ale_cpp_cppcheck_options = '--enable=style --std=c++17 --inconclusive'
let g:ale_c_clangtidy_checks = ['-*, clang-*']
let g:ale_cpp_clangtidy_extra_options = '--extra-arg=-std=c++17'

let g:ale_disable_lsp = 1
let g:ale_sign_column_always = 1

nmap ]G <Plug>(ale_last)
nmap [G <Plug>(ale_first)
nmap ]g <Plug>(ale_next_wrap)
nmap [g <Plug>(ale_previous_wrap)

nnoremap <leader>kf :ALEFix<CR>
" }

" { Vista
nnoremap <silent><Leader>] :Vista!!<CR>
" }

" { Lsp
" let g:lsp_log_file = expand('~/vim-lsp.log')
let g:lsp_hover_conceal=0
let g:lsp_show_message_log_level = 'warning'
let g:lsp_diagnostics_enabled = 0
let g:lsp_diagnostics_signs_enabled = 0
let g:lsp_semantic_enabled = 0
let g:lsp_document_highlight_enabled = 0

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gvd :vertical LspDefinition<CR>
    nmap <buffer> gD <plug>(lsp-declaration)
    nmap <buffer> gvD :vertical LspDeclaration<CR>
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> ]r <plug>(lsp-next-reference)
    nmap <buffer> [r <plug>(lsp-previous-reference)
endfunction

function! s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    LspHover
  endif
endfunction

nnoremap K :call <SID>show_documentation()<CR>

augroup aug_lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup end

augroup aug_rust_lsp
  au!
  autocmd FileType rust let g:ale_disable_lsp = 0 | call DoRegisterRustServer()
  function! DoRegisterRustServer()
    if executable('rust-analyzer')
      au User lsp_setup call lsp#register_server({
        \ 'name': 'Rust Language Server',
        \ 'cmd': {server_info->['rust-analyzer']},
        \ 'whitelist': ['rust'],
        \ 'initialization_options': {
        \   'cargo': {
        \     'loadOutDirsFromCheck': v:true,
        \   },
        \   'completion': {
        \     'addCallArgumentSnippets': v:true,
        \   },
        \   'procMacro': {
        \     'enable': v:true,
        \   },
        \ }
        \ })
    endif
  endfunction
augroup end

augroup aug_cpp_c_lsp
  au!
  autocmd FileType cpp,c call DoRegisterCppCServer()
  function! DoRegisterCppCServer()
    if executable('clangd')
      au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->[
        \   'clangd', '-j=2', '--pch-storage=memory',
        \   '--completion-style=detailed', '--background-index',
        \   '--header-insertion=never']},
        \ 'allowlist': ['cpp', 'c']
        \ })
    endif
  endfunction
augroup end
" }

augroup aug_diff
  au!
  if &diff
    let s:started_as_diff = 1
  endif
augroup end
