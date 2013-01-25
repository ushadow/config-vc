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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Trims excess newlines from the end of the buffer.  Also adds a newline if the
" last line doesn't have one.
function! TrimNewlines ()
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
function! TrimEOLSpaces ()
    :%s/\s\+$//eg
endfunction

function! MarkCurrPos ()
  " mark the curr position, as well as the first visible character on that
  " line. We need the latter because certain sorts of window decorations (eg:
  " 'number') can cause the first position to be non-zero.
  normal! mzg0my

  " remember the marked position wrt the screen
  let s:marked_col_on_screen = wincol()
  let s:marked_line_on_screen = winline()
endfunction

function! RestorePos ()
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
function! ConditionallyTrimNewlines ()
  if &ft == 'cpp' || &ft == 'c' || &ft == 'java' || &ft == 'python' || &ft == 'make'
    if match(getline('$'), '^\s*$') >= 0
      call MarkCurrPos()
      call TrimNewlines()
      call RestorePos()
    endif
  endif
endfunction

" Trim newlines at the end of certain files before saving
au BufWritePre * call ConditionallyTrimNewlines()

