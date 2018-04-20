if exists('g:loaded_git_remote_open')
  finish
endif
let g:loaded_git_remote_open = 1

" Provide access to script functions
function! SID()
  return maparg('<SID>', 'n')
endfunction
nnoremap <SID>  <SID>

function! s:stripnewlines(str)
  return substitute(a:str, '\n', '', 'g')
endfunction

function! s:get_github_lines()
  if b:line1 ==# b:line2
    return b:line1
  else
    return b:line1 . '-L' . b:line2
  endif
endfunction

function! s:get_bitbucket_lines()
  if b:line1 ==# b:line2
    return b:line1
  else
    return b:line1 . ':' . b:line2
  endif
endfunction

function! s:getcurrentfilepath()
  return <SID>stripnewlines(expand('%p:.'))
endfunction

function! s:get_current_filename()
  return <SID>stripnewlines(expand('%:t'))
endfunction

function! s:cleanupremoteurl(giturl)
  let remoteurl =  substitute(a:giturl, '\.git', '', '')
  return <SID>stripnewlines(remoteurl)
endfunction

function! s:getoriginurl()
  if !exists('g:remote')
    let g:remote = 'origin'
  endif

  let execcmd = 'git remote get-url ' . g:remote
  let remoteurl = system(execcmd)
  return <SID>cleanupremoteurl(remoteurl)
endfunction

function! s:isgithub(remote_url)
  return a:remote_url =~ 'github'
endfunction

function! s:isbitbucket(remote_url)
  return a:remote_url =~ 'bitbucket'
endfunction

function! s:getcurrentbranch()
  if !exists('g:branch')
    let branch = system('git rev-parse --abbrev-ref HEAD')
    let g:branch = <SID>stripnewlines(branch)
  endif

  return g:branch
endfunction

function! s:getcommithead()
  let commit_head = system('git rev-parse HEAD')
  return <SID>stripnewlines(commit_head)
endfunction

function! s:github_full_remote_url(origin_url)
  let fullremoteurl = a:origin_url . '/blob/' .
        \ <SID>getcurrentbranch() . '/' . <SID>getcurrentfilepath() .
        \ '\#L' . <SID>get_github_lines()
  return fullremoteurl
endfunction

function! s:bitbucket_full_remote_url(origin_url)
  let fullremoteurl = a:origin_url . '/src/' . <SID>getcommithead() .
        \ '/' . <SID>getcurrentfilepath() . '?at=' . <SID>getcurrentbranch()
        \ . '\#' . <SID>get_current_filename() . '-' .
        \ <SID>get_bitbucket_lines()
  return fullremoteurl
endfunction

function! s:getremoteurl()
  let origin_url = <SID>getoriginurl()
  if s:isgithub(origin_url)
    return <SID>github_full_remote_url(origin_url)
  elseif s:isbitbucket(origin_url)
    return <SID>bitbucket_full_remote_url(origin_url)
  else
    execute 'normal \<Esc>'
    throw 'Remote ' . origin_url . ' not supported'
  endif
endfunction

function! s:openremoteurl(line1, line2) abort
  let b:line1 = a:line1
  let b:line2 = a:line2
  silent! execute  '!' . oscommands#OpenCommand() . ' ' .
        \ shellescape(s:getremoteurl()) | redraw!
endfunction

function! s:copyremoteurl(line1, line2) abort
  let b:line1 = a:line1
  let b:line2 = a:line2
  let copy_command = substitute(s:getremoteurl(), '\', '', 'g')

  silent! call system(oscommands#CopyCommand(), copy_command)
  echo 'Copied url to Clipboard!'
endfunction

command! -range OpenRemoteUrl call s:openremoteurl(<line1>, <line2>)
command! -range CopyRemoteUrl call s:copyremoteurl(<line1>, <line2>)

nnoremap <Plug>OpenRemoteUrl :OpenRemoteUrl<CR>
vnoremap <Plug>OpenRemoteUrl :OpenRemoteUrl<CR>

nnoremap <Plug>CopyRemoteUrl :CopyRemoteUrl<CR>
vnoremap <Plug>CopyRemoteUrl :CopyRemoteUrl<CR>

if !hasmapto('<Plug>OpenRemoteUrl', 'n') || maparg('<leader>gto', 'n') ==# ''
  nmap <leader>gto <Plug>OpenRemoteUrl
endif

if !hasmapto('<Plug>OpenRemoteUrl', 'v') || maparg('<leader>gto', 'v') ==# ''
  vmap <leader>gto <Plug>OpenRemoteUrl
endif

if !hasmapto('<Plug>CopyRemoteUrl', 'n') || maparg('<leader>gtc', 'n') ==# ''
  nmap <leader>gtc <Plug>CopyRemoteUrl
endif

if !hasmapto('<Plug>CopyRemoteUrl', 'v') || maparg('<leader>gtc', 'v') ==# ''
  vmap <leader>gtc <Plug>CopyRemoteUrl
endif
