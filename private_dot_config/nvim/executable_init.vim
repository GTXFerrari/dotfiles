let mapleader=" "

" VimPlug
call plug#begin('~/local/share/nvim/plugged')

Plug 'vim-airline/vim-airline'                          "Extension that enables a fancy bar at bottom of buffer with relevant info
Plug 'vim-airline/vim-airline-themes'                   "Themes for airline
Plug 'norcalli/nvim-colorizer.lua'                      "Enables hex color values to be shown
Plug 'junegunn/goyo.vim'                                "Goyo focuses text
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

call plug#end()

" Airlinetheme
let g:airline_theme='deus'
let g:airline_powerline_fonts = 1

" Basic settings

syntax on
set encoding=utf-8
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set number relativenumber
set termguicolors

set clipboard+=unnamedplus

" Autocompletion
set wildmode=longest,list,full

" Fix splitting
set splitbelow splitright

" Enable Disable colourizing
map <leader>d :ColorizerAttachToBuffer<CR>
map <leader>D :ColorizerDetachFromBuffer<CR>

map <leader>g :Goyo<CR>
map <leader>G :Goyo!<CR>

" Enable and disable auto comment
map <leader>c :setlocal formatoptions-=cro<CR>
map <leader>C :setlocal formatoptions=cro<CR>

" Enable spell check
map <leader>s :setlocal spell! spelllang=en_us<CR>

" Enable disable auto indent
map <leader>i :setlocal autoindent<CR>
map <leader>I :setlocall noautoindent<CR>

" Shell check
map <leader>P :!clear && shellcheck %<CR>

" Compile and open output
map <leader>r :w! \| !comp <c-r>%<CR><CR>
map <leader>o :!opout <c-r>%<CR><CR>

" Split navigation shortcuts
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Shortcut split opening
nnoremap <leader>h :split<Space>
nnoremap <leader>v :vsplit<Space>
