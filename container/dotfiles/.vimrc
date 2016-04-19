

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle configuration - keep this first
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"Bundle 'joonty/vim-phpqa'

"Bundle 'joonty/vim-phpunitqf'

Bundle 'scrooloose/syntastic'
let g:syntastic_php_checkers = ['php', 'phpcs']

Bundle 'scrooloose/nerdtree'
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.sw?$']
noremap gn :NERDTree<Cr>
function! StartUp()
    if 0 == argc()
        NERDTree
    end
endfunction
autocmd VimEnter * call StartUp()

" Minimap
Plugin 'severin-lemaignan/vim-minimap'

"Bundle 'ervandew/supertab'
"let g:SuperTabDefaultCompletionType = ""

" Mess detector config
"let g:phpqa_messdetector_ruleset = "/path/to/phpmd.xml"

" CodeSniffer rules
"let g:phpqa_codesniffer_args = "--standard=Zend"
"let g:phpqa_codesniffer_args = "--standard=~/.phpcs_rules.xml"

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Powerline configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set laststatus=2
set rtp+=/usr/share/powerline/bindings/vim
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" terminal settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocp
set t_ut=
set t_Co=256
"set t_AB=^[[48;5;%dm
"set t_AF=^[[38;5;%dm
set mouse=a
set noerrorbells
set ttyfast
set shell=bash
" move screen with cursor when not using arrow keys
noremap j j<c-e>
noremap k k<c-y>
" previous / next buffers
map <C-j> :bprev<CR>
map <C-k> :bnext<CR>
set hidden
" ignore caps for some commands
:command WQ wq
:command Wq wq
:command W w
:command Q q

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" sessions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Keep undo history across sessions by storing it in a file
let vimDir = '$HOME/.vim'
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

" Tell vim to remember certain things when we exit
"  '10 : marks will be remembered for up to 10 previously edited files
"  "100 : will save up to 100 lines for each register
"  :5000 : up to 5000 lines of command-line history will be remembered
"  % : saves and restores the buffer list
"  n... : where to save the viminfo files
set viminfo='10,\"100,:5000,%,n~/.viminfo


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" search settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" case-insensitive search
set ignorecase
" case-sensitive once I type an uppercase char...
set smartcase
" Incremental search
set incsearch
" highlight matches
set hlsearch
" Enable enhanced command line completion.
set wildmenu wildmode=list:full
" Ignore these filenames during enhanced command line completion.
set wildignore+=*.aux,*.out,*.toc " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif " binary images
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" editing
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" line wrapping
set wrap
set linebreak
set textwidth=0
set wrapmargin=0
" Move vertically across wrapped lines when in insert mode
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
" keep at least 5 offsets around the cursor
set scrolloff=5
set sidescrolloff=5
" show tabs and trailing whitespace
set list
set listchars=tab:>·,trail:·
" leave cursor position alone
set nostartofline
" backspace over newlines
set backspace=2

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

"syntax hilighting
syntax on

" PHP Generated Code Highlights (HTML & SQL)
let php_sql_query=1
let php_htmlInStrings=1

" code folding
"let g:php_folding=2
"set foldmethod=syntax

" Trim trailing spaces
autocmd BufWritePre *.* :%s/\s\+$//e

" Fonts
set gfn=Monospace\ 12
set encoding=utf8

" show line numbers
set nu

" don't create swp files
set nobackup
set noswapfile

" type 'ii' to switch from insert to command mode
"imap ii <C-[>

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

" syntax highlighting
set background=dark
highlight MatchParen ctermbg=darkblue

set colorcolumn=78
hi ColorColumn ctermbg=017
" cursor color
"hi cursor cterm=NONE ctermbg=019
"set cursor
" cursor line color
hi cursorline cterm=NONE ctermbg=052
set cursorline
" cursor column color
"hi cursorcolumn cterm=NONE ctermbg=017
"set cursorcolumn
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>
" visual selection color
hi Visual  ctermbg=236 ctermfg=white cterm=none
" line number color
highlight LineNr ctermfg=008
highlight CursorLineNr ctermfg=255
" make the cursor an underscore
let &t_SI .= "\<Esc>[3 q"
let &t_EI .= "\<Esc>[3 q"

" syntax colors
hi Comment      term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=#80a0ff guibg=NONE
hi Constant     term=underline cterm=NONE ctermfg=Magenta ctermbg=NONE gui=NONE guifg=#ffa0a0 guibg=NONE
hi Special      term=bold cterm=NONE ctermfg=LightRed ctermbg=NONE gui=NONE guifg=Orange guibg=NONE
hi Identifier   term=underline cterm=bold ctermfg=Cyan ctermbg=NONE gui=NONE guifg=#40ffff guibg=NONE
hi Statement    term=bold cterm=NONE ctermfg=Yellow ctermbg=NONE gui=bold guifg=#ffff60 guibg=NONE
hi PreProc      term=underline cterm=NONE ctermfg=LightBlue ctermbg=NONE gui=NONE guifg=#ff80ff guibg=NONE
hi Type         term=underline cterm=NONE ctermfg=LightGreen ctermbg=NONE gui=bold guifg=#60ff60 guibg=NONE
hi Underlined   term=underline cterm=underline ctermfg=LightBlue gui=underline guifg=#80a0ff
hi Ignore       term=NONE cterm=NONE ctermfg=Black ctermbg=NONE gui=NONE guifg=bg guibg=NONE
hi String       term=NONE cterm=NONE ctermfg=DarkGreen ctermbg=NONE gui=NONE guifg=bg guibg=NONE
hi Search       term=bold cterm=bold ctermfg=white ctermbg=blue
if &diff
    colorscheme darkblue
endif

" diff highlighting
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=21 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

" rainbow parens
let g:rainbow_active = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set Leader key to space
let mapleader=" "

" set ' p' as a paste-over-without-yank operation
vnoremap <leader>p "_dP

" tab switching
map <M-Left> :tabp<CR>
map <M-Right> :tabn<CR>

set tags=/src/tags.devenv
