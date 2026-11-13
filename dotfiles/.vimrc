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

" Indentation
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" === GitGutter configuration ===
" Match the sign column and sign backgrounds to the editor
highlight! link SignColumn Normal
let g:gitgutter_set_sign_backgrounds = 1

" Sign colours: green additions, yellow modifications, red deletions
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

" Sign symbols
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
