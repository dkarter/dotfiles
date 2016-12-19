" No audible bell
set vb

" No toolbar
set guioptions-=T

" Use console dialogs
set guioptions+=c

set guifont=Source\ Code\ Pro\ for\ Powerline:h24

" Local config
if filereadable($HOME . '/.gvimrc.local')
  source ~/.gvimrc.local
endif

