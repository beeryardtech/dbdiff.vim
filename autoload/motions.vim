"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim:ft=vim:
" Author: Travis Goldie
" Description: Plugin for diff'ing different revisions of a file on
"              the dropbox service.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"if exists("g:dbdiff_autoload_motions_loaded")
    "finish
"endif
let g:dbdiff_autoload_motions_loaded = 1

if !has('python')
    echoerr "Python is required! You must compile VIM with Python!"
    finish
endif

" Function: s:DBDiffMotion() function {{{2
"" Updates internal pointer when user moves up
"Returns:
"" 1 If successful, 0 otherwise
function! s:DBDiffMotionUp()

endfunction

