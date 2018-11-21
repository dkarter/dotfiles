" No audible bell
set visualbell

" No toolbar
set guioptions-=T

" Use console dialogs
set guioptions+=c

set guifont=Fira\ Code:h15
set guifontwide=Fira\ Code:h15
set macligatures

" Local config
if filereadable($HOME . '/.gvimrc.local')
  source ~/.gvimrc.local
endif
