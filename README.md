# Git Remote Open
Open/copy the current line or a selection of lines on github/bitbucket directly from vim

# Usage
Git remote open provides default mappings which can be overriden.

Here are the default mappings:

- `<leader>gtc` => copy remote url of current line / selection of lines to vim. Works in normal or visual mode

- `<leader>gto` => open remote url of current line / selection of lines in browser. Works for visual or normal mode

# Platform Support
Currently this plugin supports the following platforms:
- Windows
- Mac
- Linux

Is your platform not supported yet? open an issue to let me know

# Dependencies

This plugin has no dependency. Just install and use :). See installation instructions below

## Define your own mappings
Git remote open provides an easy interface to define your own mappings via Plug

### "OpenRemoteUrl" mapping
```
nmap [your mapping] <Plug>OpenRemoteUrl
vmap [your mapping] <Plug>OpenRemoteUrl
```

### "CopyRemoteUrl" mapping

```
nmap [your mapping] <Plug>CopyRemoteUrl
vmap [your mapping] <Plug>CopyRemoteUrl
```

# Installation
This plugin is both vundle and pathogen compatible. I recommend using vundle

Add the following to your `.vimrc` and then run `:PluginInstall` from within vim:

```
call vundle#begin()
" ...
Plugin 'nwochaadim/git-remote-open'
" ...
call vundle#end()
```
