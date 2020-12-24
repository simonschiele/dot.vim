
function! statusline#CustomMode()
    return toupper(mode())
endfunction

function! statusline#CustomFilename()
  " todo: handle non-edit buffers better

  " readonly
  let ro = &readonly && &filetype !~# '\v(help|vimfiler|unite)' ? '[ro] ' : ''

  " filename
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[Unknown]'

  " mark filename with asterisk if file is modified
  let modified = &modified ? &modifiable ? '*' : '!*' : ' '

  return (ro . filename . modified)
endfunction

function! statusline#CustomFileinfo()
    " todo: size (warnings)
    " todo: handle 'file not existing'
    let fileinfo = ""
    let next_seperator = ""

    if &fileformat !=# 'unix'
        let fileinfo .= next_seperator . &fileformat
        let next_seperator = " | "
    endif

    if &fenc !=# 'utf-8'
        let fileinfo .= next_seperator . &fenc
        let next_seperator = " | "
    endif

    if &filetype !=# ''
        let fileinfo .= next_seperator . &filetype
        let next_seperator = " | "
    endif

    return fileinfo
endfunction

function! statusline#CustomLineinfo()
    return col('.') . ' ' . line('.') . '/' . line('$')
endfunction

function! statusline#CustomGitinfo()
    let branch = FugitiveHead()
    if branch !=# 'master' && branch !=# 'main'
        return branch
    else
        return ''
    endif
endfunction

function! CustomCall(...)
    if a:0 < 1
        return ''
    endif

    let out=execute('call ' . a:1)

    if strchars(out) > 0
        return '┤ ' . out . ' ├'
    else
        return ''
    endif
endfunction

function! statusline#CustomInactiveStatusline(...)
    if a:0 > 0
        let l:real_win=a:1
    else
        let l:real_win=0
    endif

    let statusline='─'
    let statusline.=repeat('─', 6)
    let statusline.='┤  ' . statusline#CustomFilename() . ' ├'
    let statusline.=repeat('─', (winwidth(l:real_win) - strchars(statusline)))
    return statusline
endfunction

function! statusline#CustomActiveStatusline()
    let l:cmode=statusline#CustomMode()
    let l:cfile=statusline#CustomFilename()
    let l:cfileinfo=statusline#CustomFileinfo()
    let l:clineinfo=statusline#CustomLineinfo()

    let statusline='─'

    if strlen(l:cmode) > 0
        let statusline.='┤ ' . l:cmode . ' ├─'
    endif

    let statusline.='┤  ' . l:cfile . ' ├─'

    if strlen(l:cfileinfo) > 0
        let statusline.='┤ ' . l:cfileinfo . ' ├─'
    endif

    if strlen(l:clineinfo) > 0
        let statusline.='┤ ' . l:clineinfo . ' ├─'
    endif

    let statusline.=repeat('─', (winwidth(0) - strchars(statusline)))
    return statusline
endfunction

" make other plugins behave:
let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

" }}}
