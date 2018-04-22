runtime! plugin/autoload/oscommands.vim

describe 'oscommands#open_command'
  it 'returns the right open command for linux'
    let g:currentos = 'linux'

    Expect oscommands#open_command() ==# 'xdg-open'
  end
end

describe 'oscommands#copy_command'
  it 'returns the right os copy command'
    let g:currentos = 'linux'

    Expect oscommands#copy_command() ==# 'xsel --clipboard --input'
  end
end
