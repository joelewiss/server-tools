" Turn off compatibility mode
set nocp

" Load Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'



" Enable vim-airline
Plugin 'vim-airline/vim-airline'
let g:airline#extensions#tabline#enabled = 1

" Enable airline theme
Plugin 'vim-airline/vim-airline-themes'
let g:airline_theme='badwolf'

Plugin 'tpope/vim-fugitive'
Plugin 'posva/vim-vue'
let g:vue_pre_processors = []

Plugin 'pangloss/vim-javascript'

" Done with Vundle
call vundle#end()
filetype plugin indent on



" Turn on nubmers
set number

" Use spaces instead of tabs by default
" This is changed by files in ~/.vim/after/ftplugin
set expandtab
set tabstop=4
set shiftwidth=4

" Turn on autoindent and smartindent
filetype indent on
"set autoindent
set smartindent
"set cindent

" Turn on vim ruler (shows line,col number)
set ruler

" Highlight text over 80 chars
"augroup vimrc_autocmds
"    autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#111111
"    autocmd BufEnter * match OverLength /\%>80v.\+/
"augroup END

" Allow backspace to delete autoindent, eol, and start of insert
set backspace=indent,eol,start

colorscheme desert

syntax enable

" Enable wildmenu
set wildmenu
set wildmode=longest:full,full

" Tab navigation like Firefox.
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>
