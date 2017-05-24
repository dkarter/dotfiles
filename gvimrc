" No audible bell
set vb

" No toolbar
set guioptions-=T

" Use console dialogs
set guioptions+=c

set guifont=Fira\ Code:h15
set guifontwide=Fira\ Code:h15
set macligatures

set background=light

" Local config
if filereadable($HOME . '/.gvimrc.local')
  source ~/.gvimrc.local
endif

