"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim:ft=vim:
" Author: Travis Goldie
" Description: Plugin for diff'ing different revisions of a file on
"              the dropbox service.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"if exists("g:dbdiff_plugin_loaded")
    "finish
"endif
let g:dbdiff_plugin_loaded = 1

if !has('python')
    echoerr "Python is required! You must compile VIM with Python!"
    finish
endif

"Function: s:initVariable() function {{{2
""This function is used to initialise a given variable to a given value. The
"variable is only initialised if it does not exist prior
""
"Args:
""var: the name of the var to be initialised
"value: the value to initialise var to
""
"Returns:
""1 if the var is set, 0 otherwise
function! s:initVariable(var, value)
        if !exists(a:var)
            exec 'let ' . a:var . ' = ' . "'" . substitute(a:value, "'", "'", "g") . "'"
            return 1
        endif
        return 0
endfunction

" Auth config
call s:initVariable("g:dbdiff_config_auth_app_code", "4YBvKDqc-U0AAAAAAAE1UUo5SPVijvoH43BegDlbu8PhGe-Vjsv_PIypRZo2poiB")
call s:initVariable("g:dbdiff_config_auth_app_key", 'cr7gk84iajv0zmt')
call s:initVariable("g:dbdiff_config_auth_app_secret", "0dr7qtfcmu2glov")
call s:initVariable("g:dbdiff_config_auth_auth_token", "4YBvKDqc-U0AAAAAAAE1CJOc23_Ffp6KKUeH8Pd-A20nk06TPaC_QdxhFXDERyu1")

" System config
call s:initVariable("g:dbdiff_config_system_debug", 0)
call s:initVariable("g:dbdiff_config_system_input_disabled", 1)
call s:initVariable("g:dbdiff_config_system_buffer_type", "split")
call s:initVariable("g:dbdiff_config_system_quit", 1)
call s:initVariable("g:dbdiff_config_system_verbose", 0)

" Get current dir of this file
let s:current_dir = expand("<sfile>:p:h")

" Import the dbdiff python project into here!
python << EOP
import sys
import vim

current_dir = vim.eval("s:current_dir")

# TODO This should be removed once all the scripts are built into a single one
# Similar to way JS Files are in a web project (think bower.js)
path = "{}/../python/src/main/python/".format(current_dir)
sys.path.insert(0, path)
from libs import authutils, vimutils

try:
    config = vimutils.build_config()
    configutils.setup_logger(config)
    client, config = authutils.build_client(config)

except authutils.AuthInputDisabled as err:
    pass
EOP

"""" Define GET
function! s:DBDiffGetRun(path)
    " Expand out the path if given the path shorthand
    let b:local_file = a:path == '%' ? expand("%:p") : a:path

python << EOP
from libs import vimutils
from cli import get

get_config = vimutils.eval_var_keys({
    "local_file": "b:local_file",
    "dest": "dbdiff.vim.cp",
})
config = vimutils.build_config_with_client(get_config)
get.run(config)
EOP
endfunction
command! DBDiffGetCurr call s:DBDiffGetRun("%")
command! -nargs=1 DBDiffGet call s:DBDiffGetRun(<f-args>


"""" Define REVS
function! s:DBDiffRevsRun(path)
    " Expand out the path if given the path shorthand
    let b:local_file = a:path == '%' ? expand("%:p") : a:path

python << EOP
from libs import vimutils
from cli import revs

get_config = vimutils.eval_var_keys({
    "formatter": "hashes",
    "local_file": "b:local_file",
    "output": None,
})
config = vimutils.build_config_with_client(get_config)
output = revs.run(config)
vimutils.put_to_scratch_buffer(output, config.get("buffer_type"))
EOP
endfunction

command! DBDiffRevsCurr call s:DBDiffRevsRun("%")
command! -nargs=1 DBDiffRevs call s:DBDiffRevsRun(<f-args>)
