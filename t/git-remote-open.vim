runtime! plugin/git-remote-open.vim

" Be able to access script functions in test
call vspec#hint({'sid': 'SID()'})

describe 's:stripnewlines'
  it 'strips new lines from any given string'
    Expect Call('s:stripnewlines', "\nrandom text\n") ==? 'random text'
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

describe 's:cleanupremoteurl'
  it 'strips .git from provided url'
    Expect Call('s:cleanupremoteurl', "http://remote-url.git\n") ==?
          \ 'http://remote-url'
  end
end

describe 's:isbitbucket'
  context 'when bitbucket'
    it 'returns true'
      Expect Call('s:isbitbucket', 'https://bitbucket.org/jon/jon') to_be_true
    end
  end

  context 'when github'
    it 'returns false'
      Expect Call('s:isbitbucket', 'https://github.com/jon/jon') to_be_false
    end
  end
end

describe 's:isgithub'
  context 'when github'
    it 'returns true'
      Expect Call('s:isgithub', 'https://github.com/jon/jon') to_be_true
    end
  end

  context 'when not github'
    it 'returns false'
      Expect Call('s:isgithub', 'https://bitbucket.org/jon/jon') to_be_false
    end
  end
end
