" Plugins {{{
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
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-peekaboo'

Plug 'dense-analysis/ale'

Plug 'mhinz/vim-signify'

Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'

Plug 'wellle/context.vim'

Plug 'bfrg/vim-cpp-modern'
Plug 'bfrg/vim-qf-preview'

call plug#end()
" }}}

" General settings {{{
filetype plugin indent on
set nocompatible

syntax on

colorscheme gruvbox
set background=dark

let @/='' " Clear register to avoid hlsearch after sourcing vimrc

set updatetime=250

set diffopt+=context:3,foldcolumn:1,internal,indent-heuristic,algorithm:patience

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:·

set ruler
set number relativenumber

set shortmess+=I " Disable startup message

set hidden
set confirm

set completeopt-=preview

set tagbsearch
set tags=tags,./tags

set colorcolumn=81

set backspace=indent,eol,start

set wildmenu
set wildmode=list:longest,full

set noshowmode
set showcmd
set laststatus=2

set splitbelow splitright

set grepprg=rg\ --vimgrep\ --smart-case
set grepformat=%f:%l:%c:%m

set ttimeoutlen=5

set backupdir=~/.vim/tmp//,.
set directory=~/.vim/tmp//,.
if has('persistent_undo')
  set undodir=~/.vim/tmp,.
  set undofile
endif

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set autoindent
set smartindent
set nocindent
" set cino+=L0 " Ignore colon label jump shift

set formatoptions-=cro " Disable auto commenting

set scrolloff=5

set incsearch
set hlsearch
set ignorecase
set smartcase
set nowrapscan

set autoread

let g:c_syntax_for_h = 1
let g:mapleader=' '
" }}}

" General mappings {{{
nnoremap <Space> <Nop>

nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>

nnoremap <Leader>. :tabedit $MYVIMRC<CR>

nnoremap <silent> <Leader>w :up<CR>
nnoremap <silent> <Leader>W :wall<CR>
nnoremap <silent> <Leader>q :call Cls()<CR>
nnoremap <silent> <Leader>Q :confirm qall<CR>

nnoremap <silent> , :noh<CR>

nnoremap <silent> <Leader>ll :lopen \| wincmd p<CR>
nnoremap <silent> <Leader>lq :copen \| wincmd p<CR>

nnoremap j gj
nnoremap k gk

nnoremap Y y$

nnoremap * *zz
nnoremap # #zz
nnoremap ]] ]]zz
nnoremap [[ [[zz
nnoremap ]m ]mzz
nnoremap [m [mzz
nnoremap ]} ]}zz
nnoremap [{ [{zz
nnoremap } }zz
nnoremap { {zz

nnoremap <C-a> <C-^>

cnoremap <C-a> <C-b>

inoremap <C-a> <C-o>I
inoremap <C-e> <C-o>A

inoremap <C-b> <C-o>h
cnoremap <C-b> <Left>

inoremap <C-f> <C-o>l
cnoremap <C-f> <Right>
 
inoremap <C-k> <C-o>d$

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

cnoremap <C-c> <C-f>

nnoremap <C-d> m'<C-d>
nnoremap <C-u> m'<C-u>

nnoremap <Leader>> <C-w>10>
nnoremap <Leader>< <C-w>10<
nnoremap <Leader>- <C-w>10-
nnoremap <Leader>+ <C-w>10+

nnoremap <leader>da :DiffAll<CR>
nnoremap <leader>do :diffoff!<Cr>

nnoremap <Leader>z :call Zoom()<CR>

nnoremap <silent><Leader>c :lclose<bar>cclose<bar>pclose<CR>

inoremap <silent><expr> <Tab>
  \ pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab>
  \ pumvisible() ? "\<C-p>" : "\<C-h>"
" }}}

" General commands {{{
command! -nargs=+ Grep call s:GrepFunc(<q-args>)

command! -nargs=+ OpenLine call s:OpenLineFunc(<q-args>)

command! ForceSave :w !sudo tee %

command! Only :%bd|e#|bd#

command! ToHex :%!xxd
command! FromHex :%!xxd -r

command! Lcdf :lcd %:p:h

command! Catc :tab terminal cat %

command! DiffAll :windo diffthis

command! CopyFilePath :silent execute '!realpath % | xclip -sel clip' | redraw!

command! -nargs=* -complete=highlight MatchLastVS
  \ call MatchLastVisualSelection(<f-args>)

" }}}

" General functions {{{
let s:zoomed=0
function! Zoom()
  if s:zoomed
    execute "normal! \<C-w>="
    let s:zoomed=0
  else
    execute "normal! \<C-w>|\<C-w>_"
    let s:zoomed=1
  endif
endfunction

function! SendToPane1()
  let s:line = getline('.')
  execute 'silent !tmux send -t 1 "' . s:line . '" Enter'
  redraw!
endfunction
nnoremap <C-c> :call SendToPane1()<CR>

function! RepeatLastCmd()
  execute 'silent !tmux send -t 1 "\!\!" Enter'
  redraw!
endfunction
nnoremap L :call RepeatLastCmd()<CR>

function! Cls()
  if get(s:, 'started_as_diff', 0)
    exec 'qa'
  else
    exec 'q'
  endif
endfunction

function! s:MakeMatchStringFromVisualSelection()
  norm gv"zy
  let content = '^.*' . escape(getreg('z'), '.]') . '.*$'
  return content
endfunction

function! MatchLastVisualSelection(group = 'GruvboxGreen') abort
  let pattern = s:MakeMatchStringFromVisualSelection()
  echomsg pattern
  call matchadd(a:group, pattern)
endfunction

function! s:GrepFunc(...) abort
  execute 'silent! grep! ' .  a:1 | redraw! | cwindow
endfunction

function! s:OpenLineFunc(...) abort
  let line = a:1
  let tokens = split(line, ':')
  if len(tokens) < 2
    echo "Invalid tokens size"
    return
  endif
  execute 'e +' . tokens[1] . ' ' . tokens[0]
endfunction
" }}}

" General autocommands {{{
augroup aug_file_detect
  au!
  au BufEnter *.ipp :setlocal ft=cpp
  au BufEnter .vimrc :setlocal foldmethod=marker
  au BufNewFile,BufRead make.inc setf make
  " au FileType netw let b:fzf_layout = { 'down': '40%' }
augroup end

augroup aug_cursor_line
  au!
  au InsertEnter * setlocal nocursorline
  au InsertLeave * setlocal cursorline
augroup end

augroup aug_diff
  au!
  if &diff
    set noreadonly
    let s:started_as_diff = 1
  endif
augroup end
" }}}

" fzf {{{
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

function! s:rg_no_ignore(...) abort
  let s:pattern = get(a:, 1, '')
  if s:pattern == '' | return | endif

  let s:path = get(a:, 2, '.')
  let s:command = shellescape(s:pattern) . ' ' .s:path
  let s:cmd = 'rg --no-ignore --column --line-number --no-heading --color=always
    \ -- ' .shellescape(s:pattern) . ' ' . s:path
  echom s:cmd
  call fzf#vim#grep(s:cmd, 1, fzf#vim#with_preview())
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_command_prefix = 'Fzf'
let g:fzf_buffers_jump = 1
" let g:fzf_layout = { 'down': '40%' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
            \ { 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'border':  ['fg', 'Ignore'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }

command! FzfHome :FzfFiles ~\/

command! -nargs=* RgFixed
  \ call fzf#vim#grep(
  \   'rg --no-ignore --column --line-number --no-heading --color=always
  \     --fixed-strings --glob=!tags --glob=!cmake-build
  \     --glob=!compile_commands.json --glob=!clang-tidy*
  \     --glob=!.cache* -- '
  \   .shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)

command! -nargs=* -complete=file Rg
  \ call s:rg_no_ignore(<f-args>)

nnoremap <silent> <Leader>o :FzfFiles<CR>
xnoremap <silent> <Leader>o y:FzfFiles <C-r><C-w><CR>
nnoremap <silent> <Leader>p :FzfHistory<CR>
nnoremap <silent> <Leader>r :FzfHistory:<CR>
nnoremap <silent> <Leader>/ :FzfHistory/<CR>
nnoremap <silent> <Leader>a :FzfBuffers<CR>
nnoremap <silent> <Leader>t :FzfBTags<CR>
nnoremap <silent> <Leader>s :FzfTags<CR>
nnoremap <silent> <Leader>, :FzfBLines<CR>
nnoremap <silent> <Leader>f :FzfRg<CR>
nnoremap <silent> <Leader>K :FzfHelptags<CR>
nnoremap <silent> <Leader>F :RgFixed <C-r><C-w><CR>
xnoremap <silent> <Leader>f y:RgFixed <C-r>"<CR>

imap  <C-x><C-k> <Plug>(fzf-complete-word)
imap  <C-x><C-f> <Plug>(fzf-complete-path)
imap  <C-x><C-l> <Plug>(fzf-complete-buffer-line)
" }}}

" ale {{{
let g:ale_disable_lsp = 1
let g:ale_linters_explicit = 1
let g:ale_sign_column_always = 1

let g:ale_echo_msg_format='[%linter%][%severity%] %s %code%'
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let g:ale_linters = {
  \ 'rust': ['vim-lsp', 'cargo'],
  \ 'cpp': ['clangtidy', 'cppcheck', 'vim-lsp'],
  \ 'c': ['clangtidy']
  \ }
let g:ale_fixers = {
  \ 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'cpp': ['clang-format', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'c': ['clang-format', 'trim_whitespace', 'remove_trailing_lines']
  \ }

let g:ale_c_clangformat_use_local_file = 1
let g:ale_c_clangformat_style_option = '{
  \ SpaceAfterTemplateKeyword:        false,
  \ ColumnLimit:                      80,
  \ IndentWidth:                      4,
  \ BreakBeforeBraces:                Linux,
  \ AlwaysBreakTemplateDeclarations:  Yes,
  \ AllowShortBlocksOnASingleLine:    Empty,
  \ AllowShortFunctionsOnASingleLine: Inline,
  \ PointerAlignment:                 Left,
  \ ReferenceAlignment:               Left,
  \ BreakConstructorInitializers:     BeforeComma,
  \ FixNamespaceComments:             true,
  \ NamespaceIndentation:             None,
  \ }'
let g:ale_c_clangtidy_checks = ['-*, clang-*']
let g:ale_cpp_clangtidy_checks = ['-*, clang-*', 'cppcoreguidelines-*', '-cppcoreguidelines-pro-bounds-array-to-pointer-decay', '-cppcoreguidelines-pro-type-vararg']
let g:ale_cpp_clangtidy_extra_options = '--extra-arg=-std=c++17'

nmap ]G <Plug>(ale_last)
nmap [G <Plug>(ale_first)
nmap ]g <Plug>(ale_next_wrap)
nmap [g <Plug>(ale_previous_wrap)

nnoremap <leader>kf :ALEFix<CR>

command! ALEInfoToTmpTab :silent set autoread |
  \ ALEInfoToFile /tmp/ale_info |
  \ tabedit /tmp/ale_info |
  \ set noautoread
" }}}

" vista {{{
" let g:vista_default_executive='vim_lsp'
let g:vista_finder_alternative_executives = ['ctags']
let g:vista_fzf_preview = ['right:50%']
let g:vista_keep_fzf_colors = 1

nnoremap <silent><Leader>] :Vista!!<CR>
" }}}

" context {{{
let g:context_enabled = 0

nnoremap <leader>[ :ContextToggle<CR>
" }}}

" asyncomplete {{{
inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"
" }}}

" vim-fugitive {{{
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gs :Git status<CR>
nnoremap <leader>gd :Gvdiffsplit<CR>
nnoremap <leader>gg :Git
nnoremap <leader>glC :G! log --follow -p -- %<CR>
nnoremap <leader>glc :G! log --follow -- %<CR>
" }}}

" gv {{{
nnoremap <leader>gv :GV <CR>
nnoremap <leader>gV :GV! <CR>
" }}}

" vim-lsp-ale {{{
let g:lsp_ale_auto_enable_linter = 0
" }}}

" vim-signify {{{
nnoremap <leader>hu :SignifyHunkUndo<CR>
nnoremap <leader>hh :SignifyToggleHighlight<CR>
nnoremap <leader>ht :SignifyToggle<CR>
nnoremap <leader>hr :SignifyRefresh<CR>
nnoremap <leader>hl :SignifyList<CR>
nnoremap <leader>hf :SignifyFold<CR>
" }}}

" vim-lsp {{{
let g:lsp_log_file = expand('~/.vim/tmp/lsp.log')
" let g:lsp_show_message_log_level = 'log'
" let g:lsp_document_highlight_enabled = 1
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_inlay_hints_enabled = 1
let g:lsp_code_action_ui = 'float'
let g:lsp_completion_documentation_delay = 1000
let g:lsp_signature_help_delay = 1000
let g:lsp_signature_help_enabled = 0

let g:lsp_inlay_hints_mode = { 'normal': ['curline'], }                             

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    " if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gvd :vertical LspDefinition<CR>
    nmap <buffer> gD <plug>(lsp-declaration)
    nmap <buffer> gvD :vertical LspDeclaration<CR>
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gs <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> ]r <plug>(lsp-next-reference)
    nmap <buffer> [r <plug>(lsp-previous-reference)
    nmap <buffer> <leader>lp :LspPeekDefinition<CR>
    nmap <buffer> <leader>la :LspCodeAction<CR>
    nmap <buffer> <leader>ls :LspWorkspaceSymbol <C-r><C-w><CR>
    xmap <buffer> <leader>lf <plug>(lsp-document-range-format)
    nmap <buffer> <leader>lf <plug>(lsp-document-format)
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

augroup aug_lsp_setup
  au!
  au User lsp_setup call s:RegisterServers()
  function! s:RegisterServers()
    if executable('rust-analyzer')
      call lsp#register_server({
        \ 'name': 'Rust Language Server',
        \ 'cmd': {server_info->['rust-analyzer']},
        \ 'whitelist': ['rust'],
        \ 'initialization_options': {
        \   'cargo': {
        \     'autoreload': v:true,
        \     'buildScripts': {
        \       'enable': v:true,
        \     },
        \   },
        \   'procMacro': {
        \     'enable': v:true,
        \   },
        \ }
        \})
    endif
    if executable('clangd')
      call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->[
        \   'clangd',
        \   '-j=8',
        \   '--inlay-hints',
        \   '--pch-storage=memory',
        \   '--completion-style=detailed',
        \   '--background-index',
        \   '--header-insertion=never']},
        \ 'allowlist': ['cpp', 'c']
        \ })
    endif
  endfunction
augroup end
" }}}

" vim-qf-preview {{{
let g:qfpreview = {'sign': {'linehl': 'CursorLine'}, 'offset': 5}

augroup qfpreview
  au!
  autocmd FileType qf nmap <buffer> p <plug>(qf-preview-open)
augroup END
" }}}
