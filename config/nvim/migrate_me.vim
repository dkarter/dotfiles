" =====================================
" ------------ NOTICE -----------------
" =====================================
" Old vimrc config.. nothing should be
" added here anymore, instead it should
" be added to the new lua configuration.
"
" Eventually this file will go away...
" =====================================

" General settings {{{
 scriptencoding utf-16      " allow emojis in vimrc
 " TODO: currently exists in both vimrc and options.lua, this is due to feline
 " and bufferline requiring this option to be set and messing up the
 " colorscheme if it's not..
 set termguicolors
" }}}

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

" Own commands {{{
" put result of fd command into quickfix list
command! -bar -bang -complete=file -nargs=+ Cfd exe s:Grep(<q-bang>, <q-args>, 'fd', '')
function! s:Grep(bang, args, prg, type) abort
  let grepprg = &l:grepprg
  let grepformat = &l:grepformat
  let shellpipe = &shellpipe
  try
    let &l:grepprg = a:prg
    setlocal grepformat=%f
    if &shellpipe ==# '2>&1| tee' || &shellpipe ==# '|& tee'
      let &shellpipe = "| tee"
    endif
    execute 'silent '.a:type.'grep! '.a:args
    if empty(a:bang) && !empty(getqflist())
      return 'cfirst'
    else
      return ''
    endif
  finally
    let &l:grepprg = grepprg
    let &l:grepformat = grepformat
    let &shellpipe = shellpipe
  endtry
endfunction
nnoremap <expr> <leader>fd ':Cfd '
" }}}

" Vim Script file settings {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Abbreviations {{{
augroup DebuggerBrevs
  autocmd!
  autocmd FileType ruby,eruby iabbrev <buffer> bpry require 'pry'; binding.pry;
  autocmd FileType javascript iabbrev <buffer> bpry debugger;
  autocmd FileType elixir iabbrev <buffer> bpry require IEx; IEx.pry;
  autocmd FileType elixir iabbrev <buffer> ipry require IEx; IEx.pry;
augroup END
" -------- Abbreviations ---------------------------------- }}}

" For NeoVim {{{
  " use neovim-remote (pip3 install neovim-remote) allows
  " opening a new split inside neovim instead of nesting
  " neovim processes for git commit
    let $VISUAL      = 'nvr -cc split --remote-wait +"setlocal bufhidden=delete"'
    let $GIT_EDITOR  = 'nvr -cc split --remote-wait +"setlocal bufhidden=delete"'
    let $EDITOR      = 'nvr -l'
    let $ECTO_EDITOR = 'nvr -l'



" }}}

" gx extensions {{{
" For VimPlug
function! PlugGx()
  let l:line = getline('.')
  let l:name = matchlist(l:line, '\v[A-Za-z0-9\-_\.]+\/[A-Za-z0-9\-_\.]+')[0]
  let l:url  = 'https://github.com/'.l:name
  call netrw#BrowseX(l:url, 0)
endfunction

augroup PlugGxGroup
  autocmd!
  autocmd BufRead,BufNewFile plugins.lua nnoremap <buffer> <silent> gx :call PlugGx()<cr>
augroup END

" JavaScript package.json
function! PackageJsonGx() abort
  let l:line = getline('.')
  let l:package = matchlist(l:line, '\v"(.*)": "(.*)"')

  if len(l:package) > 0
    let l:package_name = l:package[1]
    let l:url = 'https://www.npmjs.com/package/' . l:package_name
    call netrw#BrowseX(l:url, 0)
  endif
endfunction

augroup PackageJsonGx
  autocmd!
  autocmd BufRead,BufNewFile package.json nnoremap <buffer> <silent> gx :call PackageJsonGx()<cr>
augroup END

" Elixir mix.exs (requires plugin: lucidstack/hex.vim)
augroup MixExsGx
  autocmd!
  autocmd BufRead,BufNewFile mix.exs nnoremap <buffer> <silent> gx :HexOpenHexDocs<cr>
  autocmd BufRead,BufNewFile mix.exs nnoremap <buffer> <silent> gh :HexOpenGithub<cr>
augroup END
" }}}

" Temporary {{{

" testing for bullets.vim
nnoremap <leader>m :vs test.md<cr>
nnoremap <leader>q :q!<cr>

"}}}