" Plugins {{{
call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'

Plug 'itchyny/lightline.vim'

Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'

Plug 'rhysd/vim-lsp-ale'

" Plug 'liuchengxu/vista.vim'

Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/goyo.vim'

Plug 'dense-analysis/ale'
" Plug 'maximbaz/lightline-ale'

Plug 'mhinz/vim-signify'

Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'

Plug 'wellle/context.vim'

Plug 'bfrg/vim-cpp-modern'
Plug 'bfrg/vim-qf-preview'

Plug 'mbbill/undotree'

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

" set completeopt-=preview,noinsert,noselect
set completeopt=menuone,longest

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

set autoread

set noswapfile
" set directory=~/.vim/tmp//,.

set backupdir=~/.vim/tmp//,.
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

set scrolloff=5

set incsearch
set hlsearch
set ignorecase
set smartcase
set nowrapscan

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

nnoremap ' `
nnoremap ` '

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

inoremap <C-a> <C-o>I
inoremap <C-e> <C-o>A
inoremap <C-f> <C-o>l
inoremap <C-b> <C-o>h
inoremap <C-k> <C-o>d$

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

xnoremap <C-y> :silent w !xclip -sel clip<CR>
xnoremap * "zy/\V<C-r>=escape(@z,'\/')<CR><CR>zz
xnoremap # "zy?\V<C-r>=escape(@z,'\/')<CR><CR>zz

inoremap <C-z> <Esc>ZZ

nnoremap <C-d> m'<C-d>
nnoremap <C-u> m'<C-u>

nnoremap <Leader>> <C-w>10>
nnoremap <Leader>< <C-w>10<

nnoremap <Leader>da :windo diffthis<CR>
nnoremap <Leader>do :diffoff!<CR>

nnoremap <silent><Leader>c :lclose<bar>cclose<bar>pclose<CR>

inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
" }}}

" General commands {{{
command! -nargs=+ -complete=file -bar 
    \ Grep silent! grep! <args> | cwindow | wincmd p | redraw!

command! -nargs=+ OpenLine call s:OpenLineFunc(<q-args>)
command! -nargs=+ OpenLineVs call s:OpenLineFunc(<q-args>, 1)

command! ForceSave :w !sudo tee %

command! Only :%bd|e#|bd#

command! ToHex :%!xxd
command! FromHex :%!xxd -r

command! Lcdf :lcd %:p:h
command! Lcdg :lcd `git rev-parse --show-toplevel`

command! Tcat :tab terminal cat %

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
nnoremap <Leader>z :call Zoom()<CR>

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
    let s:zoomed=0
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

function! s:OpenLineFunc(...) abort
    let line = a:1
    if empty(a:2)
        let cmd='e +'
    else
        let cmd='vs +'
    endif
    let tokens = split(line, ':')
    if len(tokens) < 2
        echo "Invalid tokens size"
        return
    endif
    execute cmd . tokens[1] . ' ' . tokens[0]
endfunction
" }}}

" General autocommands {{{
augroup aug_netrw
    au!
    autocmd FileType netrw nmap <buffer> <C-r> <Plug>NetrwRefresh
augroup end

augroup aug_file_detect
    au!
    au BufNewFile,BufRead make.inc    setf make
    au BufEnter           *.ipp       setlocal ft=cpp
    au BufEnter           .vimrc      setlocal foldmethod=marker
    au FileType           *           setlocal formatoptions-=cro
    au FileType           qf          wincmd J
    au FileType           cpp         setlocal commentstring=//\ %s
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

let g:fzf_vim = {}
let g:fzf_vim.command_prefix = 'Fzf'
let g:fzf_vim.buffers_jump = 1
let g:fzf_vim.preview_window = ['right,80%', 'ctrl-/']

let g:fzf_action = {
    \ 'ctrl-q': function('s:build_quickfix_list'),
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit' }

" let g:fzf_layout = { 'up': '40%' }
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true } }

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

command! FzfHome :FzfFiles ~\/

command! -nargs=* -complete=file RgFixed
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always
    \       --fixed-strings -- '
    \   .<q-args>, 1, fzf#vim#with_preview(), <bang>0)

command! -nargs=* -complete=file Rg
    \ call s:rg_no_ignore(<f-args>)

function! s:lcd_sink(lines)
    if len(a:lines) != 1
        return
    endif
    let path = split(a:lines[0])
    execute 'lcd ' path[1]
    pwd
endfunction

command! -nargs=* FilesNoIgnore :call fzf#run(
    \ fzf#wrap({'source': 'fdfind --no-ignore', 'sink': 'e'}))
command! Fcd :call fzf#run(fzf#wrap({'source': 'cat ~/.hotlist', 'sink': 'lcd'}))
command! Fup :call fzf#run(fzf#wrap({
    \ 'source': 'updirs',
    \ 'options': '--preview="tree -C -L 3 {2}"',
    \ 'sink*': function('<sid>lcd_sink')}))

command! Fgdown :call fzf#run(fzf#wrap({
    \ 'source':
    \   "fdfind --hidden --follow '^\.git$' --no-ignore --type=d -x echo {//}",
    \ 'options': '--preview="tree -C -L 3 {1}"',
    \ 'sink': 'lcd'}))


nnoremap <silent> <Leader>\ :Fcd<CR>
nnoremap <silent> <Leader>- :Fup<CR>
nnoremap <silent> <Leader>+ :Fgdown<CR>

nnoremap <silent> <Leader>j :FzfJumps<CR>
nnoremap <silent> <Leader>O :FilesNoIgnore<CR>
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
xnoremap <silent> <Leader>f y:RgFixed '<C-r>"'<CR>

imap  <C-x><C-k> <Plug>(fzf-complete-word)
imap  <C-x><C-f> <Plug>(fzf-complete-path)
imap  <C-x><C-l> <Plug>(fzf-complete-buffer-line)
" }}}

" ale {{{
let g:ale_enabled = 0
let g:ale_disable_lsp = 1
let g:ale_linters_explicit = 1
let g:ale_sign_column_always = 1
let g:ale_virtualtext_cursor='disable'

let g:ale_echo_msg_format='[%linter%][%severity%] %s %code%'
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let g:ale_linters = {
    \ 'rust': ['vim-lsp', 'cargo'],
    \ 'cpp': ['clangtidy', 'cppcheck', 'vim-lsp'],
    \ 'cc': ['clangtidy', 'cppcheck', 'vim-lsp'],
    \ 'c': ['clangtidy', 'vim-lsp'],
    \ 'cmake': ['cmakelint'],
    \ 'sh': ['shellcheck']
    \ }
let g:ale_fixers = {
    \ 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'],
    \ 'cpp': ['clang-format', 'trim_whitespace', 'remove_trailing_lines'],
    \ 'c': ['clang-format', 'trim_whitespace', 'remove_trailing_lines'],
    \ 'cc': ['clang-format', 'trim_whitespace', 'remove_trailing_lines'],
    \ 'sh': ['clang-format', 'trim_whitespace', 'remove_trailing_lines']
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
let g:ale_cpp_clangtidy_checks = ['-*',
    \ 'clang-*',
    \ 'bugprone-*',
    \ 'modernize-*',
    \ '-modernize-use-trailing-return-type',
    \ 'cppcoreguidelines-*',
    \ '-cppcoreguidelines-pro-bounds-array-to-pointer-decay',
    \ '-cppcoreguidelines-pro-type-vararg',
    \ '-cppcoreguidelines-avoid-magic-numbers',
    \ '-cppcoreguidelines-avoid-non-const-global-variables',
    \ '-cppcoreguidelines-owning-memory',
    \ ]
let g:ale_cpp_clangtidy_extra_options = '-extra-arg=-std=c++17'
let g:ale_cpp_cppcheck_options = '--enable=warning -std=c++17'

let g:ale_lint_on_enter = 1
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0

nmap ]G <Plug>(ale_last)
nmap [G <Plug>(ale_first)
nmap ]g <Plug>(ale_next_wrap)
nmap [g <Plug>(ale_previous_wrap)

nnoremap <Leader>kf <Plug>(ale_fix)
nnoremap <Leader>kl <Plug>(ale_lint)
nnoremap <Leader>kt <Plug>(ale_toggle)
nnoremap <Leader>kr <Plug>(ale_reset)
nnoremap <Leader>ki <Plug>(ale_info)
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

nnoremap <Leader>[ :ContextToggle<CR>
" }}}

" asyncomplete {{{
inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"
" }}}

" vim-fugitive {{{
nnoremap <Leader>ga :Git add %<CR>
nnoremap <Leader>gc :Git checkout %<CR>
nnoremap <Leader>gr :Git reset %<CR>
nnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gs :Git status<CR>
nnoremap <Leader>gd :Gvdiffsplit<CR>
nnoremap <Leader>gm :Gvdiffsplit!<CR>
nnoremap <Leader>gg :Git<Space>
nnoremap <Leader>glC :G! log --follow -p -- %<CR>
nnoremap <Leader>glc :G! log --follow -- %<CR>
" }}}

" gv {{{
nnoremap <Leader>gv :GV <CR>
nnoremap <Leader>gV :GV! <CR>
" }}}

" vim-lsp-ale {{{
let g:lsp_ale_auto_enable_linter = 0
" }}}

" vim-signify {{{
nnoremap <Leader>hu :SignifyHunkUndo<CR>
nnoremap <Leader>hh :SignifyToggleHighlight<CR>
nnoremap <Leader>ht :SignifyToggle<CR>
nnoremap <Leader>hr :SignifyRefresh<CR>
nnoremap <Leader>hl :SignifyList<CR>
nnoremap <Leader>hf :SignifyFold<CR>
nnoremap <Leader>hd :SignifyDiff<CR>
" }}}

" vim-lsp {{{
let g:lsp_log_file = expand('~/.vim/tmp/lsp.log')
" let g:lsp_show_message_log_level = 'log'
" let g:lsp_document_highlight_enabled = 1
let g:lsp_document_code_action_signs_enabled = 0
" let g:lsp_code_action_ui = 'float'
" let g:lsp_signature_help_delay = 1000
let g:lsp_signature_help_enabled = 0

let g:lsp_inlay_hints_enabled = 0
let g:lsp_inlay_hints_mode = { 'normal': ['curline'], }

let g:lsp_preview_float = 0

function! s:on_lsp_float_opened() abort
    echom "on_lsp_float_opened"
    nmap <expr><buffer> <C-e> lsp#scroll(+1)
    nmap <expr><buffer> <C-y> lsp#scroll(-1)
    nmap <expr><buffer> <C-d> lsp#scroll(+10)
    nmap <expr><buffer> <C-u> lsp#scroll(-10)
endfunction

function! s:on_lsp_float_closed() abort
    echom "on_lsp_float_closed"
    nunmap <buffer> <C-e>
    nunmap <buffer> <C-y>
    nunmap <buffer> <C-d>
    nunmap <buffer> <C-u>
endfunction

function! s:on_lsp_server_exit() abort
    echom "on_lsp_server_exit " . g:is_lsp_reseted
    if g:is_lsp_reseted
        let g:is_lsp_reseted=0
        silent edit
    endif
endfunction

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <Plug>(lsp-definition)
    nmap <buffer> gvd :vertical LspDefinition<CR>
    nmap <buffer> gD <Plug>(lsp-declaration)
    nmap <buffer> gvD :vertical LspDeclaration<CR>
    nmap <buffer> gi <Plug>(lsp-implementation)
    nmap <buffer> gs <Plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <Plug>(lsp-references)
    nmap <buffer> ]r <Plug>(lsp-next-reference)
    nmap <buffer> [r <Plug>(lsp-previous-reference)
    nmap <buffer> <Leader>lp :LspPeekDefinition<CR>
    nmap <buffer> <Leader>lP :LspPeekDeclaration<CR>
    nmap <buffer> <Leader>la :LspCodeAction<CR>
    nmap <buffer> <Leader>ls :LspWorkspaceSymbol <C-r><C-w><CR>
    nmap <buffer> <Leader>lf <Plug>(lsp-document-format)
    xmap <buffer> <Leader>lf <Plug>(lsp-document-range-format)
endfunction

function! s:toggle_inlay_hints()
    let g:lsp_inlay_hints_enabled = !g:lsp_inlay_hints_enabled
    echo "LSP inlay hints " 
        \ . (g:lsp_inlay_hints_enabled ? "enabled" : "disabled")
    silent edit
endfunction

function! s:reset_lsp()
    LspStopServer
    let g:is_lsp_reseted=1
    " silent edit
endfunction

function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        LspHover
    endif
endfunction

nnoremap <Leader>lh :call <SID>toggle_inlay_hints()<CR>
nnoremap <Leader>lr :call <SID>reset_lsp()<CR>
nnoremap K :call <SID>show_documentation()<CR>

augroup aug_lsp_float_opened
    au!
    autocmd User lsp_float_opened call s:on_lsp_float_opened()
augroup end

augroup aug_lsp_float_closed
    au!
    autocmd User lsp_float_closed call s:on_lsp_float_closed()
augroup end

augroup aug_lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    autocmd User lsp_server_exit call s:on_lsp_server_exit()
augroup end

augroup aug_lsp_setup
    au!
    au User lsp_setup call s:RegisterServers()
    function! s:RegisterServers()
        if executable('rust-analyzer')
            call lsp#register_server({
                \ 'name': 'Rust Language Server',
                \ 'cmd': {server_info->['rust-analyzer']},
                \ 'allowlist': ['rust'],
                \})
        endif
        if executable('clangd')
            call lsp#register_server({
                \ 'name': 'clangd',
                \ 'cmd': {server_info->[
                \   'clangd',
                \   '-j=8',
                \   '--pch-storage=memory',
                \   '--query-driver=/**/*g++,/**/*gcc',
                \   '--completion-style=detailed',
                \   '--background-index',
                \   '--header-insertion=never']},
                \ 'allowlist': ['cpp', 'c', 'cc']
                \ })
        endif
    endfunction
augroup end
" }}}

" vim-qf-preview {{{
let g:qfpreview = {'sign': {'linehl': 'CursorLine'}, 'offset': 5}

augroup qfpreview
    au!
    autocmd FileType qf nmap <buffer> p <Plug>(qf-preview-open)
augroup END
" }}}

" lightline {{{
function! LightlineFilename()
  return pathshorten(expand("%"), 2)
endfunction

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename' ] ],
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \ },
      \ }
" }}}

" goyo {{{
nnoremap <Leader>y :Goyo 120<CR>
" }}}

" undotree {{{
nnoremap <Leader>u :UndotreeToggle<CR>
" }}}

" vineager {{{
nmap <Leader>\| <Plug>VinegarVerticalSplitUp
" }}}
