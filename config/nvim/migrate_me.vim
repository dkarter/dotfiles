" =====================================
" ------------ NOTICE -----------------
" =====================================
" Old vimrc config.. nothing should be
" added here anymore, instead it should
" be added to the new lua configuration.
"
" Eventually this file will go away...
" =====================================

"  Plugin Configuration (BEFORE loading bundles) {{{

" =====================================
"  FZF
" =====================================
let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --color=always -E .git --ignore-file ~/.gitignore'
let $FZF_DEFAULT_OPTS='--ansi --layout=reverse'
let g:fzf_files_options = '--preview "(bat --color \"always\" --line-range 0:100 {} || head -'.&lines.' {})"'

autocmd! FileType fzf
autocmd  FileType fzf set noshowmode noruler nonu

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

command! -bang -nargs=* FzfRg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

nnoremap <silent> <C-g>g :FzfRg!<CR>
nnoremap <silent> <C-t> :BTags<CR>


" Custom FZF commands ----------------------------- {{{

 " ------  JUMP TO GIT CONFLICTS (Gconflict) ------- {{{
    fun! s:jump_to_first_conflict(file_path)
      execute 'silent e ' . a:file_path
      :call search('^<<<')
    endfun

    fun! s:gconflict_preview_cmd()
      let l:first_conflict_line_num = "rg -I -n -m1 '^<<<<' {} | cut -f1 -d ':'"
      let l:line_range = '--line-range \"\$(' . l:first_conflict_line_num . '):\"'
      let l:bat_cmd = 'bat --color \"always\" ' . l:line_range . ' {}'
      return '--preview "' . l:bat_cmd . '"'
    endfun


    command! Gconflict call fzf#run(
          \ {
          \ 'source': "rg -l --hidden '^(<<<|===|>>>)'",
          \ 'sink': function('<sid>jump_to_first_conflict'),
          \ 'options': '-m '. s:gconflict_preview_cmd(),
          \ 'window': { 'width': 0.9, 'height': 0.6 }
          \ })

    nmap <leader>gc :Gconflict<CR>
 " ------  /JUMP TO GIT CONFLICTS (Gconflict) ------- }}}
" --------------------------------------------------}}}

" ----------------------------------------------------- }}}

" UI Customizations {{{

  " Make it obvious where 80 characters is
  " cheatsheet https://jonasjacek.github.io/colors/
  fun! SetColorColumn(active)
    if a:active
      highlight ColorColumn ctermbg=236 guibg=#303030
      " let &colorcolumn=join(range(100,999),',')
      "
      " highlight one column after 'textwidth'
      set cc=+1
    else
      highlight ColorColumn guibg=#272c35
    endif
  endfun

  call SetColorColumn(1)

  " solid window border requires FuraCode Nerd Font
  set fillchars+=vert:│

  " hide vertical split
  hi vertsplit guifg=fg guibg=bg
"  }}}


" Elixir mix.exs (requires plugin: lucidstack/hex.vim)
augroup MixExsGx
  autocmd!
  autocmd BufRead,BufNewFile mix.exs nnoremap <buffer> <silent> gx :HexOpenHexDocs<cr>
  autocmd BufRead,BufNewFile mix.exs nnoremap <buffer> <silent> gh :HexOpenGithub<cr>
augroup END
" }}}
