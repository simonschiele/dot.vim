"
" Simons Vim Config
"
" by Simon Schiele <simon.codingmonkey@gmail.com>
" last changed: 2018-09-05
"
" See README.rst for licence details, setup instructions and a general
" overview of my Vim setup.
"
" https://github.com/simonschiele/dot.vim
"

" {{{ plugin loader: pathogen

" Use pathogen to load further modules from the plugins/ directory. Most
" plugins are not directly included in this repo, but available via git
" subrepos. Since this includes pathogen itself, you need to initalize the
" subrepos before this config can work.
" Also, for some plugins, system depencies are needed. See README.rst for
" details on howto properly setup everything for this config to work.

filetype off
runtime plugins/pathogen/autoload/pathogen.vim

" Vim sessions default to capturing all global options, which includes the
" 'runtimepath' that pathogen.vim manipulates. This can cause other problems
" too, so tpope recommends turning that behavior off. "[...] though that has
" the side effect of not persisting any global options, which may or may not
" be acceptable to you"
set sessionoptions-=options

" skip loading of specific plugin
" can be also done via env variable $VIMBLACKLIST
"
" let g:pathogen_disabled = []
" call add(g:pathogen_disabled, 'YouCompleteMe')

" actually initalize pathogen with the plugin dirs
silent! call pathogen#infect('plugins/{}',
                           \ 'plugins/colors/{}',
                           \ 'plugins/local/{}',
                           \ 'plugins/syntax/{}',
                           \ 'plugins/textobj/{}')

" }}}
