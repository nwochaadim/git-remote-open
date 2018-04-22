runtime! plugin/git-remote-open.vim

" Be able to access script functions in test
call vspec#hint({'sid': 'SID()'})

describe 's:strip_new_lines'
  it 'strips new lines from any given string'
    Expect Call('s:strip_new_lines', "\nrandom text\n") ==? 'random text'
  end
end

describe 's:get_github_lines'
  context 'when numbers are different'
    it 'dashes the line numbers'
      let b:line1 = 1
      let b:line2 = 2

      Expect Call('s:get_github_lines') ==# '1-L2'
    end
  end

  context 'when numbers are the same'
    it 'returns a line number'
      let b:line1 = 2
      let b:line2 = 2

      Expect Call('s:get_github_lines') ==# 2
    end
  end
end

describe 's:get_bitbucket_lines'
  context 'when numbers are different'
    it 'dashes the line numbers'
      let b:line1 = 1
      let b:line2 = 2

      Expect Call('s:get_bitbucket_lines') ==# '1:2'
    end
  end

  context 'when numbers are the same'
    it 'returns a line number'
      let b:line1 = 2
      let b:line2 = 2

      Expect Call('s:get_bitbucket_lines') ==# 2
    end
  end
end

describe 's:clean_up_remote_url'
  it 'strips .git from provided url'
    Expect Call('s:clean_up_remote_url', "http://remote-url.git\n") ==?
          \ 'http://remote-url'
  end
end

describe 's:is_bitbucket'
  context 'when bitbucket'
    it 'returns true'
      Expect Call('s:is_bitbucket', 'https://bitbucket.org/jon/jon') to_be_true
    end
  end

  context 'when github'
    it 'returns false'
      Expect Call('s:is_bitbucket', 'https://github.com/jon/jon') to_be_false
    end
  end
end

describe 's:is_github'
  context 'when github'
    it 'returns true'
      Expect Call('s:is_github', 'https://github.com/jon/jon') to_be_true
    end
  end

  context 'when not github'
    it 'returns false'
      Expect Call('s:is_github', 'https://bitbucket.org/jon/jon') to_be_false
    end
  end
end

describe 'mappings'
  context 'normal mode'
    it 'has a default plug OpenRemoteUrl mapping'
      Expect maparg('<leader>gto', 'n') ==# '<Plug>OpenRemoteUrl'
    end

    it 'has a default plug CopyRemoteUrl mapping'
      Expect maparg('<leader>gtc', 'n') ==# '<Plug>CopyRemoteUrl'
    end
  end

  context 'visual mode'
    it 'has a default plug OpenRemoteUrl mapping'
      Expect maparg('<leader>gto', 'v') ==# '<Plug>OpenRemoteUrl'
    end

    it 'has a default plug CopyRemoteUrl mapping'
      Expect maparg('<leader>gtc', 'v') ==# '<Plug>CopyRemoteUrl'
    end
  end
end

describe 's:is_git_repo'
  context 'when github repo'
    it 'returns true'
      Expect Call('s:is_git_repo', 'https://github.com') to_be_true
    end
  end

  context 'when bitbucket repo'
    it 'returns false'
      Expect Call('s:is_git_repo', 'https://bitbucket.org') to_be_true
    end
  end

  context 'when not git repo'
    it 'returns false'
      Expect Call('s:is_git_repo', 'Fatal') to_be_false
    do
  end
end
