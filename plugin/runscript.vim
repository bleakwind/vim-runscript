"  vim: set expandtab tabstop=4 softtabstop=4 shiftwidth=4: */
"
"  +-------------------------------------------------------------------------+
"  | $Id: runscript.vim 2026-03-22 17:50:30 Bleakwind Exp $                  |
"  +-------------------------------------------------------------------------+
"  | Copyright (c) 2008-2026 Bleakwind(Rick Wu).                             |
"  +-------------------------------------------------------------------------+
"  | This source file is runscript.vim.                                      |
"  | This source file is release under BSD license.                          |
"  +-------------------------------------------------------------------------+
"  | Author: Bleakwind(Rick Wu) <bleakwind@qq.com>                           |
"  +-------------------------------------------------------------------------+
"

if exists('g:runscript_plugin') || &compatible
    finish
endif
let g:runscript_plugin = 1

scriptencoding utf-8

let s:save_cpo = &cpoptions
set cpoptions&vim

" ============================================================================
" runscript setting
" ============================================================================
" public setting
let g:runscript_enabled     = get(g:, 'runscript_enabled', 0)
let g:runscript_inpscpt     = get(g:, 'runscript_inpscpt', '')
let g:runscript_inppath     = get(g:, 'runscript_inppath', $HOME.'/.vim/runscript')
let g:runscript_runcomm     = get(g:, 'runscript_runcomm', 'php')

" plugin variable
let s:runscript_sptscpt     = expand('<sfile>:p:h:h').'/script'
let s:runscript_sptdata     = g:runscript_inppath.'/inputdata'
let s:runscript_sptlist     = {}

" ============================================================================
" runscript detail
" g:runscript_enabled = 1
" ============================================================================
if exists('g:runscript_enabled') && g:runscript_enabled ==# 1

    " --------------------------------------------------
    " runscript#BuildScript
    " --------------------------------------------------
    function! runscript#BuildScript()
        if !isdirectory(g:runscript_inppath)
            call mkdir(g:runscript_inppath, 'p', 0777)
        endif

        let l:sptdir_list = []
        if isdirectory(s:runscript_sptscpt)
            call add(l:sptdir_list, s:runscript_sptscpt)
        endif
        if !empty(g:runscript_inpscpt) && isdirectory(g:runscript_inpscpt)
            call add(l:sptdir_list, g:runscript_inpscpt)
        endif

        for dir in l:sptdir_list
            let l:sptlist = filter(readdir(dir), 'v:val =~# ''\v^Rspt[a-z0-9_]{1,32}$\c''')
            for spt in l:sptlist
                let l:name = fnamemodify(spt, ':r')
                if l:name =~# '\v^[a-z0-9_]{1,32}$\c'
                    let s:runscript_sptlist[l:name] = dir.'/'.spt
                    execute 'command! -nargs=? '.l:name.' call runscript#ExecuteScript('.string(l:name).', <q-args>)'
                endif
            endfor
        endfor
    endfunction

    " --------------------------------------------------
    " runscript#ExecuteScript
    " --------------------------------------------------
    function! runscript#ExecuteScript(code_funname, code_param)
        if !isdirectory(g:runscript_inppath)
            call mkdir(g:runscript_inppath, 'p', 0777)
        endif
        let l:content = []
        let [l:lnum1, l:col1] = getpos("'<")[1:2]
        let [l:lnum2, l:col2] = getpos("'>")[1:2]
        if l:lnum1 > 0 && l:lnum2 > 0
            let l:content = getline(l:lnum1, l:lnum2)
            call writefile(l:content, s:runscript_sptdata, 'b')
            setlocal noshellslash
            let l:result = system(g:runscript_runcomm.' -f '.shellescape(s:runscript_sptlist[a:code_funname]).' '.shellescape(s:runscript_sptdata).' '.shellescape(a:code_param))
            setlocal shellslash<
            execute l:lnum1.','.l:lnum2.'d'
            call setpos('.', [0, l:lnum1-1, 1, 0])
            call append(line('.'), split(l:result, '[\n\r]', '1'))
        endif
    endfunction

    " --------------------------------------------------
    " runscript#ReadyComm
    " --------------------------------------------------
    function! runscript#ReadyComm(...)
        let l:prefix = 'Rspt'
        let l:movepos = strlen(l:prefix) + 1
        call setcmdpos(l:movepos)
        return l:prefix
    endfunction

    " --------------------------------------------------
    " runscript_cmd_bas
    " --------------------------------------------------
    augroup runscript_cmd_bas
        autocmd!
        autocmd VimEnter * call runscript#BuildScript()
    augroup END

endif

" ============================================================================
" Other
" ============================================================================
let &cpoptions = s:save_cpo
unlet s:save_cpo

