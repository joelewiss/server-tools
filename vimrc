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
let g:airline_powerline_fonts = 1

" Enable airline theme
Plugin 'vim-airline/vim-airline-themes'
let g:airline_theme='badwolf'

Plugin 'tpope/vim-fugitive'
Plugin 'posva/vim-vue'
let g:vue_pre_processors = []

Plugin 'pangloss/vim-javascript'
Plugin 'MaxMEllon/vim-jsx-pretty'
Plugin 'preservim/nerdtree'
Plugin 'nvie/vim-flake8'

" Done with Vundle
call vundle#end()
filetype plugin indent on



" Turn on nubmers
set number

" Use spaces instead of tabs by default
" This is changed by files in ~/.vim/after/ftplugin
set expandtab
set tabstop=2
set shiftwidth=2

" Turn on autoindent and smartindent
set autoindent
set smartindent
"set cindent

" Turn on vim ruler (shows line,col number)
set ruler

" Highlight text over 80 chars
augroup vimrc_autocmds
    autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#111111
    autocmd BufEnter * match OverLength /\%>80v.\+/
augroup END

" Start NERDTree and put the cursor back in the other window
"autocmd VimEnter * NERDTree | wincmd p

" Allow backspace to delete autoindent, eol, and start of insert
set backspace=indent,eol,start

colorscheme default

syntax enable

" Enable wildmenu
set wildchar=<Tab> wildmenu wildmode=longest:full,full
