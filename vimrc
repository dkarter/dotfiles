"=======================================
"    Key Mappings
"=======================================

" Use the space key as our leader. Put this near the top of your vimrc
let mapleader = "\<Space>"

" Split edit your vimrc. Type space, v, r in sequence to trigger
nmap <leader>vr :vsp $MYVIMRC<cr>
nmap <leader>vb :vsp ~/.vimrc.bundles<cr>
" Source (reload) your vimrc. Type space, s, o in sequence to trigger
nmap <leader>so :source $MYVIMRC<cr>

"split edit your tmux conf
nmap <leader>mux :vsp ~/.tmux.conf<cr>

" Easy Motion
nmap <leader>\ <Plug>(easymotion-s)
nmap <leader>w <Plug>(easymotion-w)

"Change cursor on insert mode
let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

" change dir to current file's dir
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" Easy esc/insert
imap jk <esc>     " exits insert mode
imap kj <esc>     " exits insert mode
imap <S-Space> <Esc>
nmap <S-Space> i
inoremap <C-C> <Esc>`^

" Insert Empty Lines
" nmap oo o<Esc>k
" nmap OO O<Esc>j
"
" command typo mapping
cmap WQ wq
cmap Wq wq
cmap W w
cmap Q q

" copy to end of line
map Y y$

" Note that remapping C-s requires flow control to be disabled
" (e.g. in .bashrc or .zshrc)
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>

" easier new tab
map <C-t> <esc>:tabnew<CR>
map <C-c> <esc>:tabclose<CR>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

"=======================================
"    / Key Mappings
"=======================================

"=======================================
"    Behavior Modification
"=======================================
set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set ignorecase    " ignore case in searches
set smartcase     " will use case sensitive if capital letter present or \C
" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab
"=======================================
"    / Behavior Modification
"=======================================

syntax on

" set vim-legend to disabled by default
let g:legend_active_auto = 0

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif


" ==================================================
"    Plugin Modifications (after loading bundles)
" ==================================================

" call ToggleStripWhitespaceOnSave()

" ==================================================
"    / Plugin Modifications (after loading bundles)
" ==================================================

" ==================================================
"         UI Customizations
" ==================================================

" Tweaks for Molokai colorscheme (ignored if Molokai isn't used)
let g:molokai_original=1
let g:rehash256=1

" default color scheme
colorscheme molokai

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
" ==================================================
"         End UI Customizations
" ==================================================

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

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
augroup END


" eliminate delays when opening new lines (may cause issues on slow connections
" if needed switch back to 1000)
set timeoutlen=1000 ttimeoutlen=0




" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Remove trailing whitespace on save for ruby files.
au BufWritePre *.rb :%s/\s\+$//e


" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmenu
set wildmode=list:longest,list:full
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

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" NerdTree
map <Leader>nt :NERDTreeToggle<CR>

" vim-rspec mappings
nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>
nnoremap <Leader>sa :call RunAllSpecs()<CR>

" vim-rspec command - make it use dispatch
let g:rspec_command = "VtrSendCommandToRunner! rspec {spec}"

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Incsearch Vim Plugin
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_eruby_ruby_quiet_messages =
    \ {"regex": "possibly useless use of a variable in void context"}
let g:syntastic_ruby_mri_exec='~/.rvm/rubies/ruby-2.2.1/bin/ruby'
let g:syntastic_javascript_checkers = ['eslint']

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" For powerline python support
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

" Gist.vim
map <leader>gst :Gist<cr>

" set shell to zsh
set shell=/bin/zsh

"=======================================
"    Function Keys
"=======================================

" Relative Numbers on/off
nnoremap <F3> :NumbersToggle<CR>

" re-indent file and jump back to where the cursor was
map <F7> mzgg=G`z

" TagBar plugin toggle
nmap <F8> :TagbarToggle<CR>

"=======================================
"    / Function Keys
"=======================================

"=======================================
"    Snippets (UltiSnips)
"=======================================
" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
"=======================================
"    / Snippets (UltiSnips)
"=======================================

" vim slime
let g:slime_target="tmux"


" Vim/tmux layout rebalancing
" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =
" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" vim tmux runner
nnoremap <leader>irb :VtrOpenRunner {'orientation': 'h', 'percentage': 33, 'cmd': 'irb'}<cr>
nnoremap <leader>pry :VtrOpenRunner {'orientation': 'h', 'percentage': 33, 'cmd': 'pry'}<cr>
nnoremap <leader>or :VtrOpenRunner<cr>
nnoremap <leader>sl :VtrSendLinesToRunner<cr>
nnoremap <leader>fr :VtrFocusRunner<cr>
nnoremap <leader>dr :VtrDetachRunner<cr>
nnoremap <leader>ap :VtrAttachToPane

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif

