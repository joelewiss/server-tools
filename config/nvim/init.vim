" Use spaces instead of tabs by default
" This is changed by files in ~/.vim/after/ftplugin
set expandtab
set tabstop=2
set shiftwidth=2

" Show matching closing bracket
set showmatch
" Show line numbers
set number

call plug#begin(stdpath('data').'/plugged')
    " Editing
    Plug 'tpope/vim-sleuth' " detect indent style (tabs vs. spaces)

    " Status bar and editor enhancements
    Plug 'vim-airline/vim-airline'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_powerline_fonts = 1
    Plug 'scrooloose/nerdtree'
    Plug 'ryanoasis/vim-devicons'
    " Toggle NERDTree
    nmap <silent><C-n> :NERDTreeToggle<CR>
    " Automaticaly close nvim if NERDTree is only thing left open
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " Syntax Plugins
    Plug 'tpope/vim-fugitive'
    Plug 'posva/vim-vue'
    Plug 'MaxMEllon/vim-jsx-pretty'
    Plug 'nvie/vim-flake8'


    " Theming
    Plug 'vim-airline/vim-airline-themes'
    Plug 'sainnhe/edge'
    "Plug 'sainnhe/sonokai'

    " Enable colors if available
    if has('termguicolors')
        set termguicolors
    endif

    " Edge configuration
    let g:edge_style = 'neon'
    let g:edge_enable_italic = 0
    let g:edge_disable_italic_comment = 1
    " let g:airline_theme='edge'

call plug#end()

colorscheme default
