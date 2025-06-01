# vim-runscript

## RunScript processing text through custom script commands...
Runscript is a Vim plugin that allows you to execute script files and process text content through custom commands.

## Features
- Automatically scans script directory and registers available scripts
- Supports text selection processing
- Supports parameter passing and result insertion

## Screenshot
![Runscript Screenshot](https://github.com/bleakwind/vim-runscript/blob/main/vim-runscript.gif)

## Requirements
Recommended Vim 8.1+

## Installation
```vim
" Using Vundle
Plugin 'bleakwind/vim-runscript'
```

And Run:
```vim
:PluginInstall
```

## Configuration
Add these to your `.vimrc`:
```vim
" Set 1 enable runscript (default: 0)
let g:runscript_enabled = 1
" Set runscript inputdata place (default: $HOME.'/.vim/runscript')
let g:runscript_setpath = g:config_dir_data.'runscript'
" Set runscript command (default: php)
let g:runscript_runcomm = 'php -d html_errors=0'
```
Put these to your `.vimrc` for quick access:
```vim
map  <Leader>r :<C-\>erunscript#ReadyComm()<CR>
vmap <Leader>r :<C-\>erunscript#ReadyComm()<CR>
```

## Usage
- Select text in visual mode
- Press `<Leader>r`, and press `tab` select command and runscript
- Selected text will be replaced with script output

## License
BSD 2-Clause - See LICENSE file
