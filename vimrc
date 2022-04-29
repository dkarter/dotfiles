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



imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

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
          \ 'source': "rg -l '^(<<<|===|>>>)'",
          \ 'sink': function('<sid>jump_to_first_conflict'),
          \ 'options': '-m '. s:gconflict_preview_cmd(),
          \ 'window': { 'width': 0.9, 'height': 0.6 }
          \ })

    nmap <leader>gc :Gconflict<CR>
 " ------  /JUMP TO GIT CONFLICTS (Gconflict) ------- }}}
" --------------------------------------------------}}}

" ----------------------------------------------------------------------------
" ALE
" ----------------------------------------------------------------------------
let g:airline#extensions#ale#enabled = 1
let g:ale_sign_error = ''
let g:ale_sign_warning = ''

" ALE automatically updates the loclist which makes it impossible to use some
" other plugins such as GV
let g:ale_set_loclist = 0

highlight link ALEWarningSign Directory
highlight link ALEErrorSign WarningMsg
nnoremap <silent> <leader>ne :ALENextWrap<CR>
nnoremap <silent> <leader>pe :ALEPreviousWrap<CR>

let g:ale_pattern_options = {
                        \  '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
                        \  '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
                        \}

let g:ale_fixers = {
      \   'typescript': ['prettier'],
      \   'typescript.tsx': ['prettier'],
      \   'javascript': ['prettier'],
      \   'javascript.jsx': ['prettier'],
      \   'html': ['prettier'],
      \   'json': ['prettier'],
      \   'scss': ['prettier'],
      \   'css': ['prettier'],
      \   'bash': ['shfmt'],
      \   'zsh': ['shfmt'],
      \   'ruby': ['prettier'],
      \   'yaml': ['prettier'],
      \   'rust': ['rustfmt'],
      \   'elm': ['elm-format'],
      \   'cpp': ['clang-format'],
      \   'lua': ['stylua']
      \}

let g:ale_sh_shfmt_options = '-i 2 -ci'

let g:ale_fix_on_save = 1


" ----------------------------------------------------------------------------
" goyo.vim + limelight.vim
" ----------------------------------------------------------------------------
let g:limelight_paragraph_span = 1
let g:limelight_priority = -1

" limelight colors for 'one' color scheme
let g:limelight_conceal_ctermfg = '#454d5a'
let g:limelight_conceal_guifg = '#454d5a'

let g:goyo_width = 100

function! s:goyo_enter()
  let g:background_before_goyo = &background
  let g:colorscheme_before_goyo = g:colors_name
  let g:limelight_conceal_guifg_before_goyo = g:limelight_conceal_guifg
  let g:limelight_conceal_ctermfg_before_goyo = g:limelight_conceal_ctermfg
  let g:textwidth_before_goyo = &textwidth
  let g:wrapmargin_before_goyo = &wrapmargin

  set textwidth=0
  set wrapmargin=0
  set wrap
  set nofoldenable
  set linebreak
  set background=light
  colorscheme pencil
  let g:pencil_terminal_italics = 1
  let g:limelight_conceal_guifg='#bfbfbf'
  let g:limelight_conceal_ctermfg='#bfbfbf'
  Limelight
endfunction

function! s:goyo_leave()
  execute 'Limelight!'
  execute 'set textwidth=' . g:textwidth_before_goyo
  execute 'set wrapmargin=' . g:wrapmargin_before_goyo
  execute 'set background=' . g:background_before_goyo
  execute 'colorscheme ' . g:colorscheme_before_goyo
  set nowrap
  set foldenable
  let g:limelight_conceal_guifg = g:limelight_conceal_guifg_before_goyo
  let g:limelight_conceal_ctermfg = g:limelight_conceal_ctermfg_before_goyo
endfunction

augroup GOYO
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END


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

" Text Objects {{{
augroup elixir_textobjs
  autocmd!
  autocmd FileType elixir call textobj#user#map('elixir', {
        \   'map': {
        \     'pattern': ['%{', '}'],
        \     'select-a': '<buffer> aM',
        \     'select-i': '<buffer> iM',
        \   },
        \ })
augroup END
" }}}

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

" Auto commands {{{
  augroup vimrcEx
    autocmd!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it for commit messages, when the position is invalid, or when
    " inside an event handler (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

    " Set syntax highlighting for specific file types
    autocmd BufRead,BufNewFile Appraisals,*.rabl set filetype=ruby
    autocmd BufRead,BufNewFile .babelrc set filetype=json
    autocmd BufRead,BufNewFile *.yrl set filetype=erlang
    autocmd BufRead,BufNewFile *.md set filetype=markdown
    autocmd BufRead,BufNewFile .eslintrc,.prettierrc set filetype=json

    " Enable spellchecking for Markdown
    autocmd FileType markdown setlocal spell
    " Enable line wrapping for markdown
    autocmd FileType markdown setlocal wrap
    " Break wrapped lines on space (not middle of word)
    autocmd FileType markdown setlocal linebreak
    " navigate wrapped text more naturally
    autocmd FileType markdown nmap <buffer> j gj
    autocmd FileType markdown nmap <buffer> k gk
    " Automatically wrap at 80 characters for Markdown
    autocmd FileType markdown setlocal textwidth=80

    " Automatically wrap at 72 characters and spell check git commit messages
    autocmd FileType gitcommit setlocal textwidth=72
    autocmd FileType gitcommit setlocal spell

    " Allow stylesheets to autocomplete hyphenated words
    autocmd FileType css,scss,sass setlocal iskeyword+=-

    " Vim/tmux layout rebalancing
    " automatically rebalance windows on vim resize
    autocmd VimResized * :wincmd =

    " add support for comments in json (jsonc format used as configuration for
    " many utilities)
    autocmd FileType json syntax match Comment +\/\/.\+$+

    " notify if file changed outside of vim to avoid multiple versions
    autocmd FocusGained * checktime
  augroup END

  " add operator pending mode for elixir maps - needs to support multiline map
  augroup ElixirAutoCommands
    autocmd!
    autocmd FileType elixir,eelixir let b:surround_{char2nr("m")} = '%{ \r }'
  augroup END
" }}}

" Vim Script file settings {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Key Mappings {{{

  " Allow j and k to work on visual lines (when wrapping)
    noremap <silent> <Leader>w :call ToggleWrap()<CR>
    function! ToggleWrap()
      if &wrap
        echo 'Wrap OFF'
        setlocal nowrap
        set virtualedit=all
        silent! nunmap <buffer> j
        silent! nunmap <buffer> k
      else
        echo 'Wrap ON'
        setlocal wrap linebreak nolist
        set virtualedit=
        setlocal display+=lastline
        noremap  <buffer> <silent> k   gk
        noremap  <buffer> <silent> j gj
        inoremap <buffer> <silent> <Up>   <C-o>gk
        inoremap <buffer> <silent> <Down> <C-o>gj
      endif
    endfunction

    " Zoom
    function! s:zoom()
      if winnr('$') > 1
        tab split
      elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                      \ 'index(v:val, '.bufnr('').') >= 0')) > 1
        tabclose
      endif
    endfunction
    nnoremap <silent> <leader>z :call <sid>zoom()<cr> 

" --------------------- Key Mappings ---------------------------- }}}

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

  " share data between nvim instances (registers etc)
    augroup SHADA
      autocmd!
      autocmd CursorHold,TextYankPost,FocusGained,FocusLost *
            \ if exists(':rshada') | rshada | wshada | endif
    augroup END


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
