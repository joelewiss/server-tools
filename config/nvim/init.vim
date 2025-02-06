" Use spaces instead of tabs by default
set expandtab
set tabstop=2
set shiftwidth=2

" Show matching closing bracket
set showmatch
" Show line numbers
set number
" Highlight current line
set cursorline
" Disable mouse
set mouse=
" Make jumps preserve view
set jop=view

call plug#begin(stdpath('data').'/plugged')
    " ==== PLUGINS ====
    Plug 'tpope/vim-sleuth'                             " detects indent style (tabs vs. spaces)
    Plug 'tpope/vim-fugitive'                           " Git integration
    Plug 'tpope/vim-commentary'                         " Commenting tool
    Plug 'vim-airline/vim-airline'                      " Status bar
    Plug 'vim-airline/vim-airline-themes'               " Status bar themes
    Plug 'sainnhe/sonokai'                              " Nice theme
    Plug 'scrooloose/nerdtree'                          " File browser
    Plug 'ryanoasis/vim-devicons'                       " Nice icons
    Plug 'posva/vim-vue'                                " Vue syntax highlighting
    Plug 'MaxMEllon/vim-jsx-pretty'                     " JSX syntax highlighting
    Plug 'nvie/vim-flake8'                              " Flake8 python linting
    Plug 'pappasam/nvim-repl'                           " Easy code insertion into REPL
    Plug 'tpope/vim-repeat'                             " Requirement for above plugin
    Plug 'neoclide/coc.nvim', {'branch': 'release'}     " Code completion


    " ==== PLUGIN CONFIGURATION ====

    " Airline configuration
    "let g:airline#extensions#tabline#enabled = 1
    let g:airline_powerline_fonts = 1
    let g:airline_theme='deus'

    " Sonokai configuration
    let g:sonokai_enable_italic = 1
    let g:sonokai_disable_italic_comment = 1
    let g:sonokai_transparent_background = 1

    " NERDTree configuration
    nmap <silent><C-n> :NERDTreeToggle<CR>
    " Automaticaly close nvim if NERDTree is only thing left open
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " COC configuration
    " This is a lot of configuration so I put it in another file
    source /home/joe/.config/nvim/coc.vim
    
    " nvim-repl configuration
    let g:repl_filetype_commands = {
    \ 'javascript': 'node',
    \ 'python': 'ipython --no-autoindent',
    \ 'scheme': 'racket',
    \ 'haskell': 'ghci',
    \ }
    let g:repl_split = 'right'

    nnoremap <leader>rt :ReplToggle<CR>
    nnoremap <leader>rc :ReplRunCell<CR>
    nmap <leader>rr <Plug>ReplSendLine
    vmap <leader>rr <Plug>ReplSendVisual



    " ==== VIM CONFIGURATION ====

    " Enable colors if available
    if has('termguicolors')
        set termguicolors
    endif
call plug#end()

" Easier buffer switching
map gn :bn<cr>
map gp :bp<cr>
map gd :bd<cr>

" Escape exits insert mode in terminal
tnoremap <Esc> <C-\><C-n>

" Disable hidden
set nohidden

" Disble showing mode
set noshowmode

colorscheme slate
