" Provide access to script functions
function! SID()
  return maparg('<SID>', 'n')
endfunction
nnoremap <SID>  <SID>

function! s:stripnewlines(str)
  return substitute(a:str, '\n', '', 'g')
endfunction

function! s:getcurrentline()
  return <SID>stripnewlines(line('.'))
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
        \ <SID>getcurrentbranch() . '\#L' . <SID>getcurrentline()
  return fullremoteurl
endfunction

