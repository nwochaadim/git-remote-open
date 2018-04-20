runtime! plugin/git-remote-open.vim

" Be able to access script functions in test
call vspec#hint({'sid': 'SID()'})

describe 's:stripnewlines'
  it 'strips new lines from any given string'
    Expect Call('s:stripnewlines', "\nrandom text\n") ==? 'random text'
  end
end

describe 's:getlines'
  context 'when numbers are different'
    it 'dashes the line numbers'
      let b:line1 = 1
      let b:line2 = 2

      Expect Call('s:getlines') ==# '1-L2'
    end
  end

  context 'when numbers are the same'
    it 'returns a line number'
      let b:line1 = 2
      let b:line2 = 2

      Expect Call('s:getlines') ==# 2
    end
  end
end

describe 's:cleanupremoteurl'
  it 'strips .git from provided url'
    Expect Call('s:cleanupremoteurl', "http://remote-url.git\n") ==?
          \ 'http://remote-url'
  end
end

