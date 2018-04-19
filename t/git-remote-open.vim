runtime! plugin/git-remote-open.vim

" Be able to access script functions in test
call vspec#hint({'sid': 'SID()'})

describe 's:stripnewlines'
  it 'strips new lines from any given string'
    Expect Call('s:stripnewlines', "\nrandom text\n") ==? 'random text'
  end
end

