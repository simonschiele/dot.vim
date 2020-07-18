
let s:myLang = 0
let s:myLangList = ['nospell', 'en', 'de']

function! functions#SpellToggle()
  let s:myLang = s:myLang + 1
  if s:myLang >= len(s:myLangList) | let s:myLang = 0 | endif

  if s:myLang == 0
      setlocal nospell
  else
      let &l:spelllang = s:myLangList[s:myLang]
      setlocal spell
  endif

  echomsg 'spell language:' s:myLangList[s:myLang]
endfunction
