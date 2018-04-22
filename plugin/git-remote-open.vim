if exists('g:loaded_git_remote_open')
  finish
endif
let g:loaded_git_remote_open = 1

" Provide access to script functions
function! SID()
  return maparg('<SID>', 'n')
endfunction
nnoremap <SID>  <SID>

function! s:strip_new_lines(str)
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

function! s:get_current_file_path()
  return <SID>strip_new_lines(expand('%p:.'))
endfunction

function! s:get_current_filename()
  return <SID>strip_new_lines(expand('%:t'))
endfunction

function! s:clean_up_remote_url(giturl)
  let remoteurl =  substitute(a:giturl, '\.git', '', '')
  return <SID>strip_new_lines(remoteurl)
endfunction

function! s:is_git_repo(remote_url)
  return a:remote_url =~ 'github\|bitbucket'
endfunction

function! s:get_origin_url()
  if !exists('g:remote')
    let g:remote = 'origin'
  endif

  let execcmd = 'git remote get-url ' . g:remote
  let remoteurl = system(execcmd)
  if <SID>is_git_repo(remoteurl)
    return <SID>clean_up_remote_url(remoteurl)
  else
    execute 'normal \<Esc>'
    throw 'Error: Not a git repo. git-remote-open can only be used inside
          \ a git repo'
  endif
endfunction

function! s:is_github(remote_url)
  return a:remote_url =~ 'github'
endfunction

function! s:is_bitbucket(remote_url)
  return a:remote_url =~ 'bitbucket'
endfunction

function! s:get_current_branch()
  if !exists('g:branch')
    let branch = system('git rev-parse --abbrev-ref HEAD')
    let g:branch = <SID>strip_new_lines(branch)
  endif

  return g:branch
endfunction

function! s:get_commit_head()
  let commit_head = system('git rev-parse HEAD')
  return <SID>strip_new_lines(commit_head)
endfunction

function! s:github_full_remote_url(origin_url)
  let fullremoteurl = a:origin_url . '/blob/' .
        \ <SID>get_current_branch() . '/' . <SID>get_current_file_path() .
        \ '\#L' . <SID>get_github_lines()
  return fullremoteurl
endfunction

function! s:bitbucket_full_remote_url(origin_url)
  let fullremoteurl = a:origin_url . '/src/' . <SID>get_commit_head() .
        \ '/' . <SID>get_current_file_path() . '?at=' . <SID>get_current_branch()
        \ . '\#' . <SID>get_current_filename() . '-' .
        \ <SID>get_bitbucket_lines()
  return fullremoteurl
endfunction

function! s:get_remote_url()
  let origin_url = <SID>get_origin_url()
  if s:is_github(origin_url)
    return <SID>github_full_remote_url(origin_url)
  elseif s:is_bitbucket(origin_url)
    return <SID>bitbucket_full_remote_url(origin_url)
  else
    execute 'normal \<Esc>'
    throw 'Remote ' . origin_url . ' not supported'
  endif
endfunction

function! s:exit_plugin(error_msg)
  echohl ErrorMsg | echom a:error_msg | echohl None
endfunction

function! s:process_command(command_ref)
  try
    let remote_url = <SID>get_remote_url()
    call a:command_ref(remote_url)
  catch /^Error/
    call <SID>exit_plugin(v:exception)
  endtry
endfunction

function! s:process_open_command(remote_url)
  silent! execute  '!' . oscommands#open_command() . ' ' .
        \ shellescape(a:remote_url) | redraw!
endfunction

function! s:process_copy_command(remote_url)
  let stripped_remote_url = substitute(a:remote_url, '\', '', 'g')
  silent! call system(oscommands#copy_command(), stripped_remote_url)
  echo 'Copied url to Clipboard!'
endfunction

function! s:open_remote_url(line1, line2) abort
  let b:line1 = a:line1
  let b:line2 = a:line2
  call <SID>process_command(function("s:process_open_command"))
endfunction

function! s:copy_remote_url(line1, line2) abort
  let b:line1 = a:line1
  let b:line2 = a:line2
  call <SID>process_command(function("s:process_copy_command"))
endfunction

command! -range OpenRemoteUrl call s:open_remote_url(<line1>, <line2>)
command! -range CopyRemoteUrl call s:copy_remote_url(<line1>, <line2>)

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
