runtime! plugin/git-remote-open.vim

" Be able to access script functions in test
call vspec#hint({'sid': 'SID()'})

describe 's:stripnewlines'
  it 'strips new lines from any given string'
    Expect Call('s:stripnewlines', "\nrandom text\n") ==? 'random text'
  end
end

describe 's:getcurentline'
  before
    new
    put! = "New line"
  end

  after
    close!
  end

  it 'retrieves the current line and removes new lines from it'
    normal! gg
    Expect Call('s:getcurrentline') ==? '1'
  end
end

describe 's:cleanupremoteurl'
  it 'strips .git from provided url'
    Expect Call('s:cleanupremoteurl', "http://remote-url.git\n") ==?
          \ 'http://remote-url'
  end
end

