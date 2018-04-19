let s:mac = 'mac'
let s:windows = 'windows'
let s:linux = 'linux'
let s:opencommands = {'windows': 'cmd /c start', 'mac': 'open',
      \ 'linux': 'xdg-open'}
let s:copycommands = {'windows': 'clip', 'mac': 'clip',
      \ 'linux': 'xsel --clipboard --input'}

" Thanks Chris Toomey
" https://github.com/christoomey/vim-system-copy
function! s:currentOS()
  if exists("g:currentos")
    return g:currentos
  endif

  let os = substitute(system('uname'), '\n', '', '')
  let known_os = 'unknown'
  if has("gui_mac") || os ==? 'Darwin'
    let known_os = s:mac
  elseif has("gui_win32") || os =~? 'cygwin'
    let known_os = s:windows
  elseif os ==? 'Linux'
    let known_os = s:linux
  else
    exe "normal \<Esc>"
    throw "unknown OS: " . os
  endif
  return known_os
endfunction

function! oscommands#OpenCommand()
  let currentos = <SID>currentOS()
  if !exists("g:opencommand")
    let g:opencommand = s:opencommands[currentos]
  endif

  return g:opencommand
endfunction
