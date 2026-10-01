" Enable line numbering
set number

" Use system clipboard (`+`) by default
set clipboard=unnamedplus

" Enable mouse usage, mode 'all'
set mouse=a

" Non-recursive (`nore`) mappings in normal (`n`) mode
" Press `Esc` twice in normal mode to clear last search highlighting
nnoremap <Esc><Esc> :nohlsearch<CR>

" Highlight all matches for the last search pattern
" To disable it, use `set nohlsearch`
set hlsearch

" Enable incremental search
set incsearch

" Currently selected search match
" Inside vim/vimx, run `:highlight CurSearch` to get the default values
highlight CurSearch term=reverse ctermfg=0 ctermbg=White guifg=Black guibg=Cyan

" Highlight current line
set cursorline
highlight CursorLine cterm=None ctermbg=236

" Highlight vertical line
set colorcolumn=79
highlight ColorColumn ctermbg=236

set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
