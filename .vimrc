syntax on
set et
set sts=4
set sw=4
set ai

set nowrap

if has("autocmd")
    autocmd FileType xml setlocal formatoptions=t
    autocmd FileType xml setlocal textwidth=120
    autocmd FileType xml setlocal encoding=utf-8
    autocmd FileType xml setlocal shiftwidth=2
    autocmd FileType xml setlocal softtabstop=2
    autocmd FileType xml setlocal visualbell
    autocmd FileType xml setlocal noerrorbells
    autocmd FileType xml setlocal number
    autocmd FileType xml setlocal autoindent
    autocmd FileType xml setlocal ruler
    autocmd FileType xml setlocal whichwrap=<,>,h,l
    autocmd FileType xml setlocal backspace=2
    autocmd FileType xml setlocal backup
    autocmd FileType xml setlocal wildmenu
    autocmd FileType xml setlocal nrformats=
    autocmd FileType xml setlocal foldlevelstart=99
    autocmd FileType xml setlocal shcf=-ic
endif

" WinManager behavior
let g:explVertical = 1
let g:persistentBehaviour = 0


nmap <S-Down>   <C-w>w
nmap <S-Up>     <C-w>W
nmap <S-Left>   <C-w>h
nmap <S-Right>  <C-w>l

" colorscheme ron
set guioptions=aegirLt

