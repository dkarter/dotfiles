autocmd BufNewFile,BufRead * if search('{{.\+}}', 'nw') | setlocal filetype=helm | endif
