" PLUGINS ---------------------------------------------------------------------- {{{
" Check if VimPlug is installed
if empty(glob('~/.vim/autoload/plug.vim'))
  " Download VimPlug
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
    Plug 'dense-analysis/ale'
    Plug 'vim-airline/vim-airline'
    Plug 'tpope/vim-fugitive'
    Plug 'preservim/nerdtree'
    Plug '~/.fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'morhetz/gruvbox'
    Plug 'rust-lang/rust.vim'
    Plug 'lervag/vimtex'
call plug#end()

" }}}

" PLUGIN SETTINGS ---------------------------------------------------------------------- {{{

" ALE
let g:ale_linters = {
      \ 'python':['flake8','jedils'],
      \ 'cpp': ['clangd'],
      \ 'c': ['clangd'],
      \ 'rust':['analyzer'],
      \ }

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'python': ['black', 'isort'],
      \ 'rust': ['rustfmt']
      \ }
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 1
let g:ale_fix_on_save = 0
let g:ale_floating_preview = 1
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 0
let g:ale_rust_cargo_use_clippy = 1
let g:ale_hover_type = 'floating' 

let g:ale_python_isort_options = '--profile black'
let g:ale_python_black_options = '--line-length 100'
let g:ale_python_flake8_options = '--ignore=E501,E211,W504,W503'

set omnifunc=ale#completion#OmniFunc

" air-line
let g:airline#extensions#ale#enabled=1
let g:airline#extensions#tabline#enabled=1

let g:airline_powerline_fonts=1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.colnr = ' ℅:'
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ' :'
let g:airline_symbols.maxlinenr = '☰ '
let g:airline_symbols.dirty='⚡'

" Gruvbox
let g:gruvbox_contrast_dark = 'hard'  " Options: 'soft', 'medium', 'hard'
let g:gruvbox_invert_selection = 0    " Keep selection background color

let g:tex_flavor = 'latex'

let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-pdf',
    \   '-interaction=nonstopmode',
    \   '-synctex=1',
    \ ],
    \}

" }}}

" GENERAL ---------------------------------------------------------------------- {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

set nocompatible
set encoding=utf-8
filetype plugin indent on
syntax on
set number
set relativenumber
set cursorline
set cursorlineopt=both
set shiftwidth=4
set tabstop=4
set smarttab
set expandtab
set nobackup
set noswapfile 
set scrolloff=25
set nowrap
set incsearch
set ignorecase
set colorcolumn=100
set smartcase
set showmatch
set showcmd
set showmode
set history=1000
set wildmenu
set wildmode=list:longest
set mouse=a
set hidden
set updatetime=500
set signcolumn=yes
set nohlsearch
set ttyfast
set autoread
set backspace=indent,eol,start
set belloff=all
set exrc 
set secure
set background=dark
set textwidth=100
set termguicolors

try
  colorscheme gruvbox
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme desert
endtry

" }}}

" REMAPS ---------------------------------------------------------------------- {{{
let mapleader = ","

nnoremap Y y$
noremap ¤ $
noremap ö [
noremap ä ]
noremap Ö {
noremap Ä }
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap - @@
nnoremap <leader>c :call CommentLines()<CR>
vnoremap <leader>c :call CommentLines()<CR>

" NVIM
nnoremap <C-L> <Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>
nnoremap & :&&<CR>

" Buffers
nnoremap gb :Buffers<CR>
nnoremap gl :b#<CR>
nnoremap <C-n> :bnext<CR>
nnoremap <C-b> :bprevious<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>d :bp\|bd #<CR>

" Windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-up> <C-w>+
nnoremap <C-down> <C-w>-
nnoremap <C-left> <C-w><
nnoremap <C-right> <C-w>>

" FZF & Ripgrep
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :Rg<CR>
vnoremap <leader>g :<C-u>call RipgrepVisualSelection()<CR>

" LSP
inoremap <expr> <Tab> pumvisible() ? "\<C-n>": "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>": "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>": "\<CR>"

" ALE
nnoremap gh :ALEHover<CR>
nnoremap gn :ALENext<CR>
nnoremap gp :ALEPrevious<CR>
inoremap <C-@> <C-\><C-O>:ALEComplete<CR>
nnoremap <leader>ad :ALEDetail<CR>

nnoremap gd :ALEGoToDefinition<CR>
nnoremap gr :ALEFindReferences<CR>
nnoremap gt :ALEGoToTypeDefinition<CR>

" NERD TREE
nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F3> :NERDTreeFind<CR>

" Quickfix window toggle
nnoremap <F4> :<C-u>call ToggleQuickFix()<CR>
" }}}

" SCRIPTS ---------------------------------------------------------------------- {{{
"
"
function! RipgrepVisualSelection()
  let old_reg = @"
  normal! gvy
  let selection = @"
  let @" = old_reg
  let command = 'Rg ' . selection
  execute command
endfunction

function! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    botright 20 copen
  else
    cclose
  endif
endfunction

" Fix Colors for ALE virtual text
function! SetAleTextColors() abort
  highlight ALEVirtualTextError ctermfg=red
  highlight ALEVirtualTextWarning ctermfg=yellow
  highlight link ALEVirtualTextInfo Comment
endfunction

autocmd VimEnter * call SetAleTextColors()

function! CommentLines()
  " Add comment strings for supported languages here.
  let l:comment_dict = {
      \ 'c': '//',
      \ 'cpp': '//',
      \ 'rust': '//',
      \ 'bash': '# ',
      \ 'python': '# ',
      \ 'vim': '" '
  \ }

  " Escape forward slashes in the comment strings
  for l:lang in keys(l:comment_dict)
    let l:comment_dict[l:lang] = substitute(l:comment_dict[l:lang], '/', '\\/', 'g')
  endfor

  let l:ft = &filetype
  let l:comment_str = get(l:comment_dict, l:ft, '')
  if l:comment_str == ''
    return
  endif

  if mode() == 'n'
    call ToggleComment(l:comment_str, '.')
    execute 'normal! j'
  elseif mode() == 'v'
    let l:start = getpos("'<")[1]
    let l:end = getpos("'>")[1]
    call ToggleComment(l:comment_str, l:start . ',' . l:end)
    normal! gv
  endif
endfunction

function! ToggleComment(comment_str, range)
    let l:first_line = getline(a:range == '.' ? '.' : split(a:range, ',')[0])

    if l:first_line =~ '^\s*' . a:comment_str
        let l:command = a:range . 's/^\s*\zs' . a:comment_str . '//'
        execute l:command
    else
        let l:command = a:range . 'g/\S/s/^\s*/&' . a:comment_str . '/'
        execute l:command
    endif
endfunction

" }}}

" BINARY EDITING ---------------------------------------------------------------------- {{{

augroup Binary
  au!
  au BufReadPre *.elf,*.out,*.bin,*.hex let &bin=1
  au BufReadPost *.elf,*.out,*.bin,*.hex if &bin | %!xxd
  au BufReadPost *.elf,*.out,*.bin,*.hex set ft=xxd | endif
  au BufWritePre *.elf,*.out,*.bin,*.hex if &bin | %!xxd -r
  au BufWritePre *.elf,*.out,*.bin,*.hex endif
  au BufWritePost *.elf,*.out,*.bin,*.hex if &bin | %!xxd
  au BufWritePost *.elf,*.out,*.bin,*.hex set nomod | endif
augroup END

" }}}
