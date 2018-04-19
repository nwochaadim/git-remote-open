" Provide access to script functions
function! SID()
  return maparg('<SID>', 'n')
endfunction
nnoremap <SID>  <SID>

function! s:stripnewlines(str)
  return substitute(a:str, '\n', '', 'g')
endfunction

function! s:getlines()
  if b:line1 ==# b:line2
    return b:line1
  else
    return b:line1 . "-L" . b:line2
  endif
endfunction

function! s:getcurrentfilepath()
  return <SID>stripnewlines(expand("%p:."))
endfunction

function! s:cleanupremoteurl(giturl)
  let remoteurl =  substitute(a:giturl, '\.git', '', '')
  return <SID>stripnewlines(remoteurl)
endfunction

function! s:getoriginurl()
  if !exists("g:remote")
    let g:remote = "origin"
  endif

  let execcmd = "git remote get-url " . g:remote
  let remoteurl = system(execcmd)
  return <SID>cleanupremoteurl(remoteurl)
endfunction

function! s:getcurrentbranch()
  if !exists("g:branch")
    let branch = system("git rev-parse --abbrev-ref HEAD")
    let g:branch = <SID>stripnewlines(branch)
  endif

  return g:branch
endfunction

function! s:getremoteurl()
  let fullremoteurl = <SID>getoriginurl() . '/blob/' .
        \ <SID>getcurrentbranch() . '/' . <SID>getcurrentfilepath() .
        \ '\#L' . <SID>getlines()
  return fullremoteurl
endfunction

function! s:openremoteurl(line1, line2)
  let b:line1 = a:line1
  let b:line2 = a:line2

  silent! execute  "!" . oscommands#OpenCommand() . " " . s:getremoteurl()
        \ | redraw!
endfunction

function! s:copyremoteurl(line1, line2)
  let b:line1 = a:line1
  let b:line2 = a:line2

  silent! call system(oscommands#CopyCommand(), s:getremoteurl())
  echo 'Copied url to Clipboard!'
endfunction

command! -range OpenRemoteUrl call s:openremoteurl(<line1>, <line2>)
command! -range CopyRemoteUrl call s:copyremoteurl(<line1>, <line2>)

nnoremap <Plug>OpenRemoteUrl :OpenRemoteUrl<CR>
vnoremap <Plug>OpenRemoteUrl :OpenRemoteUrl<CR>

nnoremap <Plug>CopyRemoteUrl :CopyRemoteUrl<CR>
vnoremap <Plug>CopyRemoteUrl :CopyRemoteUrl<CR>
