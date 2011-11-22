" Vim global plugin for 
" Last Change:  
" Maintainer: Jakub Mrowiec, Alkagar
" Contact: alkagar@gmail.com
" License: This file is placed in the public domain.
let s:pluginName = "snippit"
let s:pluginVersion = "0.1"
let s:snippitDirectory = "/home/alkagar/repos/templates"
let s:listPosition = 1

" check if plugin was loaded earlier
if exists("g:loaded_snippit")
    finish
endif
let g:loaded_snippit = 1

" defining basic mapping
if !hasmapto('<Plug>SnippitOpenTab')
    map <unique>                  <Leader>s                       <Plug>SnippitOpenTab
endif
    
noremap <unique> <script>         <Plug>SnippitOpenTab        :Snippit<CR>

function! s:OpenTab()
    execute ":new"
    setlocal buftype=nofile
    setlocal modifiable
    call <SID>CreateSelectorHeader()
    let templateList = split(system("ls " . s:snippitDirectory), "\n")
    let lineCount = 2 
    for singleFile in templateList
        call setline(lineCount, singleFile)
        let lineCount += 1
    endfor
    setlocal nomodifiable
    nnoremap <buffer> <silent>      q                               :call <SID>Close()<CR>
    nnoremap <buffer> <silent>      <cr>                            :call <SID>GetSnippet()<CR>
endfunction

function! s:GetSnippet()
    "get file name
    let s:snippetFile = getline(".")
    "if trying get header don't do anything
    if (s:snippetFile < s:listPosition)
        return
    endif
    "get file content
    let s:snippitContent = split(system("cat " . s:snippitDirectory . "/" . s:snippetFile), "\n")
    "close scratch windows
    call s:Close()
    "set current line
    let s:previousCursorPosition = line('.')
    "print file content starting with current line
    for s:contentLine in s:snippitContent
        let s:newLine = s:previousCursorPosition . "G"
        execute "normal " . s:newLine . "i\<CR>\<ESC>k"
        call setline(s:previousCursorPosition, s:contentLine)
        let s:previousCursorPosition += 1
    endfor
endfunction

function! s:Close()
    execute ":q"
endfunction

function! s:CreateSelectorHeader()
        call setline(1, s:pluginName . " version " . s:pluginVersion)
        let s:listPosition += 1 
endfunction

if !exists(":Snippit")
    command -nargs=0    Snippit     :call <SID>OpenTab()
endif


