" Vim global plugin for 
" Last Change:  
" Maintainer:   
" License: This file is placed in the public domain.
let s:pluginName = "snippit"
let s:pluginVersion = "0.1"
let s:snippetDirectory = "/home/alkagar/repos/templates/"

" check if plugin was loaded earlier
if exists("g:loaded_snippit")
    finish
endif
let g:loaded_snippit = 1

" defining basic mapping
if !hasmapto('<Plug>SnippitOpenTab')
    map <unique>                  <Leader>s                       <Plug>SnippitOpenTab
endif
    
noremap <unique> <script>         <Plug>SnippitOpenTab        :call <SID>OpenTab()<CR>

function! s:OpenTab()
    execute ":new"
    setlocal buftype=nofile
    setlocal modifiable
    let templateList = split(system("ls /home/alkagar/repos/templates"), "\n")
    let lineCount = 1
    for singleFile in templateList
        call setline(lineCount, singleFile)
        let lineCount += 1
    endfor
    setlocal nomodifiable
    nnoremap <buffer> <silent>      q                               :call <SID>Close()<CR>
    nnoremap <buffer> <silent>      <cr>                            :call <SID>GetSnippet()<CR>
endfunction

function! s:GetSnippet()
    let s:snippetFile = getline(".")
    let s:snippetContent = split(system("cat " . s:snippetDirectory . "/" . s:snippetFile), "\n")
    call s:Close()
endfunction

function! s:Close()
    execute ":q"
    let s:currentLine = line(".")
    for s:contentLine in s:snippetContent
        call setline(s:currentLine, s:contentLine)
        let s:currentLine += 1
    endfor
endfunction

if !exists(":Snippit")
    command -nargs=0    Snippit     :call <SID>OpenTab()
endif
