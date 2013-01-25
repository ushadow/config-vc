" Installation:
" If you want syntax highlighting enabled, it's suggested that you enable it
" *before* sourcing this script by adding "syntax on" to your .vimrc
"
" Overriding Settings:
" Many of the settings are performed via autocmds/ftplugins.
" This means that you cannot override these settings just by making your own
" settings in your .vimrc (since the setting will end up triggering
" later, undoing your attempted override). If you need to override a setting the
" easiest way to do this is to create your own autocmd after sourcing.
" For example, to change textwidth to 80 for .java files:
"
"   autocmd BufNewFile,BufRead *.java setlocal textwidth=80
"
" See ":help :autocmd" for more information on how the autocmd command works.
"
"
" Disabling Optional Behavior:
" There are some optional behaviors in this file that can be turned off without
" dealing with overriding as described above. Set the following options *before*
" sourcing google.vim to disable them:
"
"   Disable autogen: let g:disable_google_boilerplate=1
"   Disable tool usage statistics logging: let g:disable_google_logging=1
"   Disable most settings changes: let g:disable_google_optional_settings=1
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Add <mydir>/runtime and <mydir>/runtime/after to appropiate places in Vim's
" runtimepath. The former is made the second element, while the latter is made
" the second to last element. This should put Google paths between the user's
" personal settings and Vim's factory settings on both the "normal" part of the
" path and the "after" part of the path.
let s:rt_before = expand('<sfile>:p:h') . '/runtime'
if has('win32') || has('win64')
  let s:rt_before = substitute(s:rt_before, '\\', '/', 'g')
endif
let s:rt_after = s:rt_before . '/after'
let &runtimepath = substitute(&runtimepath, '^\([^,]*\),\(.*\),\([^,]*\)$', '\1,' . s:rt_before . ',\2,' . s:rt_after . ',\3', '')

" This will generally be /google/src/head/depot or /home/build/public, but may
" something else (eg. a SrcFS client sync'd to a specific CL, or the base of an
" actual P4 client).
let s:base_path = expand('<sfile>:p:h:h:h')

runtime coding-style.vim
runtime google-filetypes.vim
runtime gsearch.vim
runtime gcheckstyle.vim

let &makeprg='/usr/bin/blaze build --color=no --curses=no'

let s:marked_line_on_screen = 0

" Trims excess newlines from the end of the buffer.  Also adds a newline if the
" last line doesn't have one.
function! GoogleTrimNewlines ()
  let lines = line('$')
  let done = 0
  " loop so that we can also delete trailing lines consisting of only whitespace
  while !done
    " erase last line if it's only whitespace
    %s/^\s*\%$//e

    " erase trailing blank lines
    %s/\n*\%$/\r/e
    %s/\n*\%$//e

    " if we actually did anything, assume that we have more to do
    let done = lines == line('$')
    let lines = line('$')
  endwhile
endfunction

" Trim spaces at the end of line (lint complains if they exist)
function! GoogleTrimEOLSpaces ()
    :%s/\s\+$//eg
endfunction

function! GoogleMarkCurrPos ()
  " mark the curr position, as well as the first visible character on that
  " line. We need the latter because certain sorts of window decorations (eg:
  " 'number') can cause the first position to be non-zero.
  normal! mzg0my

  " remember the marked position wrt the screen
  let s:marked_col_on_screen = wincol()
  let s:marked_line_on_screen = winline()
endfunction

function! GoogleRestorePos ()
  " jump back to the old "first character on the line", and remember offsets
  silent! normal! `y
  let col_offset = wincol() - s:marked_col_on_screen
  let line_offset = winline() - s:marked_line_on_screen

  " jump to actual marked position
  silent! normal! `z

  " scroll window to correct for offsets
  if col_offset < 0
    exe "normal! " . -col_offset . "zh"
  elseif col_offset > 0
    exe "normal! " . col_offset . "zl"
  endif
  if line_offset < 0
    exe "normal! " . -line_offset . "\<C-Y>"
  elseif line_offset > 0
    exe "normal! " . line_offset . "\<C-E>"
  endif
endfunction

" Trims newlines and at the end of the file if this is a file of an appropriate
" type.
function! GoogleConditionallyTrimNewlines ()
  if &ft == 'cpp' || &ft == 'c' || &ft == 'java' || &ft == 'python' || &ft == 'make'
    if match(getline('$'), '^\s*$') >= 0
      call GoogleMarkCurrPos()
      call GoogleTrimNewlines()
      call GoogleRestorePos()
    endif
  endif
endfunction

" Trim newlines at the end of certain files before saving
au BufWritePre * call GoogleConditionallyTrimNewlines()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" You can turn off automatic boilerplate generation by adding the
" following command to your .vimrc *before* sourcing google.vim:
"
"    let  g:disable_google_boilerplate=1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! Autogen(fnam)
  " This doesn't work on Windows, because autogen is a bash script.
  if has('win32') || has('win64')
    " TODO: Use Cygwin if it's installed.
    return
  endif

  let l:fnam = a:fnam
  if v:version > 700
    let l:fnam = shellescape(a:fnam)
  endif

  if filereadable('/usr/lib/autogen/autogen')
    exe '.!/usr/lib/autogen/autogen ' . l:fnam . ' 2>/dev/null'
  elseif filereadable(s:base_path . '/google3/devtools/editors/autogen/autogen')
    exe '.!' . s:base_path . '/google3/devtools/editors/autogen/autogen ' . l:fnam . ' 2>/dev/null'
  else
    exe '.!/home/build/public/google3/devtools/editors/autogen/autogen ' . l:fnam . ' 2>/dev/null'
  endif
  $
  silent! ?^\s*$
  normal! $
endfunction

command! Autogen call Autogen(expand('%:p'))
command! AutogenIfNew if !filereadable(expand("%")) | call Autogen(expand('%:p')) | endif

if ! exists('g:disable_google_boilerplate') || ! g:disable_google_boilerplate
  aug google_boilerplate
    autocmd!
    autocmd BufNewFile * silent! AutogenIfNew
  aug END
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" You can turn off ToolSearch logging by adding the following command to your
" .vimrc *before* sourcing google.vim:
"
"    let g:disable_google_logging=1
"
" See http://go/toolsearchlogging for more details.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Avoid vi/vim compatibility errors, which can come from unexpected places,
" such as the start with -u <vimrc>.
let s:google_cpo_save = &cpo
set cpo&vim

function! GoogleLogUsage(operation, google_vim_location)
  if executable('/usr/lib/crudd/log_usage')
    " We use the built-in python support, so ensure it's there.
    if ! has('python')
      return
    endif
    " Don't log when we open things like help files.
    if ! &buflisted
      return
    endif
" Ok, here's some rationale for this hack: Doing this in vimscript was
" essentially impossible.  Getting all of the 'silent's in place on the exe
" line, dealing with shell stdout/stderr redirection across tcsh/bash/zsh, not
" outputting the backgrounding line, etc. was impossible.
"
" How this works:
"  Start a thread (so that control can be returned to the user immediately).
"  In that thread, use python subprocess, capture both stdout and stderr, and
"    ignore them.
"
python << EOF
import subprocess
import thread
import vim
def runit(ver, ft, op, google_vim_location):
  try:
    # Proto to log
    proto = ("log_path:'vim' version:'%s' tool_type:'cmdline' "
             "disable_rate_limit: true "
             "meta_data: {key:'filetype' value:'%s'} "
             "meta_data: {key:'operation' value:'%s'} "
             "meta_data: {key:'google_vim_location' value:'%s'}"
             % (ver, ft, op, google_vim_location))
    proc = subprocess.Popen(
        ["/usr/lib/crudd/log_usage", "--tool_log_proto", proto],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = proc.communicate()
  except Exception, e:
    pass
thread.start_new_thread(
    runit,
    (vim.eval("v:version"),
     vim.eval('expand("%:e")'),
     vim.eval("a:operation"),
     vim.eval("a:google_vim_location")))
EOF
  endif
endfunction

if ! exists('g:disable_google_logging') || ! g:disable_google_logging
  aug google_logging
    autocmd!
    autocmd BufNewFile,BufReadPost * silent! call GoogleLogUsage("view", expand("<sfile>"))
    autocmd BufWritePre * silent! call GoogleLogUsage("save", expand("<sfile>"))
  aug END
endif

let &cpo = s:google_cpo_save
unlet s:google_cpo_save

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The following settings are optional, but recommended. You may wish to
" override these options in your personal .vimrc after sourcing this file.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if ! exists('g:disable_google_optional_settings') || ! g:disable_google_optional_settings
  " enables extra vim features (which break strict compatibility with vi)
  " only set if unset, since it has side effects (resetting a bunch of options)
  if &compatible
    set nocompatible
  endif

  " allows files to be open in invisible buffers
  set hidden

  " show trailing spaces in yellow (or red, for users with dark backgrounds).
  " "set nolist" to disable this.
  " this only works if syntax highlighting is enabled.
  set list
  set listchars=tab:\ \ ,trail:\ ,extends:»,precedes:«
  if &background == "dark"
    highlight SpecialKey ctermbg=Red guibg=Red
  else
    highlight SpecialKey ctermbg=Yellow guibg=Yellow
  end
  " if you would like to make tabs and trailing spaces visible without syntax
  " highlighting, use this:
  "   set listchars=tab:·\ ,trail:\·,extends:»,precedes:«

  " make backspace "more powerful"
  set backspace=indent,eol,start

  " makes tabs insert "indents" at the beginning of the line
  set smarttab

  " reasonable defaults for indentation
  set autoindent nocindent nosmartindent

  " informs sh syntax that /bin/sh is actually bash
  let is_bash=1
  " don't highlight C++ kewords as errors in Java
  let java_allow_cpp_keywords=1
  " highlight method decls in Java (when syntax on)
  let java_highlight_functions=1

  " If we're in citc, always enable this feature.
  if match($PWD, "^/google/src/cloud") != -1
    let g:enable_local_swap_dirs=1
  endif

  " Enable local swap directories.  Always enabled when on citc, but you can
  " just let g:enable_local_swap_dirs=1 before sourcing google.vim to get it all
  " the time.  I recommend it.
  if exists('g:enable_local_swap_dirs') && g:enable_local_swap_dirs
    if ! exists('g:local_swap_dir_root')
      let g:local_swap_dir_root = '/usr/local/google/tmp/vim_tmp/'
    elseif match(g:local_swap_dir_root, '/$') == -1
      " Ensure it ends with a slash.
      let g:local_swap_dir_root .= '/'
    endif

    " Ensure the base directory exists and is a+rwx and sticky.  Note that this
    " does NOT use the 'p' flag, so if dirname(g:local_swap_dir_root) doesn't
    " exist, this will fail.
    if !isdirectory(g:local_swap_dir_root)
      call mkdir(g:local_swap_dir_root, '', 01777)
    endif

    if filewritable(g:local_swap_dir_root) == 2  " If it's a directory..
      " Persistent undo is available in vim 7.3 and later.
      if has('persistent_undo')
        if !isdirectory(g:local_swap_dir_root . $LOGNAME . '/undo')
          call mkdir(g:local_swap_dir_root . $LOGNAME . '/undo', 'p', 0700)
        endif
        exec 'set undodir=' . g:local_swap_dir_root . $LOGNAME . '/undo'
        " TODO(spectral): Do I want to turn this on for everyone using vim 7.3
        " automatically..?
        " set undofile
      endif

      " This is for the normal swap files.
      if !isdirectory(g:local_swap_dir_root . $LOGNAME . '/swap')
        call mkdir(g:local_swap_dir_root . $LOGNAME . '/swap', 'p', 0700)
      endif
      exec 'set dir=' . g:local_swap_dir_root . $LOGNAME . '/swap//,.'

    endif
  endif
endif
