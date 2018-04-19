runtime! plugin/autoload/oscommands.vim

describe 'oscommands#OpenCommand'
  it 'returns the right open command for linux'
    let g:currentos = 'linux'

    Expect oscommands#OpenCommand() ==# 'xdg-open'
  end
end
