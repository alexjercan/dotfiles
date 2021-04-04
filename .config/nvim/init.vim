set path+=**
" Nice menu when typing `:find *.py`
set wildmode=longest,list,full
set wildmenu
" Ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*

call plug#begin('~/.vim/plugged')

" Yes, I am a sneaky snek now
Plug 'ambv/black'

" Plebvim lsp Plugins
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'tjdevries/nlua.nvim'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'onsails/lspkind-nvim'

" Icons
Plug 'kyazdani42/nvim-web-devicons'

" Neovim Tree shitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Debugger Plugins
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

" Git Pluggins
Plug 'TimUntersberger/neogit'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" Man pages in vim
Plug 'vim-utils/vim-man'

" Undo Tree
Plug 'mbbill/undotree'

" Todo List
Plug 'vuciv/vim-bujo'

" Practice vim
Plug 'theprimeagen/vim-be-good'

Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-projectionist'

" Color Theme
Plug 'gruvbox-community/gruvbox'

" telescope requirements...
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'colepeters/spacemacs-theme.vim'

" prettier
Plug 'sbdchd/neoformat'

call plug#end()

let mapleader = " "

augroup buffer_utils
    	autocmd!
    	autocmd BufWritePre * %s/\s\+$//e " trim whitespaces
	autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
    	autocmd BufEnter,BufWinEnter,TabEnter * :lua require'lsp_extensions'.inlay_hints{}
augroup END

