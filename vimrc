"  ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄
" ███    ███ ███  ▄██▀▀▀███▀▀▀██▄
" ███    ███ ███▌ ███   ███   ███
" ███    ███ ███▌ ███   ███   ███
" ███    ███ ███▌ ███   ███   ███
" ███    ███ ███  ███   ███   ███
" ███    ███ ███  ███   ███   ███
"  ▀██████▀  █▀    ▀█   ███   █▀

" General settings {{{
  scriptencoding utf-16      " allow emojis in vimrc
  set nocompatible           " vim, not vi
  syntax on                  " syntax highlighting
  filetype plugin indent on  " try to recognize filetypes and load rel' plugins
" }}}

"  Behavior Modification ----------------------  {{{

  " set leader key
    let g:mapleader="\\"

  " alias for leader key
    nmap <space> \

  " disable bracketed paste
  " set t_BE=

  set background=dark   " tell vim what the background color looks like
  set backspace=2       " Backspace deletes like most programs in insert mode
  set history=200       " how many : commands to save in history
  set ruler             " show the cursor position all the time
  set showcmd           " display incomplete commands
  set incsearch         " do incremental searching
  set laststatus=2      " Always display the status line
  set autowrite         " Automatically :write before running commands
  set ignorecase        " ignore case in searches
  set smartcase         " use case sensitive if capital letter present or \C
  set magic             " Use 'magic' patterns (extended regular expressions).
  set guioptions=       " remove scrollbars on macvim
  set noshowmode        " don't show mode as airline already does
  set showcmd           " show any commands
  set foldmethod=manual " set folds by syntax of current language
  set mouse=a           " enable mouse (selection, resizing windows)
  set iskeyword+=-      " treat dash separated words as a word text object

  set tabstop=2         " Softtabs or die! use 2 spaces for tabs.
  set shiftwidth=2      " Number of spaces to use for each step of (auto)indent.
  set expandtab         " insert tab with right amount of spacing
  set shiftround        " Round indent to multiple of 'shiftwidth'
  set termguicolors     " enable true colors

  if !has('nvim')             " does not work on neovim
    set emoji                 " treat emojis 😄  as full width characters
    set cryptmethod=blowfish2 " set encryption to use blowfish2 (vim -x file.txt)
  end

  set ttyfast           " should make scrolling faster
  set lazyredraw        " should make scrolling faster

  " visual bell for errors
    set visualbell

  " wildmenu
    set wildmenu                        " enable wildmenu
    set wildmode=list:longest,list:full " configure wildmenu

  " text appearance
    set textwidth=80
    set nowrap                          " nowrap by default
    set list                            " show invisible characters
    set listchars=tab:»·,trail:·,nbsp:· " Display extra whitespace

  " Numbers
    set number
    set numberwidth=1

  " set where swap file and undo/backup files are saved
    set backupdir=~/.vim/tmp,.
    set directory=~/.vim/tmp,.
    set undodir=~/.vim/tmp,.

  " Open new split panes to right and bottom, which feels more natural
    set splitbelow
    set splitright

  " Set spellfile to location that is guaranteed to exist, can be symlinked to
  " Dropbox or kept in Git
    set spellfile=$HOME/.vim-spell-en.utf-8.add

  " Autocomplete with dictionary words when spell check is on
    set complete+=kspell

  " Always use vertical diffs
    set diffopt+=vertical

  " set shell to zsh
    set shell=/bin/zsh

  " highlight fenced code blocks in markdown
  let g:markdown_fenced_languages = [
        \ 'html',
        \ 'elm',
        \ 'vim',
        \ 'js=javascript',
        \ 'json',
        \ 'python',
        \ 'ruby',
        \ 'elixir',
        \ 'sql',
        \ 'bash=sh'
        \ ]

  " enable folding in bash files
    let g:sh_fold_enabled=1
" }}}

"  Plugin Modifications (BEFORE loading bundles) ----- {{{
" ====================================
" WinResizer:
" ====================================
nnoremap <C-w>r :WinResizerStartResize<CR>

" ====================================
" UndoTree:
" ====================================
nnoremap <silent> <leader>ut :UndotreeToggle<CR>

" ====================================
" Deoplete:
" ====================================
let g:deoplete#enable_at_startup = 1

inoremap <silent><expr> <TAB>
         \ pumvisible() ? "\<C-n>" :
         \ <SID>check_back_space() ? "\<TAB>" :
         \ deoplete#mappings#manual_complete()

function! s:check_back_space() abort
  let l:col = col('.') - 1
  return !l:col || getline('.')[l:col - 1]  =~? '\s'
endfunction

"Add extra filetypes
let g:deoplete#sources#ternjs#filetypes = [
                                        \ 'javascript.jsx',
                                        \ 'javascript',
                                        \ ]

" ====================================
" Vim multiple cursors + DEOPLETE:
" ====================================
augroup VimMultiCursors
  autocmd!
  autocmd User MultipleCursorsPre let g:deoplete#disable_auto_complete=1
  autocmd User MultipleCursorsPost let g:deoplete#disable_auto_complete=0
augroup END

" ====================================
" LanguageClient-neovim:
" ====================================
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ }

" ====================================
" NeoTerm:
" ====================================
let g:neoterm_position = 'vertical'
let g:neoterm_repl_ruby = 'pry'
let g:neoterm_autoscroll = 1

" ====================================
" Gist:
" ====================================
map <leader>gst :Gist<cr>

" ====================================
" GitGutter:
" ====================================
nnoremap <silent> <cr> :GitGutterNextHunk<cr>
nnoremap <silent> <backspace> :GitGutterPrevHunk<cr>

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
" NeoFormat:
" ====================================
let g:neoformat_try_formatprg = 1

let g:neoformat_only_msg_on_error = 1

" ONLY PRETTIER (don't run any other formatters for these file types)
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_css = ['prettier']
let g:neoformat_enabled_scss = ['prettier']
let g:neoformat_enabled_json = ['prettier']

let g:neoformat_javascript_prettier = {
      \ 'exe': 'prettier',
      \ 'args': ['--stdin', '--print-width 80', '--single-quote', '--trailing-comma es5'],
      \ 'stdin': 1,
      \ }


augroup NeoformatAutoFormat
  autocmd!
  autocmd FileType zsh setlocal formatprg=shfmt\ -i\ 2
  autocmd BufWritePre *.js,*.jsx,*.css,*.scss,*.json Neoformat
  autocmd BufWritePre .zshrc-dorian,.zshrc,.aliases Neoformat
  " autocmd BufWritePre *.css,*.scss Neoformat stylefmt
augroup END

nnoremap <leader>nf :Neoformat<CR>


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
let g:UltiSnipsExpandTrigger               = '<C-l>'
let g:UltiSnipsJumpForwardTrigger          = '<tab>'
let g:UltiSnipsJumpBackwardTrigger         = '<s-tab>'

" :UltiSnipsEdit opens in a vertical split
let g:UltiSnipsEditSplit                   = 'vertical'
let g:UltiSnipsSnippetsDir                 = $HOME . '/dotfiles/vim/UltiSnips'

" ====================================
" indentLine
" ====================================
let g:indentLine_fileType = [
      \ 'java',
      \ 'ruby',
      \ 'elixir',
      \ 'javascript',
      \ 'vim'
      \ ]
let g:indentLine_char = '│'
let g:indentLine_color_term = 240

" ====================================
" setup airline
" ====================================
let g:airline#extensions#tabline#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_left_sep = ''
let g:airline_right_sep = ''

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
"  FZF
" =====================================
" set fzf's default input to AG instead of find. This also removes gitignore etc
let $FZF_DEFAULT_COMMAND = 'ag --hidden -l -g ""'
let g:fzf_files_options = '--preview "rougify {} | head -'.&lines.'"'

function! FZFOpen(command_str)
  if (expand('%') =~# 'NERD_tree' && winnr('$') > 1)
    exe "normal! \<c-w>\<c-w>"
  endif
  exe 'normal! ' . a:command_str . "\<cr>"
endfunction

nnoremap <silent> <C-b> :call FZFOpen(':Buffers')<CR>
nnoremap <silent> <C-g>g :call FZFOpen(':Ag')<CR>
nnoremap <silent> <C-g>c :call FZFOpen(':Commands')<CR>
nnoremap <silent> <C-g>l :call FZFOpen(':BLines')<CR>
nnoremap <silent> <C-p> :call FZFOpen(':call Fzf_dev()')<CR>

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" ======================================
" FZF + DevIcons
" ======================================

" Files + devicons
function! Fzf_dev()
  let l:fzf_files_options =
        \ '--preview "echo {} | tr -s \" \" \"\n\" | tail -1 | xargs rougify | head -'.&lines.'"'
  function! s:files()
    let l:files = split(system($FZF_DEFAULT_COMMAND), '\n')
    return s:prepend_icon(l:files)
  endfunction

  function! s:prepend_icon(candidates)
    let l:result = []
    for l:candidate in a:candidates
      let l:filename = fnamemodify(l:candidate, ':p:t')
      let l:icon = WebDevIconsGetFileTypeSymbol(l:filename, isdirectory(l:filename))
      call add(l:result, printf('%s %s', l:icon, l:candidate))
    endfor

    return l:result
  endfunction

  function! s:edit_file(item)
    let l:parts = split(a:item, ' ')
    let l:file_path = get(l:parts, 1, '')
    execute 'silent e' l:file_path
  endfunction

  call fzf#run({
        \ 'source': <sid>files(),
        \ 'sink':   function('s:edit_file'),
        \ 'options': '-m ' . l:fzf_files_options,
        \ 'down':    '40%' })
endfunction

" Custom FZF commands ----------------------------- {{{
fun! s:change_branch(e)
  let l:_ = system('git checkout ' . a:e)
  :e!
  :AirlineRefresh
  echom 'Changed branch to' . a:e
endfun

command! Gbranch call fzf#run(
      \ {
      \ 'source': 'git branch',
      \ 'sink': function('<sid>change_branch'),
      \ 'options': '-m',
      \ 'down': '20%'
      \ })

fun! s:change_remote_branch(e)
  let l:_ = system('git checkout --track ' . a:e)
  :e!
  :AirlineRefresh
  echom 'Changed to remote branch' . a:e
endfun

command! Grbranch call fzf#run(
      \ {
      \ 'source': 'git branch -r',
      \ 'sink': function('<sid>change_remote_branch'),
      \ 'options': '-m',
      \ 'down': '20%'
      \ })
" --------------------------------------------------}}}

" =====================================
"  JSX
" =====================================

" Allow JSX in normal JS files
let g:jsx_ext_required = 0

" =====================================
"  Ack + Ag
" =====================================

" Grep selection with Ag
xnoremap <leader>g y :Ag "<CR>

" Use The Silver Searcher for grep https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use Ag for Ack
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

nnoremap <leader>f :Ack!<Space>

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
" Switch.vim
" ----------------------------------------------------------------------------
let g:switch_custom_definitions =
  \ [
  \   ['up', 'down', 'change'],
  \   ['add', 'drop', 'remove'],
  \ ]

" ----------------------------------------------------------------------------
" Rail.vim
" ----------------------------------------------------------------------------
" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

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
" Neomake
" ----------------------------------------------------------------------------
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_elm_elm_lint_maker = {
      \ 'exe': 'elm_lint',
      \ 'errorformat': '%f:%l:%c [%t] %m'
      \ }
let g:neomake_elm_enabled_makers = ['elm_lint']

augroup NeomakeOnSave
  autocmd!
  autocmd! BufWritePost * Neomake
augroup END

" ----------------------------------------------------------------------------
" Investigate
" ----------------------------------------------------------------------------
" Use Dash.app for documentation of word under cursor
let g:investigate_use_dash=1
let g:investigate_syntax_for_rspec='ruby'

" ----------------------------------------------------------------------------
" Startify
" ----------------------------------------------------------------------------
let g:startify_files_number = 5


" ----------------------------------------------------------------------------
" Vim Hashrocket
" ----------------------------------------------------------------------------
"Change cursor on insert mode (vim-hashrocket)
if !has('nvim')
  let g:use_cursor_shapes = 1
end

" ----------------------------------------------------------------------------
" Elm-vim
" ----------------------------------------------------------------------------
" let g:elm_format_autosave=1
let g:elm_detailed_complete = 1

" ----------------------------------------------------------------------------
" NERDTree
" ----------------------------------------------------------------------------
let g:NERDTreeIgnore = [
      \ '\.vim$',
      \ '\~$',
      \ '\.beam',
      \ 'elm-stuff',
      \ 'deps',
      \ '_build',
      \ '.git',
      \ 'node_modules'
      \ ]

let g:NERDTreeShowHidden = 1
let g:NERDTreeAutoDeleteBuffer=1
nnoremap <Leader>nt :NERDTreeToggle<CR>
nnoremap <leader>d :e %:h<CR>


" ----------------------------------------------------------------------------
" WebDevIcons
" ----------------------------------------------------------------------------
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:webdevicons_enable_airline_statusline = 1
let g:webdevicons_enable_airline_tabline = 1
let g:WebDevIconsOS = 'Darwin'
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['ex'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['exs'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['js'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['jsx'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vim'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['md'] = ''

let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*vimrc.*'] = ''

" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" ----------------------------------------------------------------------------
"  vim-nerdtree-syntax-highlight:
" ----------------------------------------------------------------------------
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeExtensionHighlightColor = {}
let g:NERDTreeExtensionHighlightColor['ex'] = '834F79'
let g:NERDTreeExtensionHighlightColor['exs'] = 'c57bd8'


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
augroup END

" ----------------------------------------------------------------------------
" goyo.vim + limelight.vim
" ----------------------------------------------------------------------------
let g:limelight_paragraph_span = 1
let g:limelight_priority = -1

function! s:goyo_enter()
  if has('gui_running')
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
  Limelight
endfunction

function! s:goyo_leave()
  if has('gui_running')
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
  execute 'Limelight!'
endfunction

augroup GOYO
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

" ----------------------------------------------------------------------------
" vim-legend
" ----------------------------------------------------------------------------
let g:legend_active_auto = 0
let g:legend_hit_color = 'ctermfg=64 cterm=bold gui=bold guifg=Green'
let g:legend_ignored_sign = '◌'
let g:legend_ignored_color = 'ctermfg=234'
let g:legend_mapping_toggle = '<Leader>cv'
let g:legend_mapping_toggle_line = '<localleader>cv'

" --------------------------------------------
"  vim-ruby:
" --------------------------------------------
" support ruby on rails omnicompletions
let g:rubycomplete_rails = 1

" ----------------------------------------------------- }}}

" Load all plugins ------------------------------- {{{
if filereadable(expand('~/.vimrc.bundles'))
  source ~/.vimrc.bundles
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif
" }}}

"  Plugin Modifications (AFTER loading bundles) ----- {{{
if has('nvim') && !exists('$TMUX')
" ------------------------------------
" NVIMUX:
" ------------------------------------

lua << EOF
local nvimux = require('nvimux')

-- Nvimux configuration
nvimux.config.set_all{
  prefix = '<C-z>',
  open_term_by_default = true,
  new_window_buffer = 'single',
  quickterm_direction = 'botright',
  quickterm_orientation = 'vertical',
  -- Use 'g' for global quickterm
  quickterm_scope = 't',
  quickterm_size = '80',
}

-- Nvimux custom bindings
nvimux.bindings.bind_all{
  {'s', ':NvimuxHorizontalSplit', {'n', 'v', 'i', 't'}},
  {'v', ':NvimuxVerticalSplit', {'n', 'v', 'i', 't'}},
}

-- Required so nvimux sets the mappings correctly
nvimux.bootstrap()
EOF
endif

" }}}

" UI Customizations --------------------------------{{{
  " " Gruvbox colorscheme allow italics
  " let g:gruvbox_italic = 1
  " let g:gruvbox_invert_selection=0

  " default color scheme
  " colorscheme dracula
  set background=dark
  colorscheme onedark

  " when on dracula
  " let g:limelight_conceal_ctermfg = 59
  " let g:limelight_conceal_guifg = '#43475b'

  " Make it obvious where 80 characters is
  " cheatsheet https://jonasjacek.github.io/colors/
  highlight ColorColumn ctermbg=236 guibg=#303030
  let &colorcolumn=join(range(80,999),',')

  " solid window border requires FuraCode Nerd Font
  set fillchars+=vert:│

  " hide vertical split
  hi vertsplit guifg=fg guibg=bg
"  }}}

" Own commands --------------------------------------------- {{{
command! PrettyPrintJSON %!python -m json.tool
command! PrettyPrintHTML !tidy -mi -html -wrap 0 %
command! PrettyPrintXML !tidy -mi -xml -wrap 0 %
command! BreakLineAtComma :normal! f,.
command! Retab :set ts=2 sw=2 et<CR>:retab<CR>
" }}}

" Auto commands ------------------------------------------------- {{{
  augroup vimrcEx
    autocmd!

    " Remove trailing whitespace on save for ruby files.
    autocmd BufWritePre *.rb,*.ex,*.exs :%s/\s\+$//e

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
    autocmd BufRead,BufNewFile *.md set filetype=markdown

    " Enable spellchecking for Markdown
    autocmd FileType markdown setlocal spell

    " Automatically wrap at 80 characters for Markdown
    autocmd BufRead,BufNewFile *.md setlocal textwidth=80

    " Automatically wrap at 72 characters and spell check git commit messages
    autocmd FileType gitcommit setlocal textwidth=72
    autocmd FileType gitcommit setlocal spell

    " Allow stylesheets to autocomplete hyphenated words
    autocmd FileType css,scss,sass setlocal iskeyword+=-

    " Vim/tmux layout rebalancing
    " automatically rebalance windows on vim resize
    autocmd VimResized * :wincmd =
  augroup END

  augroup Elm
    autocmd!
    autocmd FileType elm setlocal tabstop=4
    autocmd BufWritePre *.elm :ElmFormat
  augroup END
" }}}

" Vim Script file settings ------------------------ {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Better split management, kept in sync with tmux' -- {{{
"" noremap <leader>- :sp<CR><C-w>j
"" noremap <leader>\| :vsp<CR><C-w>l
" }}}

"  Key Mappings -------------------------------------------------- {{{

  " replace word under cursor, globally, with confirmation
    nnoremap <Leader>k :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

  " remove highlighting on escape
    map <silent> <esc> :noh<cr>

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


  " prevent entering ex mode accidentally
    nnoremap Q <Nop>

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
      if (&filetype ==? 'startify')
        execute 'e ' . a:file
      else
        execute 'tabe ' . a:file
      endif
    endfun

    nnoremap <silent> <leader>vr :call OpenConfigFile($MYVIMRC)<cr>
    nnoremap <silent> <leader>vb :call OpenConfigFile('~/.vimrc.bundles')<cr>

  " Source (reload) your vimrc. Type space, s, o in sequence to trigger
    nnoremap <leader>so :source $MYVIMRC<cr>

  "split edit your tmux conf
    nnoremap <leader>mux :vsp ~/.tmux.conf<cr>


  " VimPlug:
    nnoremap <leader>pi :PlugInstall<CR>
    nnoremap <leader>pu :PlugUpdate<CR>
    nnoremap <leader>pc :PlugClean<CR>

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
    " shows you the output from prettier - useful when you have a syntax error
    nnoremap <leader>p :!prettier %<CR>

  " CtrlSF:
    nnoremap <C-F>f :CtrlSF
    nnoremap <C-F>g :CtrlSF<CR>

  " easier new tab
    noremap <C-t> <esc>:tabnew<CR>
    noremap <C-c> <esc>:tabclose<CR>

  " disable arrow keys in normal mode
    nnoremap <Left> :echoe "Use h"<CR>
    nnoremap <Right> :echoe "Use l"<CR>
    nnoremap <Up> :echoe "Use k"<CR>
    nnoremap <Down> :echoe "Use j"<CR>

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

  " Quicker window movement
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-h> <C-w>h
    nnoremap <C-l> <C-w>l

  " Incsearch:
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)

  " Open files relative to current path:
  nnoremap <leader>e :edit <C-R>=expand("%:p:h") . "/" <CR>
  nnoremap <leader>s :split <C-R>=expand("%:p:h") . "/" <CR>

" --------------------- Key Mappings ---------------------------- }}}

"    Abbreviations --------------------------------------- {{{
iabbrev @@ dkarter@gmail.com
iabbrev ccopy Copyleft 2016 Dorian Karter.
iabbrev bpry require 'pry'; binding.pry;
iabbrev ipry require IEx; IEx.pry;

" Local config
if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif
" -------- Abbreviations ---------------------------------- }}}

" For NeoVim ----------------------------------------------------- {{{
if has('nvim')
  " let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
        \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
        \,sm:block-blinkwait175-blinkoff150-blinkon175
  set inccommand=nosplit " interactive find replace preview

  " Navigate neovim + neovim terminal emulator with alt+direction
    tnoremap <c-h> <C-\><C-n><C-w>h
    tnoremap <c-j> <C-\><C-n><C-w>j
    tnoremap <c-k> <C-\><C-n><C-w>k
    tnoremap <c-l> <C-\><C-n><C-w>l

  " easily escape terminal
    tnoremap <leader><esc> <C-\><C-n><esc><cr>
    tnoremap <C-o> <C-\><C-n><esc><cr>

  " quickly toggle term
    nnoremap <silent> <leader><space> :Ttoggle<cr><C-w>j
    tnoremap <silent> <leader><space> <C-\><C-n>:Ttoggle<cr>

  " pasting works quite well in neovim as is so disabling yo
    nnoremap <silent> yo o
    nnoremap <silent> yO O

  " run tests with neoterm in vim-test
    let g:test#strategy = 'neoterm'
    nmap <silent> <leader>T :TestNearest<CR>
    nmap <silent> <leader>t :TestFile<CR>
    nmap <silent> <leader>a :TestSuite<CR>
    nmap <silent> <leader>l :TestLast<CR>
    nmap <silent> <leader>g :TestVisit<CR>

  " use neovim-remote (pip3 install neovim-remote) allows 
  " opening a new split inside neovim instead of nesting
  " neovim processes
    let $VISUAL = 'nvr -cc split --remote-wait'
endif
" }}}

" For TMux {{{
function! Mux()
  echom 'Loaded TMux plugins'
endfunction

command! Mux :call Mux()

if exists('$TMUX')
  :Mux
endif
" }}}

" For VimPlug {{{
function! PlugGx()
  let l:line = getline('.')
  let l:sha  = matchstr(l:line, '^  \X*\zs\x\{7,9}\ze ')

  if (&filetype ==# 'vim-plug')
    " inside vim plug splits such as :PlugStatus
    let l:name = empty(l:sha)
                  \ ? matchstr(l:line, '^[-x+] \zs[^:]\+\ze:')
                  \ : getline(search('^- .*:$', 'bn'))[2:-2]
  else
    " in .vimrc.bundles
    let l:name = matchlist(l:line, '\v/([A-Za-z0-9\-_\.]+)')[1]
  endif

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
  autocmd BufRead,BufNewFile .vimrc.bundles nnoremap <buffer> <silent> gx :call PlugGx()<cr>
  autocmd FileType vim-plug nnoremap <buffer> <silent> gx :call PlugGx()<cr>
augroup END
" }}}

" Temporary {{{

" testing for bullets.vim
nnoremap <leader>m :vs test.md<cr>
nnoremap <leader>q :q!<cr>

"}}}
