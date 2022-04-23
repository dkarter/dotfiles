"
"  ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓
"  ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒
" ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░
" ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██
" ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒
" ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░
" ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░
"    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░
"          ░    ░  ░    ░ ░        ░   ░         ░
"                                 ░
"
"         - Dorian's NeoVim Configuration -


" General settings {{{
 scriptencoding utf-16      " allow emojis in vimrc
 " TODO: currently exists in both vimrc and options.lua, this is due to feline
 " and bufferline requiring this option to be set and messing up the
 " colorscheme if it's not..
 set termguicolors
" }}}

"  Plugin Configuration (BEFORE loading bundles) {{{

" ====================================
" Floaterm
" ====================================
let g:floaterm_position = 'center'
let g:floaterm_background = '#272c35'
let g:floaterm_winblend = 10


hi FloatermNF       guibg=#272c35
hi FloatermBorderNF guibg=#272c35 guifg=white

command! -nargs=0 FT FloatermToggle

" Use 90% width for floaterm. If error occurs, update the plugin
let g:floaterm_width = 0.9
let g:floaterm_height = 0.7

function s:floatermSettings()
    call SetColorColumn(0)
endfunction

augroup FloatermCustom
  autocmd!

  autocmd FileType floaterm call s:floatermSettings()
  " <leader>h : Hide the floating terminal window
  " <leader>q : Quit the floating terminal window
  autocmd FileType floaterm tmap <buffer> <silent> <leader>q <C-\><C-n>:call SetColorColumn(1)<CR>:q<CR>
  autocmd FileType floaterm tmap <buffer> <silent> <leader>h <C-\><C-n>:call SetColorColumn(1)<CR>:hide<CR>
augroup END

nnoremap <silent> <leader>gg :FloatermNew --title='LazyGit' --autoclose=1 lazygit<CR>

" ====================================
" VimMatchUp:
" ====================================
let g:matchup_matchparen_deferred = 1

" ====================================
" WinResizer:
" ====================================
nnoremap <C-w>r :WinResizerStartResize<CR>

"" ====================================
" UndoTree:
" ====================================
nnoremap <silent> <leader>ut :UndotreeToggle<CR>

" ====================================
" COC
" ====================================

" Tell CoC where node is if it doesn't know
let current_node_path = trim(system('asdf where nodejs'))
let g:coc_node_path = current_node_path . '/bin/node'

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> go :<C-u>CocFzfList outline<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" set coc as nvim man page provider for functions
" TODO: maybe need to check if coc is enabled for file and do setlocal?
set keywordprg=:call\ CocAction('doHover')

vmap <silent> <leader>ca  :<C-u>CocFzfList actions<CR>
nmap <silent> <leader>ca  :<C-u>CocFzfList actions<CR>
nmap <silent> <leader>cd  :<C-u>CocFzfList diagnostics<CR>
nmap <silent> <leader>cb  :<C-u>CocFzfList diagnostics --current-buf<CR>
nmap <silent> <leader>cc  :<C-u>CocFzfList commands<CR>
nmap <silent> <leader>ce  :<C-u>CocFzfList extensions<CR>
nmap <silent> <leader>cl  :<C-u>CocFzfList location<CR>
nmap <silent> <leader>co  :<C-u>CocFzfList outline<CR>
nmap <silent> <leader>cs  :<C-u>CocFzfList symbols<CR>
nmap <silent> <leader>cS  :<C-u>CocFzfList services<CR>
nmap <silent> <leader>cp  :<C-u>CocFzfListResume<CR>

" ====================================
" Carbon Now Screenshots (vim-carbon-now-sh)
" ====================================
vnoremap <F5> :CarbonNowSh<CR>

" ====================================
" Neosnippet:
" ====================================

let g:neosnippet#enable_completed_snippet = 1

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
      \ pumvisible() ? "\<C-n>" :
      \ neosnippet#expandable_or_jumpable() ?
      \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"


let g:neosnippet#enable_snipmate_compatibility = 1


" ====================================
" NeoTerm:
" ====================================
let g:neoterm_repl_ruby = 'pry'
let g:neoterm_autoscroll = 1

" ====================================
" Gist:
" ====================================
map <leader>gst :Gist<cr>


" ====================================
" Vim Scriptease:
" ====================================
" Run commands that require an interactive shell
nnoremap <Leader>ri :RunInInteractiveShell<space>

" Reload current vim plugin
nnoremap <Leader>rr :Runtime<cr>

" ====================================
" CopyRTF: Copy code as RTF
" ====================================
nnoremap <silent> <leader><C-c> :set nonumber<CR>:CopyRTF<CR>:set number<CR>

" ====================================
" SplitJoin:
" ====================================
let g:splitjoin_align = 1
let g:splitjoin_trailing_comma = 1
let g:splitjoin_ruby_curly_braces = 0
let g:splitjoin_ruby_hanging_args = 0

" ====================================
" MatchTagAlways:
" ====================================
let g:mta_filetypes = {
      \ 'jinja': 1,
      \ 'xhtml': 1,
      \ 'xml': 1,
      \ 'html': 1,
      \ 'django': 1,
      \ 'javascript.jsx': 1,
      \ 'eruby': 1,
      \ }

" ====================================
" Snippets (UltiSnips):
" ====================================
let g:UltiSnipsExpandTrigger="<NUL>"
let g:UltiSnipsListSnippets="<NUL>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" :UltiSnipsEdit opens in a vertical split
let g:UltiSnipsEditSplit                   = 'vertical'
let g:UltiSnipsSnippetsDir                 = $HOME . '/dotfiles/vim/UltiSnips'


" ====================================
" setup airline
" ====================================
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'c'  : 'C',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ '' : 'V',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ '' : 'S',
      \ }

" ====================================
" Bullets.vim:
" ====================================
let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text',
    \ 'gitcommit',
    \ 'scratch'
    \]

" =====================================
" Fugitive
" =====================================
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gb :Git blame<CR>

" =====================================
"  FZF
" =====================================
let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --color=always -E .git --ignore-file ~/.gitignore'
let $FZF_DEFAULT_OPTS='--ansi --layout=reverse'
let g:fzf_files_options = '--preview "(bat --color \"always\" --line-range 0:100 {} || head -'.&lines.' {})"'

autocmd! FileType fzf
autocmd  FileType fzf set noshowmode noruler nonu

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" Do not open files inside of a NvimTree buffer
function! FZFOpen(command_str)
  if (expand('%') =~# 'NvimTree' && winnr('$') > 1)
    exe "normal! \<c-w>\<c-w>"
  endif
  exe 'normal! ' . a:command_str . "\<cr>"
endfunction

command! -bang -nargs=* FzfRg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

nnoremap <silent> <C-g>g :call FZFOpen(':FzfRg!')<CR>
nnoremap <silent> <C-t> :call FZFOpen(':BTags')<CR>

" Find files using Telescope command-line sugar.
nnoremap <silent> <C-p> <cmd>Telescope find_files<cr>
nnoremap <silent> <leader>ff <cmd>Telescope find_files<cr>

nnoremap <silent> <leader>lg <cmd>Telescope live_grep<cr>

nnoremap <silent> <C-b> <cmd>Telescope buffers<cr>
nnoremap <silent> <leader>bb <cmd>Telescope buffers<cr>

nnoremap <silent> <leader>fb <cmd>Telescope file_browser<cr>

nnoremap <silent> <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <silent> <leader>fp <cmd>Telescope packer<cr>

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

" =====================================
"  JSX
" =====================================

" Allow JSX in normal JS files
let g:jsx_ext_required = 0

" =====================================
"  Rg
" =====================================

" Grep project for selection with Rg
xnoremap <leader>gr y :Rg "<CR>
" Grep project for word under the cursor with Rg
nnoremap <Leader>gr :Rg <C-r><C-w><CR>

" Grep selection with Rg (excluding tests and migrations)
xnoremap <leader>gt y :Rg " -g '!*/**/test/*' -g '!*/**/migrations/*'<CR>
nnoremap <Leader>gt :Rg <C-r><C-w> -g '!*/**/test/*' -g '!*/**/migrations/*'<CR>

" Put cursor after :Rg command (a little faster than typing :Rg)
nnoremap <expr> <leader>rg ':Rg '

" Use RipGrep for grep https://www.wezm.net/technical/2016/09/ripgrep-with-vim/
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" ----------------------------------------------------------------------------
" vim slime
" ----------------------------------------------------------------------------
let g:slime_target='tmux'

" ----------------------------------------------------------------------------
" Scratch.vim
" ----------------------------------------------------------------------------
let g:scratch_no_mappings=1

nnoremap <leader>sc :Scratch<CR>

augroup ScratchToggle
  autocmd!
  autocmd FileType scratch nnoremap <buffer> <leader>sc :q<CR>
augroup END

" ----------------------------------------------------------------------------
" Emmet
" ----------------------------------------------------------------------------
" better emmet leader key (must be followed with ,)
let g:user_emmet_leader_key='<C-e>'

" ----------------------------------------------------------------------------
" Vim Better Whitespace
" ----------------------------------------------------------------------------
let g:better_whitespace_filetypes_blacklist = [
      \ 'startify',
      \ 'dashboard',
      \ 'diff',
      \ 'gitcommit',
      \ 'unite',
      \ 'qf',
      \ 'help',
      \ 'markdown',
      \ ]

" ----------------------------------------------------------------------------
" Switch.vim
" ----------------------------------------------------------------------------
let g:switch_custom_definitions =
  \ [
  \   ['up', 'down', 'change'],
  \   ['add', 'drop', 'remove'],
  \   ['create', 'drop'],
  \   ['row', 'column'],
  \   ['first', 'second', 'third', 'fourth', 'fifth'],
  \ ]


" ----------------------------------------------------------------------------
" Vim RSpec
" ----------------------------------------------------------------------------
" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader>T :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>
nnoremap <Leader>sa :call RunAllSpecs()<CR>

" ----------------------------------------------------------------------------
" Vim Flow JS
" ----------------------------------------------------------------------------
let g:flow#autoclose = 1


" ----------------------------------------------------------------------------
" Vim Elixir
" ----------------------------------------------------------------------------
let g:elixir_fold = 0

" ----------------------------------------------------------------------------
" Vim Test
" ----------------------------------------------------------------------------

if has('nvim') && !exists('$TMUX')
  " run tests with neoterm in vim-test
  let g:test#strategy = 'neoterm'
else
  let g:test#strategy = 'vimux'
endif

" "  Support Elixir Umbrella Apps (pre 1.9) {{{
"   " https://github.com/janko/vim-test/issues/136
"   function! ElixirUmbrellaTransform(cmd) abort
"     if match(a:cmd, 'apps/') != -1
"       return substitute(a:cmd, 'mix test apps/\([^/]*\)/', 'mix cmd --app \1 mix test --color ', '')
"     else
"       return a:cmd
"     end
"   endfunction

"   let g:test#custom_transformations = {'elixir_umbrella': function('ElixirUmbrellaTransform')}
"   let g:test#transformation = 'elixir_umbrella'
" }}}

nmap <silent> <leader>T :TestNearest<CR>
nmap <silent> <leader>t :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>


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
" Mix Format (mhinz/vim-mix-format)
" ----------------------------------------------------------------------------
let g:mix_format_on_save = 1

" ----------------------------------------------------------------------------
" Investigate
" ----------------------------------------------------------------------------
" Use Dash.app for documentation of word under cursor
let g:investigate_use_dash=1
let g:investigate_syntax_for_rspec='ruby'

" ----------------------------------------------------------------------------
" Dashboard
" ----------------------------------------------------------------------------

let g:dashboard_default_executive = 'fzf'
let g:dashboard_custom_header = [
            \ ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
            \ ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
            \ ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
            \ ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
            \ ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
            \ ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
            \]

" ----------------------------------------------------------------------------
" Elm-vim
" ----------------------------------------------------------------------------
" let g:elm_format_autosave=1
let g:elm_detailed_complete = 1


" ----------------------------------------------------------------------------
" vim-go
" ----------------------------------------------------------------------------
augroup CustomGoVimMappings
  autocmd!
  autocmd FileType go setlocal nolist listchars=tab:>-,trail:·,nbsp:·
  autocmd FileType go nmap <buffer> <leader>r <Plug>(go-run)
  autocmd FileType go nmap <buffer> <leader>b <Plug>(go-build)
  autocmd FileType go nmap <buffer> <leader>t <Plug>(go-test)
  autocmd FileType go nmap <buffer> <leader>c <Plug>(go-coverage)
  autocmd Filetype go
    \  command! -bang A call go#alternate#Switch(<bang>0, 'edit')
    \| command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
    \| command! -bang AS call go#alternate#Switch(<bang>0, 'split')
augroup END

let g:go_fmt_autosave = 1
let g:go_term_mode = 'vsplit'
let g:go_fmt_command='goimports'

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

" --------------------------------------------
" sideways.vim
" --------------------------------------------
nnoremap <M-h> :SidewaysLeft<cr>
nnoremap <M-l> :SidewaysRight<cr>

" ================================
" Projectioinist
" ================================

let g:projectionist_heuristics = {}

let g:projectionist_heuristics['mix.exs'] = {
            \     'apps/*/mix.exs': { 'type': 'app' },
            \     'lib/*.ex': {
            \       'type': 'lib',
            \       'alternate': [
            \         'test/{}_test.exs',
            \         'test/lib/{}_test.exs',
            \       ],
            \       'template': ['defmodule {camelcase|capitalize|dot} do', 'end'],
            \     },
            \     'test/*_test.exs': {
            \       'type': 'test',
            \       'alternate': ['lib/{}.ex', '{}.ex'],
            \       'template': [
            \           'defmodule {camelcase|capitalize|dot}Test do',
            \           '  use ExUnit.Case',
            \           '',
            \           '  alias {camelcase|capitalize|dot}, as: Subject',
            \           '',
            \           '  doctest Subject',
            \           'end'
            \       ],
            \     },
            \     'mix.exs': { 'type': 'mix' },
            \     'config/*.exs': { 'type': 'config' },
            \ }

let g:projectionist_heuristics['package.json'] = {
            \   '*.js': {
            \     'alternate': [
            \       '{dirname}/{basename}.test.js',
            \       '{dirname}/__tests__/{basename}.test.js',
            \     ],
            \     'type': 'source',
            \     'make': 'yarn',
            \   },
            \   '*.test.js': {
            \     'alternate': [
            \       '{dirname}/{basename}.js',
            \       '{dirname}/../{basename}.js',
            \     ],
            \     'type': 'test',
            \   },
            \   '*.ts': {
            \     'alternate': [
            \       '{dirname}/{basename}.test.ts',
            \       '{dirname}/{basename}.test.tsx',
            \       '{dirname}/__tests__/{basename}.test.ts',
            \       '{dirname}/__tests__/{basename}.test.tsx',
            \     ],
            \     'type': 'source',
            \   },
            \   '*.test.ts': {
            \     'alternate': [
            \       '{dirname}/{basename}.ts',
            \       '{dirname}/{basename}.tsx',
            \       '{dirname}/../{basename}.ts',
            \       '{dirname}/../{basename}.tsx',
            \     ],
            \     'type': 'test',
            \   },
            \   '*.tsx': {
            \     'alternate': [
            \       '{dirname}/{basename}.test.ts',
            \       '{dirname}/{basename}.test.tsx',
            \       '{dirname}/__tests__/{basename}.test.ts',
            \       '{dirname}/__tests__/{basename}.test.tsx',
            \     ],
            \     'type': 'source',
            \   },
            \   '*.test.tsx': {
            \     'alternate': [
            \       '{dirname}/{basename}.ts',
            \       '{dirname}/{basename}.tsx',
            \       '{dirname}/../{basename}.ts',
            \       '{dirname}/../{basename}.tsx',
            \     ],
            \     'type': 'test',
            \   },
            \   'package.json': { 'type': 'package' }
            \ }

" ----------------------------------------------------- }}}

" UI Customizations {{{

    " make background transparent
    " au ColorScheme * hi Normal ctermbg=none guibg=none
    highlight Normal ctermbg=none guibg=none
    highlight NonText ctermbg=none guibg=none
    highlight vimCommentGroup ctermbg=none guibg=none
    highlight SignColumn ctermbg=none guibg=none
    highlight FoldColumn ctermbg=none guibg=none
    highlight Folded ctermbg=none guibg=none
    highlight ALEErrorSign ctermbg=none guibg=none
    highlight ALEWarningSign ctermbg=none guibg=none
    highlight clear LineNr

    highlight SignifySignAdd    ctermfg=green  guifg=#00ff00 ctermbg=none guibg=none
    highlight SignifySignDelete ctermfg=red    guifg=#ff0000 ctermbg=none guibg=none
    highlight SignifySignChange ctermfg=yellow guifg=#ffff00 ctermbg=none guibg=none


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
   " alias for leader key
     nmap <space> \
     xmap <space> \

  " center window on search result
    nnoremap <silent> n nzzzv
    nnoremap <silent> N Nzzzv

  " Delete current buffer without losing the split
    nnoremap <silent> <C-q> :bp\|bd #<CR>

  " open FZF in current file's directory
    nnoremap <silent> <Leader>_ :Files <C-R>=expand('%:h')<CR><CR>

  " fold file based on syntax
    nnoremap <silent> <leader>zs :setlocal foldmethod=syntax<CR>

  " close tab
    nnoremap <c-w>w :bd<CR>

  " rename current file
    nnoremap <Leader>rn :Move <C-R>=expand("%")<CR>

  " replace word under cursor, globally, with confirmation
    nnoremap <Leader>k :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
    vnoremap <Leader>k y :%s/<C-r>"//gc<Left><Left><Left>

  " insert frozen string literal comment at the top of the file (ruby)
    map <leader>fsl ggO# frozen_string_literal: true<esc>jO<esc>

  " remove highlighting on escape
    nnoremap <silent> <esc> :nohlsearch<cr>

  " sort selected lines
    vmap gs :sort<CR>

  " Pasting support
    set pastetoggle=<F2>  " Press F2 in insert mode to preserve tabs when
                          " pasting from clipboard into terminal

  " re-indent file and jump back to where the cursor was
    map <F7> mzgg=G`z

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

    " qq to record, Q to replay
    nnoremap Q @q

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

  " Tab/shift-tab to indent/outdent in visual mode.
    vnoremap <Tab> >gv
    vnoremap <S-Tab> <gv

  " Keep selection when indenting/outdenting.
    vnoremap > >gv
    vnoremap < <gv

  " Search for selected text
    vnoremap * "xy/<C-R>x<CR>

  " Split edit your vimrc. Type space, v, r in sequence to trigger
    fun! OpenConfigFile(file)
      if (&filetype ==? 'startify' || &filetype ==? 'dashboard')
        execute 'e ' . a:file
      else
        execute 'tabe ' . a:file
      endif
    endfun

    nnoremap <silent> <leader>vr :call OpenConfigFile('~/.vimrc')<cr>
    nnoremap <silent> <leader>vb :call OpenConfigFile('~/.vimrc.bundles')<cr>
    "
  " Source (reload) your vimrc. Type space, s, o in sequence to trigger
    nnoremap <leader>so :source $MYVIMRC<cr>

  " toggle background light / dark
    fun! ToggleBackground()
      if (&background ==? 'dark')
        set background=light
      else
        set background=dark
      endif
    endfun

    nnoremap <silent> <F10> :call ToggleBackground()<CR>


  "split edit your tmux conf
    nnoremap <leader>mux :vsp ~/.tmux.conf<cr>

  " Packer:
    nnoremap <leader>pl :PackerCompile<CR>
    nnoremap <leader>ps :PackerSync<CR>
    nnoremap <leader>pc :PackerClean<CR>

  " change dir to current file's dir
    nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

  " zoom a vim pane, <C-w> = to re-balance
    nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
    nnoremap <leader>= :wincmd =<cr>

  " close all other windows with <leader>o
    nnoremap <leader>wo <c-w>o

  " Index ctags from any project, including those outside Rails
    map <Leader>ct :!ctags -R .<CR>

  " Switch between the last two files
    nnoremap <tab><tab> <c-^>

  " command typo mapping
    cnoremap WQ wq
    cnoremap Wq wq
    cnoremap QA qa
    cnoremap qA qa
    cnoremap Q! q!

  " copy to end of line
    nnoremap Y y$

  " copy to system clipboard
    noremap gy "+y

  " copy whole file to system clipboard
    nnoremap gY gg"+yG

  " Prettier:
    " shows the output from prettier - useful for syntax errors
    nnoremap <leader>pt :!prettier %<CR>

  " CtrlSF:
    nnoremap <C-F>f :CtrlSF
    nnoremap <C-F>g :CtrlSF<CR>

  " disable arrow keys in normal mode
    nnoremap <silent> <Up>    :call animate#window_delta_height(10)<CR>
    nnoremap <silent> <Down>  :call animate#window_delta_height(-10)<CR>
    nnoremap <silent> <Left>  :call animate#window_delta_width(10)<CR>
    nnoremap <silent> <Right> :call animate#window_delta_width(-10)<CR>

  " last typed word to lower case
    inoremap <C-w>u <esc>guawA

  " last typed word to UPPER CASE
    inoremap <C-w>U <esc>gUawA

  " entire line to lower case
    inoremap <C-g>u <esc>guuA

  " entire line to UPPER CASE
    inoremap <C-g>U <esc>gUUA

  " last word to title case
    inoremap <C-w>t <esc>bvgU<esc>A

  " current line to title case
    inoremap <C-g>t <esc>:s/\v<(.)(\w*)/\u\1\L\2/g<cr>A

  " Incsearch:
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)

  " Open files relative to current path:
    nnoremap <leader>ed :edit <C-R>=expand("%:p:h") . "/" <CR>
    nnoremap <leader>sp :split <C-R>=expand("%:p:h") . "/" <CR>
    nnoremap <leader>vs :vsplit <C-R>=expand("%:p:h") . "/" <CR>

  " move lines up and down in visual mode
    xnoremap <c-k> :move '<-2<CR>gv=gv
    xnoremap <c-j> :move '>+1<CR>gv=gv

" --------------------- Key Mappings ---------------------------- }}}

" Higher Order Immutable Funcs {{{
fun! Map(list, fn)
  let new_list = deepcopy(a:list)
  call map(new_list, a:fn)
  return new_list
endfun

fun! Filter(list, fn)
  let new_list = deepcopy(a:list)
  call filter(new_list, a:fn)
  return new_list
endfun

fun! Find(list, fn)
  let l:fn = substitute(a:fn, 'v:val', 'l:item', 'g')
  for l:item in a:list
    let l:new_item = deepcopy(l:item)
    if execute('echon (' . l:fn . ')') ==# '1'
      return l:new_item
    endif
  endfor

  return 0
endfun

fun! HasItem(list, fn)
  return !empty(Find(a:list, a:fn))
endfun
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

" Local config
if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif

" For NeoVim {{{
if has('nvim')
  " use neovim-remote (pip3 install neovim-remote) allows
  " opening a new split inside neovim instead of nesting
  " neovim processes for git commit
    let $VISUAL      = 'nvr -cc split --remote-wait +"setlocal bufhidden=delete"'
    let $GIT_EDITOR  = 'nvr -cc split --remote-wait +"setlocal bufhidden=delete"'
    let $EDITOR      = 'nvr -l'
    let $ECTO_EDITOR = 'nvr -l'

    let g:terminal_color_0  = "#353a44"
    let g:terminal_color_1  = "#e88388"
    let g:terminal_color_2  = "#a7cc8c"
    let g:terminal_color_3  = "#ebca8d"
    let g:terminal_color_4  = "#72bef2"
    let g:terminal_color_5  = "#d291e4"
    let g:terminal_color_6  = "#65c2cd"
    let g:terminal_color_7  = "#e3e5e9"
    let g:terminal_color_8  = "#353a44"
    let g:terminal_color_9  = "#e88388"
    let g:terminal_color_10 = "#a7cc8c"
    let g:terminal_color_11 = "#ebca8d"
    let g:terminal_color_12 = "#72bef2"
    let g:terminal_color_13 = "#d291e4"
    let g:terminal_color_14 = "#65c2cd"
    let g:terminal_color_15 = "#e3e5e9"

  " interactive find replace preview
    set inccommand=nosplit

  " share data between nvim instances (registers etc)
    augroup SHADA
      autocmd!
      autocmd CursorHold,TextYankPost,FocusGained,FocusLost *
            \ if exists(':rshada') | rshada | wshada | endif
    augroup END

  " set pum background visibility to 20 percent
    set pumblend=20

  " set file completion in command to use pum
    set wildoptions=pum

  " Navigate neovim + neovim terminal emulator with alt+direction
    tnoremap <silent><C-h> <C-\><C-n><C-w>h
    tnoremap <silent><C-j> <C-\><C-n><C-w>j
    tnoremap <silent><C-k> <C-\><C-n><C-w>k
    tnoremap <silent><C-l> <C-\><C-n><C-w>l

  " easily escape terminal
    tnoremap <leader><esc> <C-\><C-n><esc><cr>
    tnoremap <C-o> <C-\><C-n><esc><cr>

  " quickly toggle term
    nnoremap <silent> <leader>o :vertical botright Ttoggle<cr><C-w>l
    nnoremap <silent> <leader>O :botright Ttoggle<cr><C-w>j
    nnoremap <silent> <leader><space> :vertical botright Ttoggle<cr><C-w>l

    " close terminal
    tnoremap <silent> <leader>o <C-\><C-n>:Ttoggle<cr>
    tnoremap <silent> <leader><space> <C-\><C-n>:Ttoggle<cr>

  " send stuff to REPL using NeoTerm
    nnoremap <silent> <c-s>l :TREPLSendLine<CR>
    vnoremap <silent> <c-s>s :TREPLSendSelection<CR>

  " pasting works quite well in neovim as is so disabling yo
    nnoremap <silent> yo o
    nnoremap <silent> yO O
endif
" }}}

" gx extensions {{{
" For VimPlug
function! PlugGx()
  let l:line = getline('.')
  let l:sha  = matchstr(l:line, '^  \X*\zs\x\{7,9}\ze ')

  let l:name = matchlist(l:line, '\v/([A-Za-z0-9\-_\.]+)')[1]

  let l:uri  = get(get(g:plugs, l:name, {}), 'uri', '')
  if l:uri !~? 'github.com'
    return
  endif
  let l:repo = matchstr(l:uri, '[^:/]*/'.l:name)
  let l:url  = empty(l:sha)
              \ ? 'https://github.com/'.l:repo
              \ : printf('https://github.com/%s/commit/%s', l:repo, l:sha)
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

" Load project specific vimrc {{{

  if (getcwd() != expand('~')) && filereadable(getcwd() . '/.vimrc')
    echom '-------------> loading project specific local vimrc'
    set exrc
    execute 'source ' . getcwd() . '/.vimrc'
  endif

" }}}

" Temporary {{{

" testing for bullets.vim
nnoremap <leader>m :vs test.md<cr>
nnoremap <leader>q :q!<cr>

"}}}
