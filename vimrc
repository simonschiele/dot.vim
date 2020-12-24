"
" Simons Vim Config
"
" by Simon Schiele <simon.codingmonkey@gmail.com>
" last changed: 2020-07-18
"
" See README.rst for licence details, setup instructions and a general
" overview of my Vim setup.
"
" https://github.com/simonschiele/dot.vim
"

" {{{ Plugin loader: pathogen

" Use pathogen to load further modules from the plugins/ directory. Most
" plugins are not directly included in this repo, but available via git
" subrepos. Since this includes pathogen itself, you need to initalize the
" subrepos before this config can work.
" Also, for some plugins, system depencies are needed. See README.rst for
" details on howto properly setup everything for this config to work.

" todo: replace pathogen in vim8 by new native package mnmgt

if has('vim_starting')
    filetype off
    runtime plugins/pathogen/autoload/pathogen.vim

    " Vim sessions default to capturing all global options, which includes the
    " 'runtimepath' that pathogen.vim manipulates. This can cause other
    " problems too, so tpope recommends turning that behavior off. "[...]
    " though that has the side effect of not persisting any global options,
    " which may or may not be acceptable to you"
    set sessionoptions-=options

    " skip loading of specific plugin
    " can be also done via env variable $VIMBLACKLIST
    "
    " let g:pathogen_disabled = []
    " call add(g:pathogen_disabled, 'YouCompleteMe')

    " actually initalize pathogen with the plugin dirs
    silent! call pathogen#infect('plugins/depends/{}',
                               \ 'plugins/colors/{}',
                               \ 'plugins/local/{}',
                               \ 'plugins/syntax/{}',
                               \ 'plugins/textobj/{}',
                               \ 'plugins/{}')
endif

" }}}

" {{{ Information (globals, environment, terminal, ...)

" Here I try to collect some information and assumptions about the environment,
" potential desktop or terminal sessions, ...
" I also like to collect some reusable information and lists that might be
" reusable within the configuration.

" Maybe I should move this to a plugin one day...

let g:special_buffers = ['nofile', 'quickfix', 'help', 'minibufexpl', 'unite',
                       \ 'nerdtree', 'tagbar', 'startify', 'gundo', 'w3m',
                       \ 'vimshell', 'netrw', '[[buffergator-buffers]]']

let g:avoid_file_endings = ['.bak', '~', '.swp', '.pyc', '.o', '.so', '.a',
                          \ '.out', '.dll', '.mo', '.la', '.bin']

let g:avoid_directories = ['.git', '.svn', '.hg', 'CVS']
let g:filetypes_considered_text = ['text', 'markdown', 'rst', 'nfo']

" Chainload dirs/files for custom configs.
" See 'Local / Config chainload' in this config for more details.
let g:custom_config_dirs = ['.', '.vim', '.private', '.work']
let g:custom_config_files = ['vimrc', '.vimrc', 'vimrc.local', 'vimrc.custom',
                           \ 'vimrc.private', 'vimrc.work']

" File sizes to warn about or to react to
" todo: create test functions
"  big: >= 1mb
"  huge: >= 10mb
"  long: >= 1500 lines
let g:big_file_size = 1024 * 1024
let g:huge_file_size = g:big_file_size * 10
let g:long_file_length = 1500

" A line is considered long per default on 80 chars. Can be overwritten by ft.
" A line is considered to long for processing/highlighting/whatever at a length
" of 500 chars.
let g:long_line = 80
let g:too_long_line = 500

" }}}

" {{{ General editor defaults

" enable filetype sensitivity
filetype plugin on
filetype plugin indent on

" encoding
set encoding=utf-8
scriptencoding utf-8

" default fileformat
set ff=unix

" shell
set shell=/bin/sh
let readline_has_bash=1
let g:is_bash=1

" add < + > to bracket matching
set matchpairs+=<:>

" when closing brackets, shortly jump to opening one
" thought long about disabling it, but is really useful on long files
set matchtime=1
set showmatch

" show command while you type it (the one on right side of cmdbar)
set showcmd

" no linewrap on default
set nowrap

" disable spellcheck by default
set nospell

" nooooo, get rid of indentation stuff in main config
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab

" {{{ History, viminfo, swap, session, ...

let $TMPDIR = $HOME."/.vim/tmp/"

" Tell vim to remember certain things when we exit
"  '20  :  marks will be remembered for up to 20 previously edited files
"  %    :  saves and restores the buffer list
"  s[n] :  registers with more than <n>kb will be skipped
"  n... :  where to save the viminfo files
set viminfo='100,s1024,n~/.vim/tmp/viminfo

" }}}

" {{{ Open, Close, Save, ...

" If file changed and local buffer not changed, then reload the file without
" asking
set autoread

" Automatically write changes on buffer change
set autowrite

" Enable wild menu
set wildmenu

" }}}

" {{{ Buffers and Tabs

set tabpagemax=50
" set hidden          " hide buffers instead of closing them

" ghetto bufferlist (:B)
command! -nargs=? -bang B if <q-args> != '' | exe 'buffer '.<q-args> | else | ls<bang> | let buffer_nn=input('Choose buffer: ') | if buffer_nn != '' | exe buffer_nn != 0 ? 'buffer '.buffer_nn : 'enew' | endif | endif

" }}}

" {{{ Folding

" nicer seperator for foldings
" set fillchars+=fold:-

" set foldcolumn=1      " extra margin left (todo: verify)
" set foldopen=all      " autoopen fold on cursor
" set foldclose=all     " autoclose folding on leaving

" default foldmethod
"  marker    - folding on marker (default {{{ -> }}})
"  syntax    - folding by syntax
"  indent    - folding by indent
set foldmethod=marker   " fold on {{{ -> }}}, [marker, syntax, indent]

function! CustomFoldLabel()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('    ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '┆' . ' '
endfunction
set foldtext=CustomFoldLabel()

" }}}

" {{{ Search

set hlsearch    " highlight search term
set incsearch   " search while typing
set ignorecase  " case insensitive
set smartcase   " insensitive if all lowercase, sensitive otherwise

" }}}

" {{{ Printing

set printoptions=paper:a4,number:y,duplex:off

" }}}

" {{{ Disable annoyances and fix broken stuff

"
" ... or at least stuff that feels broken to me.
"

" intuitive backspace behavior
set backspace=indent,eol,start

" disable noise and bells
set noerrorbells
set visualbell
set vb t_vb=
set noeb vb t_vb=

" disable annoying recordings
map q <Nop>

" disable annoying ex mode
map Q <Nop>

" fix keycodes for screen
map [1~ <Home>
map [4~ <End>
imap [1~ <Home>
imap [4~ <End>

" allow cursor change in tmux
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" don't calculate in octal while doing in-/decrement
set nrformats-=octal

" delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
      set formatoptions+=j
endif

" ignore unwanted stuff in completion
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" fixes for vim on os x
if has("gui_macvim")
    augroup macfixes
        autocmd!

        " Properly disable sound on errors on MacVim
        autocmd GUIEnter * set vb t_vb=
    augroup END
endif

" }}}

" }}}

" {{{ Look / ui / gui / ...

" "Alles so schön bunt hier..."
" In this section we take care of colorschemes, highlighting, term colors,
" ui colors, listchars, ...

" drawing/update settings
set lazyredraw
set ttyfast
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=50
endif

" set and enable fancy listchars
if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8') && version >= 700
    set listchars=tab:→\   
    set listchars+=nbsp:␣
    set listchars+=trail:•   
    set listchars+=extends:⟩ 
    set listchars+=precedes:⟨
    " set listchars+=eol:↲   
    " if has('patch-7.4.710')
    "    set listchars+=space:.
    " endif
else
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<
endif
set list

"" strange settings for split windows. they are always minimized to
"" one line, except one. and you can switch nicely... not usable for
"" me but maybe comes handy some day for devices with small screen...
"set winminheight=0
"set winheight=999

" {{{ Colorscheme / highliting

if has("syntax")
    " todo: ...
    set background=dark

    " todo: ...
    set termguicolors

    " maximal linelength to actuall do syntax highlighting on
    " if to big, this makes vim barely usable on stuff like minified files
    let &synmaxcol=g:too_long_line

    " select colorscheme with this variable:
    let g:use_colorscheme = "gruvbox"

    " set options for fancy colorschemes
    if g:use_colorscheme == "nord"
        let g:nord_statusline_uniform = 1
        "let g:lightline.colorscheme = 'nord'

    elseif g:use_colorscheme == "gruvbox"
        " todo: check for gnome-terminal
        "let g:lightline.colorscheme = 'seoul256'
        "let g:lightline.colorscheme = 'one'
        let g:gruvbox_italic=1

        " todo: check termcolors
        "let g:gruvbox_termcolors=16
    elseif g:use_colorscheme == "solarized"
        "let g:lightline.colorscheme = 'solarized'
        let g:solarized_bold = 1
        let g:solarized_italic = 1
        let g:solarized_underline = 1
        let g:solarized_termtrans = 1
        let g:solarized_visibility = 'low'
    endif

    " actually set colorscheme
    " todo: replace execute
    execute "colorscheme " . g:use_colorscheme

    if ! exists("syntax_on") && ! exists("syntax_manual")
        " enable general syntax highliting
        syntax on

        " Spell highliting
        highlight clear SpellBad
        highlight SpellBad cterm=Underline ctermfg=Black ctermbg=Red term=Reverse gui=Undercurl guisp=Red
        highlight SpellCap cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Red
        highlight SpellLocal cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Red
        highlight SpellRare cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Red

        " Make comments italic
        highlight Comment cterm=italic gui=italic
    endif
endif

" }}}

" {{{ Statusline

" we have mode in our fancy statusline (lightline), so deactivate original one
set noshowmode

" always show status line
set laststatus=2

" tabline visibility
" set showtabline=2

" set actual statusline (see autoload/statusline.vim for details)

" }}}

highlight clear VertSplit
highlight clear StatusLine
highlight clear StatusLineNC
highlight StatusLine ctermbg=NONE guibg=NONE ctermfg=white guifg=foreground
highlight StatusLineNC ctermbg=NONE guibg=NONE ctermfg=white guifg=darkgrey
"highlight StatusLineNC gui=reverse cterm=reverse

set fillchars=vert:│,stl:\ ,stlnc:\ 
"set fillchars+=stlleft:┤
"set fillchars+=stlright:├
"set fillchars+=stlcross:┼
"set fillchars+=stlbottom:┴

set statusline=%{g:actual_curwin==win_getid()?statusline#CustomActiveStatusline():statusline#CustomInactiveStatusline(g:actual_curwin)}

" Slim down gui-vim
if has('gui_running')
    " no toolbar
    set guioptions-=T
    " no menubar
    set guioptions-=m
    " no right scrollbar
    set guioptions-=r
    " no left scrollbar
    set guioptions-=L
endif

" }}}

" {{{ Plugin: nerdtree

let g:NERDTreeQuitOnOpen = 1
" let g:NERDTreeMinimalUI=1
"

" open nerdtree if vim opened without file
" autocmd vimenter * if !argc() | NERDTree | endif

" quit vim if only nerdtree left
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" }}}

" {{{ Plugin: nerdcommenter

let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1

" }}}

" {{{ Keymappings

" <leader> mappings
" maplocalleader not used by this config, but plugins might use it, so let's
" set it to something I might be able to remember if I need it
let maplocalleader = ";"
let mapleader = ","

" enable meta key on os x
if exists('+macmeta')
    set macmeta
endif

" insert hardtab even in "softtab-mode" (Alt+Tab)
" todo: fix. worked on shift is somehow broken on alt.
" i(nore)map <M-Tab> <C-V><Tab>
nnoremap <S-Tab> <C-V><Tab>
inoremap <S-Tab> <C-V><Tab>

" switch buffer (Ctrl+PageUp/Down)
nnoremap <silent> <C-PageDown> :bn<CR>
nnoremap <silent> <C-PageUp> :bp<CR>

" create / switch tabs (Shift+Ctrl+PageUp/PageDown)
nnoremap <silent> <C-S-n> :tabnew<CR>
nnoremap <silent> <C-S-PageDown> :tabnext<CR>
nnoremap <silent> <C-S-PageUp> :tabprevious<CR>

" <leader> + v/s -> new split
nnoremap <silent> <Leader>v :vsplit<CR>
nnoremap <silent> <Leader>s :split<CR>

" <leader> + t -> terminal
nnoremap <silent> <Leader>t :terminal<CR>


" <F1>              Toggle numbers (plugin)
" <Shift>+<F1>      Toggle git gutter (plugin)
"nnoremap <silent> <F1> :NumbersToggle<CR>
"nnoremap <silent> <S-F1> :GitGutterToggle<CR>

" <F2>              Stop active search highlighting
nnoremap <silent> <F2> :noh<CR>

" <F3>              Toggle ignorecase
nnoremap <F3> :set ic!<bar>set ic?<CR>

" <F4>              Toggle line wrap
nnoremap <F4> :set wrap!<bar>set wrap?<CR>

" <F5>              Executes/Previews/... the buffer based on filetype
" <S-F5>            Special Exec that can be implemented per filetype
" <C-S-F5>          Very Special Exec that can be implemented per filetype
map <F5> :echo 'execute not configured for filetype' &filetype<CR>
map <S-F5> :echo 'shift-execute not configured for filetype' &filetype<CR>
map <C-S-F5> :echo 'ctrl-shift-execute not configured for filetype' &filetype<CR>

" <F6>              Cleanup/format/... the buffer based on filetype
" <S-F6>            Special cleanup that can be implemented per filetype
" <C-S-F6>          Very special cleanup that can be implemented per filetype
map <F6> :echo 'cleanup not configured for filetype' &filetype<CR>
map <S-F6> :echo 'shift-cleanup not configured for filetype' &filetype<CR>
map <C-S-F6> :echo 'ctrl-shift-cleanup not configured for filetype' &filetype<CR>

" <F7> Toggle spellcheck / switch languages
nnoremap <F7> :<C-U>call spell#SpellToggle()<CR>

"nnoremap <silent> <F8> :SyntasticCheck<CR>
"nnoremap <silent> <S-F8> :SyntasticCheckToggle<CR>

nnoremap <silent> <F8> :NERDTreeToggle<CR>

nnoremap <silent> <F9> :TagbarToggle<CR>

" }}}

" {{{ Filetype mappings

augroup FiletypeSetup
    autocmd!
    " autocmd VimEnter * highlight clear SignColumn
    autocmd BufNewFile,BufFilePre,BufRead *.[Mm][Dd] set filetype=markdown.pandoc
    autocmd BufNewFile,BufFilePre,BufRead *.[Nn][Ff][Oo] set filetype=nfo
    autocmd BufNewFile,BufFilePre,BufRead *.cls setlocal filetype=java
    autocmd BufNewFile,BufFilePre,BufRead *.zsh-theme setlocal filetype=zsh
augroup END

" }}}

" {{{ Local / Config chainload

"
" todo: update desc.
"
" In case I have some confidential config parts or overwrites, that I don't
" want to put in the repoository for some reason, I will add my usual
" chainload structures.
"
" Configs that will be included if available (in this order):
" * $HOME/.vimrc.local
" * $HOME/.vim/vimrc.local
" * $HOME/.private/vimrc
" * $HOME/.work/vimrc
"
" Be aware that there is also an actively loaded plugin directory that is
" untracked in the repo. Use it to store local private plugins, plugins that
" you still evaluate and it is also nice to have while developing plugins
" yourself.
"
" Untracked plugin directory:
" * plugins/local/
"

for custom_dir in g:custom_config_dirs
    for custom_config in g:custom_config_files
        if (custom_dir ==# '.vim' || custom_dir ==# '.' ) &&
            \ (custom_config ==# 'vimrc' || custom_config ==# '.vimrc' )
            continue
        endif

        if filereadable(expand("~/" . custom_dir . "/" . custom_config))
            source "~/" . custom_dir . "/" . custom_config
        endif
    endfor
endfor

" }}}

" vim: set tw=80 ft=vim fdm=marker
