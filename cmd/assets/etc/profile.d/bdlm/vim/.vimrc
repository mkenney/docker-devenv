
" Stop opening help with F1
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

set nocompatible
filetype off


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" wish i knew about this sooner...
set showcmd

" open splits to the right
set splitbelow
set splitright

" move to the beginning of the next line when trying to move past the end of
" the current line
set whichwrap+=h,l
set whichwrap+=<,>,[,] " this is for the arrow keys

" insert a blank line in normal mode
nnoremap <CR> o<Esc>

" Source .vimrc on save
autocmd! BufWritePost ~/.vimrc nested :source ~/.vimrc

" Performance enhancements
set timeoutlen=1000 ttimeoutlen=0
set ttyfast        " improves vim scrolling and redraws buffer screen updates
set lazyredraw     " instead of updating all the time

set noerrorbells   " disable error bells
set shell=bash     " set the shell environment

" move screen with cursor when not scrolling with the arrow keys
noremap j j<c-e>
noremap k k<c-y>

" move around split windows with control+movment key
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" toggle between two windows
nnoremap <tab><tab> <c-w><c-w>

" mouse support
set mouse=a
set ttymouse=xterm2

" enable showing matching enclosing characters
set showmatch

" Disable 'textwidth'
set textwidth=0

" spelling
set spelllang=en
set spellfile=$HOME/.vim/data/en.utf-8.add
setlocal nospell

" File explorer tree list
let g:netrw_liststyle = 0

" Hide the file explorer banner
let g:netrw_banner = 0

" Open method for file browser
let g:netrw_browse_split = 0 " Open in current window
"let g:netrw_browse_split = 1 " Open files in a new horizontal split
"let g:netrw_browse_split = 2 " Open files in a new vertical split
"let g:netrw_browse_split = 3 " Open files in a new tab
"let g:netrw_browse_split = 4 " Open in previous window

" Default split width 50%
let g:netrw_winsize = 50

"
let g:netrw_altv = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Terminal configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" term colors
set t_ut=             " Fixes the background color in vim when using tmux
                      " (https://sunaku.github.io/vim-256color-bce.html)
set t_Co=256          " Force 256 colors in terminal
"set t_AB=^[[48;5;%dm " ?
"set t_AF=^[[38;5;%dm " ?

" previous / next buffers
set hidden
map <S-h> :bprev<CR>
map <S-l> :bnext<CR>
map <S-Left> :bprev<CR>
map <S-Right> :bnext<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ignore caps for some commands
command WQ wq
command Wq wq
command W w
command Q q

command JsonFmt %!python -m json.tool
command Sp setlocal spell
command SpOff setlocal nospell

" browse recent files
command! Bo browse oldfiles


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tmux
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Rename tmux pane based on which file is open
autocmd BufEnter * call system("tmux rename-window 'vim ".expand("%:t")."'")
autocmd VimLeave * call system("tmux rename-window bash")
autocmd BufEnter * let &titlestring = ' '.expand("%:t")


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" sessions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let vimDir = expand('$HOME/.vim')

" Keep undo history across sessions
if has('persistent_undo')
    let myUndoDir = vimDir.'/undo'
    call system('mkdir -p '.myUndoDir)
    let &undodir = myUndoDir
    set undolevels=5000
    set undofile
endif

" Tell vim to remember certain things on exit
"  '10  : marks will be remembered for up to 10 previously edited files
"  "100 : will save up to 100 lines for each register
"  :500 : up to 500 lines of command-line history will be remembered
"  %    : saves and restores the buffer list
"  n... : where to save the viminfo files
let myDataDir = vimDir.'/data'
call system('mkdir -p '.myDataDir)
set viminfo='10,\"100,:500,%,n~/.vim/data/viminfo

" remember the last 1000 commands
set history=1000

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" search settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" case-insensitive search
set ignorecase
" case-sensitive once I type an uppercase char...
set smartcase
" incremental search
set incsearch
" highlight matches
set hlsearch
" Enable enhanced command line completion.
set wildmenu wildmode=list:full
" Ignore these filenames during enhanced command line completion.
set wildignore+=*.aux,*.out,*.toc " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png " binary images
set wildignore+=*.luac " Lua byte code
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.pyc " Python byte code
set wildignore+=*.spl " compiled spelling word lists
set wildignore+=*.sw? " Vim swap files
" omnicomplete from: http://vim.wikia.com/wiki/VimTip1386
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
    \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" type '//' to search for visually seleted text
vnoremap // y/<C-R>"<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" line wrapping
set wrap
set linebreak
set textwidth=0
set wrapmargin=0

" Move vertically correctly across wrapped lines
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" keep at least 5 offsets around the cursor
set scrolloff=5
set sidescrolloff=10

" show tabs and trailing whitespace
"set list
"set listchars=tab:>·,trail:·

" leave cursor position alone
set nostartofline

" backspace over newlines
set backspace=2

" don’t update screen during macro and script execution
set lazyredraw

" always display the status bar
set laststatus=2

" always display the cursor position
set ruler

" automatically re-read files if unmodified inside vim
set autoread

" set working directory to current file
" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | lcd %:p:h | endif

" indentation
set autoindent
set smartindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set shiftround
set copyindent
set preserveindent
filetype plugin indent on

" Trim trailing spaces
autocmd BufWritePre * %s/\s\+$//e

" show line numbers
set nu
"set relativenumber

" Fonts
set gfn=Monospace\ 12
set encoding=utf8

" don't create swp files
set nobackup
set noswapfile

" type 'ii' to switch from insert to command mode
imap ii <C-[>

" when reopening a file, tell vim to restore the cursor to the saved position
augroup JumpCursorOnEdit
 au!
 autocmd BufReadPost *
 \ if expand("<afile>:p:h") !=? $TEMP |
 \ if line("'\"") > 1 && line("'\"") <= line("$") |
 \ let JumpCursorOnEdit_foo = line("'\"") |
 \ let b:doopenfold = 1 |
 \ if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
 \ let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
 \ let b:doopenfold = 2 |
 \ endif |
 \ exe JumpCursorOnEdit_foo |
 \ endif |
 \ endif
 " Need to postpone using "zv" until after reading the modelines.
 autocmd BufWinEnter *
 \ if exists("b:doopenfold") |
 \ exe "normal zv" |
 \ if(b:doopenfold > 1) |
 \ exe "+".1 |
 \ endif |
 \ unlet b:doopenfold |
 \ endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntax hilighting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax on

" PHP Generated Code Highlights (HTML & SQL)
let php_sql_query=1
let php_htmlInStrings=1

silent! colorscheme darkblue
silent! colorscheme distinguished

set background=dark

" Vertical split separator
set fillchars+=vert:\│
hi VertSplit ctermbg=0 ctermfg=4

" Column highlight
set colorcolumn=78
hi ColorColumn ctermbg=235

" Cursor color
"hi cursor cterm=NONE ctermbg=019
"set cursor

" Cursor line color
set cursorline
hi CursorLine ctermfg=none ctermbg=17
autocmd InsertEnter * highlight CursorLine ctermbg=52
autocmd InsertLeave * highlight CursorLine ctermbg=17

" Cursor column color
hi cursorcolumn ctermbg=235

" visual selection color
hi Visual ctermbg=236 ctermfg=none

" line number color
hi LineNr ctermfg=8 ctermbg=0
hi CursorLineNr ctermfg=255  ctermbg=17
autocmd InsertEnter * highlight CursorLineNr ctermbg=52
autocmd InsertLeave * highlight CursorLineNr ctermbg=17

hi NonText ctermfg=4

" make the cursor an underscore
"let &t_SI .= "\<Esc>[3 q"
"let &t_EI .= "\<Esc>[3 q"

" make the cursor a vertical line
let &t_SI .= "\<Esc>[35 q"
let &t_EI .= "\<Esc>[35 q"

" syntax colors
hi Comment      term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=#80a0ff guibg=NONE
"hi Constant     term=underline cterm=NONE ctermfg=Magenta ctermbg=NONE gui=NONE guifg=#ffa0a0 guibg=NONE
"hi Special      term=bold cterm=NONE ctermfg=LightRed ctermbg=NONE gui=NONE guifg=Orange guibg=NONE
"hi Identifier   term=underline cterm=bold ctermfg=Cyan ctermbg=NONE gui=NONE guifg=#40ffff guibg=NONE
"hi Statement    term=bold cterm=NONE ctermfg=Yellow ctermbg=NONE gui=bold guifg=#ffff60 guibg=NONE
"hi PreProc      term=underline cterm=NONE ctermfg=LightBlue ctermbg=NONE gui=NONE guifg=#ff80ff guibg=NONE
"hi Type         term=underline cterm=NONE ctermfg=LightGreen ctermbg=NONE gui=bold guifg=#60ff60 guibg=NONE
"hi Underlined   term=underline cterm=underline ctermfg=LightBlue gui=underline guifg=#80a0ff
"hi Ignore       term=NONE cterm=NONE ctermfg=Black ctermbg=NONE gui=NONE guifg=bg guibg=NONE
hi String       term=NONE cterm=NONE ctermfg=DarkGreen ctermbg=NONE gui=NONE guifg=bg guibg=NONE
hi Search       term=bold cterm=bold ctermfg=white ctermbg=blue

" diff highlighting
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=21 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

" rainbow parens
let g:rainbow_active = 1
highlight MatchParen ctermbg=darkblue guibg=blue

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set fillchars+=fold:·
"
"function! FunctionFold()
"    setl foldmethod=syntax
"    setl foldlevelstart=1
"    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
"
"    function! FoldText()
"        return substitute(getline(v:foldstart), '{.*', '{...}', '')
"    endfunction
"    setl foldtext=FoldText()
"endfunction
"
"au FileType javascript call FunctionFold()
"au FileType javascript setl fen
"au FileType php call FunctionFold()
"au FileType php setl fen
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" leader keys, etc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" space is better but don't break it for everyone else. And it'll show in the
" command corner
map <space> <Leader>

" Toggle the cursor column
nnoremap <Leader>c :set cursorcolumn!<CR>

" clear out the current search
nnoremap <leader>/ :noh<cr>

" Select the text that was just pasted
nnoremap <leader>a V`]

" Save the current buffer
nnoremap <leader>s :w<cr>

" list open buffers and prompt to select one
nnoremap <leader>l :ls<cr>:b<space>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Don't load plugins in old versions
if v:version < 705
    finish
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" install command t
Plugin 'wincent/command-t'
" these aren't working for some reason
"let g:CommandTHighlightColor = 'MediumBlue'
"let g:CommandTCursorColor = 'MediumBlue'

" install control p
"Plugin 'ctrlpvim/ctrlp.vim'
"let g:ctrlp_show_hidden = 1

" undo-tree interface: https://sjl.bitbucket.io/gundo.vim/
Plugin 'sjl/gundo.vim'
let g:gundo_preview_bottom = 1
let g:gundo_preview_statusline = 1
let g:gundo_tree_statusline = 1
let g:gundo_auto_preview = 1
let g:gundo_close_on_revert = 1
let g:gundo_width = 30
nnoremap <F1> :GundoToggle<CR>

Bundle 'scrooloose/syntastic'
let g:syntastic_php_checkers = ['php', 'phpcs']

" Snippet plugin
Plugin 'SirVer/ultisnips'
" Snippet trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-p>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Taglist
Plugin 'vim-scripts/taglist.vim'
nmap <F2> :TlistToggle<CR>
let g:Tlist_GainFocus_On_ToggleOpen = 1
"noremap <silent> <F2> :TlistToggle<CR>

" Display buffers as tabs
Bundle 'mkenney/vim-buftabline'
"g:buftabline_indicators = 1 " causes errors in scripted operations for some
                            " reason...

" Syntax highlighting scheme
Bundle 'Lokaltog/vim-distinguished'

" Git gutter
Bundle 'airblade/vim-gitgutter'

" Minimap
Plugin 'severin-lemaignan/vim-minimap'

" Marks gutter
Bundle 'kshenoy/vim-signature'

" Snippet lib
Plugin 'mkenney/vim-snippets'

" surround functionality
Plugin 'tpope/vim-surround'

" YouCompleteMe
Plugin 'Valloric/YouCompleteMe'
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1

Plugin 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=234  ctermbg=234
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=NONE ctermbg=NONE

" All plugins must be added before the following lines
call vundle#end()            " required
filetype plugin indent on    " required
