syntax on


"  Behavior Modification ----------------------  {{{
let mapleader="\\"

set backspace=2  " Backspace deletes like most programs in insert mode
set history=100  " how many : commands to save in history
set ruler        " show the cursor position all the time
set showcmd      " display incomplete commands
set incsearch    " do incremental searching
set laststatus=2 " Always display the status line
set autowrite    " Automatically :write before running commands
set ignorecase   " ignore case in searches
set smartcase    " will use case sensitive if capital letter present or \C
set tabstop=2    " Softtabs or die! 2 spaces FTW!
set shiftwidth=2 " Number of spaces to use for each step of (auto)indent.
set shiftround   " Round indent to multiple of 'shiftwidth'
set expandtab    " insert tab with right amount of spacing
set gdefault     " Use 'g' flag by default with :s/foo/bar/.
set magic        " Use 'magic' patterns (extended regular expressions).


" set where swap file and undo/backup files are saved
set backupdir=~/.vim/tmp,.
set directory=~/.vim/tmp,.

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" set shell to zsh
set shell=/bin/zsh

" eliminate delays when opening new lines (may cause issues on slow connections
" if needed switch back to 1000)
set timeoutlen=1000 ttimeoutlen=0

set wildmenu
set wildmode=list:longest,list:full

" " highlight fenced code blocks in markdown
let g:markdown_fenced_languages = [
      \ 'html',
      \ 'elm',
      \ 'vim',
      \ 'js=javascript',
      \ 'python',
      \ 'ruby',
      \ 'sql',
      \ 'bash=sh'
      \ ]

" enable folding in bash files
let g:sh_fold_enabled=1
" }}}

"  Plugin Modifications (BEFORE loading bundles) ----- {{{

" Bullets.vim
let g:bullets_enabled_file_types = [
    \ 'markdown', 
    \ 'text', 
    \ 'gitcommit',
    \ 'scratch'
    \]

" Allow JSX in normal JS files
let g:jsx_ext_required = 0 

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" vim slime
let g:slime_target="tmux"

" scratch.vim
let g:scratch_no_mappings=1

" better emmet leader key (must be followed with ,)
let g:user_emmet_leader_key='<C-e>'

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" vim-rspec command - make it use dispatch
let g:rspec_command = "VtrSendCommandToRunner! rspec {spec}"

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" syntastic ---------------------------------------------------------- {{{
" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[]
let g:syntastic_html_tidy_ignore_errors = [
    \ ' proprietary attribute \"ng-',
    \  'plain text isn''t allowed in <head> elements',
    \  '<base> escaping malformed URI reference',
    \  'discarding unexpected <body>',
    \  'escaping malformed URI reference',
    \  'trimming empty <i>',
    \  '</head> isn''t allowed in <body> elements'
    \ ]
let g:syntastic_eruby_ruby_quiet_messages =
    \ {"regex": "possibly useless use of a variable in void context"}
let g:syntastic_ruby_mri_exec='~/.rvm/rubies/ruby-2.2.2/bin/ruby'
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_shell = '/bin/sh'
let g:syntastic_mode_map = { 'mode': 'active' }
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_cucumber_cucumber_args="--profile syntastic"
let g:syntastic_cucumber_cucumber_exe='bin/cucumber'
let g:syntastic_warning_symbol = "⚠"
" ----------- syntastic -------------------------------}}}

" Use Dash.app for documentation of word under cursor
let g:investigate_use_dash=1

" set vim-legend to disabled by default
let g:legend_active_auto = 0

" vim header (startify)
let g:startify_custom_header = [
        \ '                                 ________  __ __        ',
        \ '            __                  /\_____  \/\ \\ \       ',
        \ '    __  __ /\_\    ___ ___      \/___//''/''\ \ \\ \    ',
        \ '   /\ \/\ \\/\ \ /'' __` __`\        /'' /''  \ \ \\ \_ ',
        \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \      /'' /''__  \ \__ ,__\',
        \ '    \ \___/  \ \_\ \_\ \_\ \_\    /\_/ /\_\  \/_/\_\_/  ',
        \ '     \/__/    \/_/\/_/\/_/\/_/    \//  \/_/     \/_/    ',
        \ '',
        \ '',
        \ ]
let g:startify_custom_header +=  map(split(system('fortune | cowsay -f $(cowsay -l | tail -n +2 | tr " " "\n" | gshuf -n1)'), '\n'), '"   ". v:val') + ['','']

let g:startify_files_number = 5

"Change cursor on insert mode (vim-hashrocket)
let g:use_cursor_shapes = 1

" elm vim - add support for elm-format
let g:elm_format_autosave=1

" ----------------------------------------------------- }}}

" Load all plugins ------------------------------- {{{
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif
" }}}

"  Plugin Modifications (AFTER loading bundles) ----- {{{

" For powerline python support
if has('python')
  python from powerline.vim import setup as powerline_setup
  python powerline_setup()
  python del powerline_setup
endif

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

" default color scheme
colorscheme spacegray

" Make it obvious where 80 characters is
set textwidth=80
highlight ColorColumn ctermbg=235 guibg=#2c2d27
let &colorcolumn=join(range(80,999),",")
" let &colorcolumn="80,".join(range(120,999),",")

" visual bell for errors
set visualbell

" Numbers
set number
set numberwidth=1

" nowrap by default
set nowrap

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

set cursorline    " highight current line where cursor is

if has("gui_running")
   let s:uname = system("uname")
   if s:uname == "Darwin\n"
      set guifont=Inconsolata\ for\ Powerline:h15
   endif
endif
" -----------------------------------------------------    }}}

filetype plugin indent on

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

" Tab completion ------------------------------------------- {{{
" will insert tab at beginning of line,
" will use completion if not at beginning
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>
" }}}

"    Snippets (UltiSnips) -------------------------------- {{{
" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.

let g:UltiSnipsExpandTrigger="<C-x>u"
let g:UltiSnipsListSnippets="<c-.>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" -------------   Snippets (UltiSnips) ------------------- }}}

" Better split management, kept in sync with tmux' -- {{{
"" noremap <leader>- :sp<CR><C-w>j
"" noremap <leader>\| :vsp<CR><C-w>l
" }}}

"  Key Mappings -------------------------------------------------- {{{

"  Function Keys ------------------------------- {{{

" Pasting support
set pastetoggle=<F2>  " Press F2 in insert mode to preserve tabs when pasting from clipboard into terminal

" re-indent file and jump back to where the cursor was
map <F7> mzgg=G`z

" TagBar plugin toggle
nmap <F8> :TagbarToggle<CR>

" toggle Vim Legend
nmap <F9> :LegendToggle<CR>

" }}}

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" vim tmux runner
nnoremap <leader>irb :VtrOpenRunner {'orientation': 'h', 'percentage': 33, 'cmd': 'irb'}<cr>
nnoremap <leader>pry :VtrOpenRunner {'orientation': 'h', 'percentage': 33, 'cmd': 'pry'}<cr>
nnoremap <leader>or :VtrOpenRunner<cr>
vnoremap <leader>sl :VtrSendLinesToRunner<cr>
nnoremap <leader>fr :VtrFocusRunner<cr>
nnoremap <leader>dr :VtrDetachRunner<cr>
nnoremap <leader>ap :VtrAttachToPane

" Alignment stuff
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

"    indentation ------------------------------------------ {{{
" Tab/shift-tab to indent/outdent in visual mode.
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
" Keep selection when indenting/outdenting.
vnoremap > >gv
vnoremap < <gv
" }}}

" Own commands --------------------------------------------- {{{
command! PrettyPrintJSON %!python -m json.tool
command! PrettyPrintHTML !tidy -mi -html -wrap 0 %
command! PrettyPrintXML !tidy -mi -xml -wrap 0 %
command! BreakLineAtComma :normal! f,.
" }}}

" Split edit your vimrc. Type space, v, r in sequence to trigger
nnoremap <leader>vr :vsp $MYVIMRC<cr>
nnoremap <leader>vb :vsp ~/.vimrc.bundles<cr>
" Source (reload) your vimrc. Type space, s, o in sequence to trigger
nnoremap <leader>so :source $MYVIMRC<cr>

"split edit your tmux conf
nnoremap <leader>mux :vsp ~/.tmux.conf<cr>

" Scratch
nnoremap <leader><space> :Scratch<CR>

augroup ScratchToggle
  autocmd FileType scratch nnoremap <buffer> <leader><space> :q<CR>
augroup END

" Vim Plug
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pu :PlugUpdate<CR>
nnoremap <leader>pc :PlugClean<CR>

" change dir to current file's dir
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>


" Command prompt mappings ------------------------- {{{
" command typo mapping
cnoremap WQ wq
cnoremap Wq wq
cnoremap QA qa
cnoremap qA qa
cnoremap Q! q!
" --------- Command prompt mapping ---------------- }}}

" copy to end of line
nnoremap Y y$
" copy to system clipboard
noremap gy "*y
" copy whole file to system clipboard
nnoremap gY gg"*yG

" FZF shortcuts
nnoremap <C-p> :FZF<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-m> :Maps<CR>

" Note that remapping C-s requires flow control to be disabled
" (e.g. in .bashrc or .zshrc)
noremap <C-s> <esc>:w<CR>
inoremap <C-s> <esc>:w<CR>

" easier new tab
noremap <C-t> <esc>:tabnew<CR>
noremap <C-c> <esc>:tabclose<CR>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" function! DeleteSurroundDorian()
"   let first_char = :`<
"   echo first_char
"   " call :normal! viw<esc>lxbhxe
" endfunction

" vimsurround in a nutshell
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>d" viw<esc>lxbhxe
vnoremap <leader>" :s/\v<(.*)/"\1"/<cr>

" Insert mode mappings ------------------------ {{{
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
" ---------------- Insert mode mappings ------- }}}

" Gist.vim
map <leader>gst :Gist<cr>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" NerdTree
map <Leader>nt :NERDTreeToggle<CR>

" vim-rspec mappings
nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader>T :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>
nnoremap <Leader>sa :call RunAllSpecs()<CR>

" Run commands that require an interactive shell
nnoremap <Leader>ri :RunInInteractiveShell<space>

" Reload current vim plugin
nnoremap <Leader>rr :Runtime<cr>

" Incsearch Vim Plugin
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" leader leader to open commands fzf
nnoremap <leader><leader> :Commands<CR>

" --------------------- Key Mappings ---------------------------- }}}

"    Abbreviations --------------------------------------- {{{

iabbrev @@ dkarter@gmail.com
iabbrev ccopy Copyleft 2016 Dorian Karter.

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
" -------- Abbreviations ---------------------------------- }}}

