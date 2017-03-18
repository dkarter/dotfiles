"  ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄
" ███    ███ ███  ▄██▀▀▀███▀▀▀██▄
" ███    ███ ███▌ ███   ███   ███
" ███    ███ ███▌ ███   ███   ███
" ███    ███ ███▌ ███   ███   ███
" ███    ███ ███  ███   ███   ███
" ███    ███ ███  ███   ███   ███
"  ▀██████▀  █▀    ▀█   ███   █▀

" General settings
  scriptencoding utf-16      " allow emojis in vimrc
  set nocompatible           " vim, not vi
  syntax on                  " syntax highlighting
  filetype plugin indent on  " try to recognize filetypes and load rel' plugins

"  Behavior Modification ----------------------  {{{

  " set leader key
    let g:mapleader="\\"

  " alias for leader key
    nmap <space> \

  " disable bracketed paste
  set t_BE=0

  set background=dark " tell vim what the background color looks like
  set backspace=2     " Backspace deletes like most programs in insert mode
  set history=200     " how many : commands to save in history
  set ruler           " show the cursor position all the time
  set showcmd         " display incomplete commands
  set incsearch       " do incremental searching
  set laststatus=2    " Always display the status line
  set autowrite       " Automatically :write before running commands
  set ignorecase      " ignore case in searches
  set smartcase       " will use case sensitive if capital letter present or \C
  set tabstop=2       " Softtabs or die! use 2 spaces for tabs.
  set shiftwidth=2    " Number of spaces to use for each step of (auto)indent.
  set shiftround      " Round indent to multiple of 'shiftwidth'
  set expandtab       " insert tab with right amount of spacing
  set gdefault        " Use 'g' flag by default with :s/foo/bar/.
  set magic           " Use 'magic' patterns (extended regular expressions).
  set guioptions=     " remove scrollbars on macvim
  set noshowmode      " don't show mode as airline already does
  set showcmd         " show any commands


  if !has('nvim')     " does not work on neovim
    set emoji         " treat emojis 😄  as full width characters
    set termguicolors " enable true colors
  end

  set ttyfast         " should make scrolling faster
  set lazyredraw      " should make scrolling faster

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
" Snippets (UltiSnips)
" ====================================
let g:UltiSnipsListSnippets                = '<c-.>'
let g:UltiSnipsExpandTrigger               = '<tab>'
let g:UltiSnipsJumpForwardTrigger          = '<tab>'
let g:UltiSnipsJumpBackwardTrigger         = '<s-tab>'

" :UltiSnipsEdit opens in a vertical split
let g:UltiSnipsEditSplit                   = 'vertical'
let g:UltiSnipsSnippetsDir                 = ['~/dotfiles/vim/UltiSnips']

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

" ====================================
" setup airline
" ====================================
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#show_buffers = 0

" Bullets.vim
let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text',
    \ 'gitcommit',
    \ 'scratch'
    \]

if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

" =====================================
"  FZF
" =====================================
" set fzf's default input to AG instead of find. This also removes gitignore etc
let $FZF_DEFAULT_COMMAND = 'ag -l -g ""'
let g:fzf_files_options =
  \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'

" Allow JSX in normal JS files
let g:jsx_ext_required = 0

" Use The Silver Searcher for grep https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" ----------------------------------------------------------------------------
" vim slime
" ----------------------------------------------------------------------------
let g:slime_target='tmux'

" ----------------------------------------------------------------------------
" Scratch.vim
" ----------------------------------------------------------------------------
let g:scratch_no_mappings=1

" ----------------------------------------------------------------------------
" Emmet
" ----------------------------------------------------------------------------
" better emmet leader key (must be followed with ,)
let g:user_emmet_leader_key='<C-e>'

" ----------------------------------------------------------------------------
" Rail.vim
" ----------------------------------------------------------------------------
" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" ----------------------------------------------------------------------------
" Vim RSpec
" ----------------------------------------------------------------------------
" vim-rspec command - make it use dispatch
" let g:rspec_command = 'VtrSendCommandToRunner! rspec {spec}'

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" ----------------------------------------------------------------------------
" Vim Flow JS
" ----------------------------------------------------------------------------
let g:flow#autoclose = 1

" ----------------------------------------------------------------------------
" Syntastic
" ----------------------------------------------------------------------------
" configure syntastic syntax checking to check on open as well as save
" let g:syntastic_check_on_open=1
" let g:syntastic_html_tidy_ignore_errors=[]
" let g:syntastic_html_tidy_ignore_errors = [
"     \ ' proprietary attribute \"ng-',
"     \  'plain text isn''t allowed in <head> elements',
"     \  '<base> escaping malformed URI reference',
"     \  'discarding unexpected <body>',
"     \  'escaping malformed URI reference',
"     \  'trimming empty <i>',
"     \  '</head> isn''t allowed in <body> elements'
"     \ ]
" let g:syntastic_eruby_ruby_quiet_messages =
"     \ {'regex': 'possibly useless use of a variable in void context'}
" let g:syntastic_ruby_mri_exec='~/.rvm/rubies/ruby-2.2.2/bin/ruby'
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_shell = '/bin/sh'
" let g:syntastic_mode_map = { 'mode': 'active' }
" let g:syntastic_ruby_checkers = ['mri', 'rubocop']
" let g:syntastic_cucumber_cucumber_args='--profile syntastic'
" let g:syntastic_cucumber_cucumber_exe='bin/cucumber'
" let g:syntastic_warning_symbol = '⚠'
" let g:syntastic_vim_checkers = ['vint']

" ----------------------------------------------------------------------------
" Neomake
" ----------------------------------------------------------------------------
let g:neomake_javascript_enabled_makers = ['eslint']

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
" elm vim - add support for elm-format
" ----------------------------------------------------------------------------
" let g:elm_format_autosave=1

" ----------------------------------------------------------------------------
" NERDTree
" ----------------------------------------------------------------------------
let NERDTreeIgnore=['\.vim$', '\~$', '\.beam', 'elm-stuff']
let NERDTreeShowHidden=1

" ----------------------------------------------------------------------------
" SuperTab
" ----------------------------------------------------------------------------
" let g:SuperTabMappingForward = '<c-k>'
" let g:SuperTabMappingBackward = '<c-j>'

" ----------------------------------------------------------------------------
" goyo.vim + limelight.vim
" ----------------------------------------------------------------------------
let g:limelight_paragraph_span = 1
let g:limelight_priority = -1

function! s:goyo_enter()
  if has('gui_running')
    set fullscreen
    set background=light
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
  Limelight
endfunction

function! s:goyo_leave()
  if has('gui_running')
    set nofullscreen
    set background=dark
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

" for go-vim
augroup CustomGoVimMappings
  autocmd!

  autocmd FileType go setlocal nolist listchars=tab:>-,trail:·,nbsp:·
  autocmd FileType go nmap <buffer> <leader>r <Plug>(go-run)
  autocmd FileType go nmap <buffer> <leader>b <Plug>(go-build)
  autocmd FileType go nmap <buffer> <leader>t <Plug>(go-test)
  autocmd FileType go nmap <buffer> <leader>c <Plug>(go-coverage)
augroup END
" }}}

" UI Customizations --------------------------------{{{
  " Tweaks for Molokai colorscheme (ignored if Molokai isn't used)
  let g:molokai_original=1
  let g:rehash256=1

  " Gruvbox colorscheme allow italics
  let g:gruvbox_italic = 1
  let g:gruvbox_invert_selection=0

  " default color scheme
  colorscheme gruvbox

  " when on dracula
  let g:limelight_conceal_ctermfg = 59
  let g:limelight_conceal_guifg = '#43475b'

  " Make it obvious where 80 characters is
  highlight ColorColumn ctermbg=235 guibg=#2c2d27
  let &colorcolumn=join(range(80,999),',')



  if has('gui_running')
    let s:uname = system('uname')
    if s:uname ==? 'Darwin\n'
        set guifont=Operator\ Mono:h15
    endif
  endif
" -----------------------------------------------------    }}}

" Own commands --------------------------------------------- {{{
command! PrettyPrintJSON %!python -m json.tool
command! PrettyPrintHTML !tidy -mi -html -wrap 0 %
command! PrettyPrintXML !tidy -mi -xml -wrap 0 %
command! BreakLineAtComma :normal! f,.
" }}}

" Auto commands ------------------------------------------------- {{{
  augroup vimrcEx
    autocmd!

    " Remove trailing whitespace on save for ruby files.
    autocmd BufWritePre *.rb :%s/\s\+$//e

    " When editing a file, always jump to the last known cursor position.
    " Don't do it for commit messages, when the position is invalid, or when
    " inside an event handler (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

    " Set syntax highlighting for specific file types
    autocmd BufRead,BufNewFile Appraisals set filetype=ruby
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

    " Use 4 spaces for java
    " autocmd FileType java setlocal shiftwidth=4 tabstop=4

    " Vim/tmux layout rebalancing
    " automatically rebalance windows on vim resize
    autocmd VimResized * :wincmd =
  augroup END

  augroup AutoSaveFolds
    autocmd!
    " add file types as needed
    autocmd BufWinLeave *.c,*.rb mkview
    autocmd BufWinEnter *.c,*.rb silent loadview
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


  " Pasting support
    set pastetoggle=<F2>  " Press F2 in insert mode to preserve tabs when
                          " pasting from clipboard into terminal

  " re-indent file and jump back to where the cursor was
    map <F7> mzgg=G`z

  " Allow j and k to work on visual lines (when wrapping)
    nnoremap k gk
    nnoremap j gj

  " prevent entering ex mode accidentally
    nnoremap Q <Nop>

  " Tab/shift-tab to indent/outdent in visual mode.
    vnoremap <Tab> >gv
    vnoremap <S-Tab> <gv

  " Keep selection when indenting/outdenting.
    vnoremap > >gv
    vnoremap < <gv

  " Search for selected text
    vnoremap * y/<C-R>"<CR>

  " Split edit your vimrc. Type space, v, r in sequence to trigger
    fun! OpenConfigFile(file)
      if (&ft ==? 'startify')
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

  " Scratch:
    nnoremap <leader>sc :Scratch<CR>

    augroup ScratchToggle
      autocmd!
      autocmd FileType scratch nnoremap <buffer> <leader>sc :q<CR>
    augroup END

  " Elm:
    augroup ElmMappings
      autocmd!
      autocmd FileType elm nnoremap <silent> <buffer> <leader>f :ElmFormat<cr>
    augroup END

  " VimPlug:
    nnoremap <leader>pi :PlugInstall<CR>
    nnoremap <leader>pu :PlugUpdate<CR>
    nnoremap <leader>pc :PlugClean<CR>

  " change dir to current file's dir
    nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

  " Tabularize: text alignment
    nmap <Leader>a= :Tabularize /=<CR>
    vmap <Leader>a= :Tabularize /=<CR>
    nmap <Leader>a: :Tabularize /:\zs<CR>
    vmap <Leader>a: :Tabularize /:\zs<CR>

  " zoom a vim pane, <C-w>= to re-balance
    nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
    nnoremap <leader>= :wincmd =<cr>

  " close all other windows with <leader>o
    nnoremap <leader>wo <c-w>o

  " Vim Tmux Runner:
    nnoremap <leader>pry :VtrOpenRunner {'orientation': 'h', 'percentage': 33, 'cmd': 'pry'}<cr>
    nnoremap <leader>or :VtrOpenRunner<cr>
    vnoremap <leader>sl :VtrSendLinesToRunner<cr>
    nnoremap <leader>fr :VtrFocusRunner<cr>
    nnoremap <leader>dr :VtrDetachRunner<cr>
    nnoremap <leader>ap :VtrAttachToPane

  " Gist:
    map <leader>gst :Gist<cr>

  " Index ctags from any project, including those outside Rails
    map <Leader>ct :!ctags -R .<CR>

  " Switch between the last two files
    nnoremap <tab><tab> <c-^>

  " NerdTree:
    nnoremap <Leader>nt :NERDTreeToggle<CR>

  " Vim Rspec:
    nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
    nnoremap <Leader>T :call RunNearestSpec()<CR>
    nnoremap <Leader>l :call RunLastSpec()<CR>
    nnoremap <Leader>sa :call RunAllSpecs()<CR>


  " Vim Scriptease:
    " Run commands that require an interactive shell
      nnoremap <Leader>ri :RunInInteractiveShell<space>

    " Reload current vim plugin
      nnoremap <Leader>rr :Runtime<cr>

  " CopyRTF: Copy code as RTF
    nnoremap <silent> <leader><C-c> :set nonumber<CR>:CopyRTF<CR>:set number<CR>

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

  " Goyo:
    nnoremap <Leader>G :Goyo<CR>


  " FZF:
    nnoremap <C-b> :Buffers<CR>
    nnoremap <C-g>g :Ag<CR>
    nnoremap <C-g>c :Commands<CR>
    nnoremap <C-f>l :BLines<CR>
    nnoremap <C-p> :Files<CR>

    " Insert Mode:
      imap <c-x><c-k> <plug>(fzf-complete-word)
      imap <c-x><c-f> <plug>(fzf-complete-path)
      imap <c-x><c-j> <plug>(fzf-complete-file-ag)
      imap <c-x><c-l> <plug>(fzf-complete-line)


  " CtrlSF:
    nnoremap <C-F>f :CtrlSF
    nnoremap <C-F>g :CtrlSF<CR>

  " easier new tab
    noremap <C-t> <esc>:tabnew<CR>
    noremap <C-c> <esc>:tabclose<CR>

  " Get off my lawn: disable arrow keys in normal mode
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

  " hlsearch toggle
    " nnoremap <silent> <esc> :set nohlsearch<CR>

" --------------------- Key Mappings ---------------------------- }}}

"    Abbreviations --------------------------------------- {{{

iabbrev @@ dkarter@gmail.com
iabbrev ccopy Copyleft 2016 Dorian Karter.

" Local config
if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif
" -------- Abbreviations ---------------------------------- }}}

" For NeoVim ----------------------------------------------------- {{{
if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
endif
" }}}

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
      
command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
      
command! -bang -nargs=? -complete=dir GFiles
      \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)
      
command! -bang -nargs=? -complete=dir Buffers
      \ call fzf#vim#buffers(<q-args>, fzf#vim#with_preview(), <bang>0)
  
" --------------------------------------------------}}}

" Temporary"{{{

" testing for bullets.vim
" nnoremap <leader>m :vs test.md<cr>
" nnoremap <leader>q :q!<cr>"}}}
