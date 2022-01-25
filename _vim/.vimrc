" most intersting stuff is done through breaking things
set nocompatible

" pathogen plugin, requires filetype plugin indent
filetype plugin indent on
call pathogen#infect()
" required to get help on stuff installed through pathogen
call pathogen#helptags()

" set language for messages and gui menus
let s:langCode = has('win32') ? 'en' : 'en_US.UTF-8'

" must be set before syntax highlight
let &langmenu = s:langCode
execute 'language message '.s:langCode

colorscheme ir_black

" enable syntax coloring
syntax enable

" use utf8 encoding for vim files and for default file encoding
set encoding=utf-8
set fileencoding=utf-8

" auto complete on tab
set wildmenu


" disable arrow key mappings (normal and insert modes)
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
" move on screen lines (and not actual lines), useful for wrapped lines
nnoremap j gj
nnoremap k gk

" remove useless help, and prompt for search term instead
noremap <F1> <esc>:h

" display a $ at end of change area (thus changed is visually between
" cursor and highlighted $.
" TODO : find how to always make it look different from text color under
" cursor
set cpoptions+=$

" when scrolling, keep a margin for readeability
set scrolloff=4

" tab are replaced by 4 spaces
set expandtab
set tabstop=4
" make deleting on spaces like its tabs
set softtabstop=4

" << / >> right / left shift by 4 spaces
set shiftwidth=4

" copy indent from current line on <CR>
set autoindent

" backspace in insert mode : backspace option
" behave like normal text editor, backspace always delete previous character
set backspace=eol,start,indent

" GUI font
" TODO : move this to local .extra.vimrc files
if has("gui_gtk2")
    " TODO find appropriate font for gtk2
    set guifont=Ubuntu\ Mono\ 12
elseif has("gui_win32")
    " TODO : find appropriate font for windows xp
    set guifont=Consolas:h11
endif

" windows fullscreen toggle
if has('gui_win32')
    " note : .dll extention MUST be ommited when using an absolute path
    " but that's according to documentation, and does not work without
    let g:fullscreenDllPath=expand('<sfile>:p:h').'\.vim\bundle\gvimfullscreen_win32\gvimfullscreen.dll'
    execute "map <F11> <Esc>:call libcallnr('".g:fullscreenDllPath."', 'ToggleFullScreen', 0)<cr>"
endif

" remove gui icons bar
set guioptions-=T
" remove menus
set guioptions-=m
set guioptions-=g
" remove all scrollbars
set guioptions-=R
set guioptions-=r
set guioptions-=L
set guioptions-=l


" don't redraw while executing macros
set lazyredraw

" display current mode and current command
set showmode
set showcmd

" allow to have hidden buffers not written
set hidden

set laststatus=2
set statusline=%t\ \{%{&fileencoding?&fileencoding:&encoding}\}\ %{fugitive#statusline()}%=\ [%l,%v]\ %{strftime(\"%H:%M\")}

" enable persistent undo
set undofile

" write swap, backup and undo files to system temp folder and not next to
" original file. double trailing / allow to open two files with same name 
" without conflict.
set directory=/tmp//,$TMP//
set backupdir=/tmp//,$TMP//
set undodir=/tmp//,$TMP//

" comma as leader key
let mapleader = ","

" search options
set incsearch
set showmatch
set hlsearch

" search ignore case when all lowercase, case sensitive otherwise
set ignorecase
set smartcase

" do not wrap long lines by default
set nowrap 

" toggle search highlight on ,<space>
nnoremap <silent><leader><space> :set hlsearch!<cr>:set hlsearch?<cr>

" write-quit on ,q
nnoremap <leader>q :wqa<cr>

" fuzzy-finder mappings
noremap <silent><leader>f :FufFile<cr>
noremap <silent><leader>b :FufBuffer<cr>
noremap <silent><leader>cd :FufDir<cr>
noremap <silent><leader>t :FufTag<cr>

" nerdtree mapped to ,n
noremap <silent><leader>n :NERDTreeToggle<cr>
" nerdtree find current fil with ,m
noremap <silent><leader>m :NERDTreeFind<cr>

" gundo mapped to ,g
noremap <silent><leader>g :GundoToggle<cr>

" fuzzy-finder features to explore :
" - file coverage
" - mru file
" - mru command
" - bookmark file
" - bookmark dir
" - tag mode
" - buffer tag mode
" - tagged file
" - jump list
" - change list
" - quickfix
" - line

" fugitive mapped to ,g*
noremap <silent><leader>gs :Gstatus<cr>
noremap <silent><leader>gd :Gdiff<cr>]c

" switch to alternate buffer (a lot more usable with qwerty-intl keyb)
noremap <silent><leader><leader> <c-^>

" closes all fugitive windows in current tab
function! GitClose()
    let sep = has('win32') ? '\' : '/'
    for buffer in tabpagebuflist()
        if 0 < bufnr(buffer)
            let bufName = bufname(buffer)
            if bufName =~? '^fugitive:' || bufName =~? '\.git'.sep.'index$'
                let window = bufwinnr(buffer)
                if 0 < window
                    execute window."wincmd w"
                    wincmd c
                    wincmd p
                endif
            endif
        endif
    endfor
endfunction

nnoremap <silent><leader>gc :call GitClose()<cr>

" make 3 way merges easier
" buffer : either 2 or 3 in threee way merge for //2 and //3 bufspecs
function! GitDiffGet(buffer)
   if 1 == &diff
      execute "diffget //".a:buffer
      diffupdate
   endif
endfunction

" fugitive : easy merge resolution : ,dgh to take left part, ,dgl for right
" cursor is then moved to next difference
nnoremap <silent><leader>dgh :call GitDiffGet(2)<cr>]c
nnoremap <silent><leader>dgl :call GitDiffGet(3)<cr>]c

" window commands on ,w instead of Ctrl+w
nnoremap <leader>w <c-w>

" make system clipboard copy & paste more accessible
vnoremap <leader>y "+y
nnoremap <leader>y "+y
vnoremap <leader>p :set paste<esc>"+p
nnoremap <leader>p :set paste<esc>"+p

if has('clipboard')
    set clipboard=unnamedplus
endif

" disable auto indent on paste
set paste

" ---- highlight customization ----
" search color
hi Search guifg=Red gui=bold,standout ctermfg=Red cterm=bold,standout

" TODO : test and change configuration for term
" see : [gui-colors] in help
" hi Search ctermfg=NONE ctermbg=NONE cterm=underline

" TODO highlight matching parentheses : MatchParen

" invisible characters & whitespace
hi  SpecialKey  guifg=yellow  guibg=black  gui=bold  ctermfg=yellow  guibg=black  cterm=bold
hi  NonText     guifg=red     guibg=black  gui=bold  ctermfg=red     guibg=black  cterm=bold
" ---------------------------------

" diff update on ,du
nnoremap <silent><leader>du :diffupdate<cr>
" easier diff put/pull + move to next diff
nnoremap <silent><leader>do do]c
nnoremap <silent><leader>dp dp]c

" ack integration
" TODO add suitable configuration for windows
let g:ackprg="ack -H --nocolor --nogroup --column"

" localvimrc to handle per location/project settings
let g:localvimrc_ask=0

" customize invisible characters
if has('win32')
    set listchars=tab:▸\ ,eol:¬,trail:.,extends:>,precedes:<
    set showbreak=$
else
    set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
    set showbreak=↪
endif

" toggle invisible characters
nnoremap <silent><leader>l :set list!<cr>:set list?<cr>

" toggle line wrapping
nnoremap <silent><leader>W :set wrap!<cr>:set wrap?<cr>

" remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Ack integration
nnoremap <silent><leader>a :Ack
nnoremap <silent><leader>/ :AckFromSearch<cr>
" ,/ in visual mode searches for current selection
vnoremap <leader>/ <esc>:Ack <c-r>*<cr>

" visual mode search (whithin file)
" ,# and ,* work like # and * in normal mode, but with current selection
vnoremap <leader># <esc>?\<<c-r>*\><cr>:set hlsearch<cr>
vnoremap <leader>* <esc>/\<<c-r>*\><cr>:set hlsearch<cr>

" reload file
nnoremap <leader>e <esc>:e!<cr>


" Extra vimrc : for local settings
let s:extrarc = expand($HOME . '/.extra.vimrc')
if filereadable(s:extrarc)
    exec ':source ' . s:extrarc
endif

" ctrl-p configuration
let g:ctrlp_show_hidden = 1
let g:ctrlp_extensions = ['mixed','dir']

set wildignore+=*.class

" CQL syntax
augroup cql
    autocmd!
    autocmd BufRead *.cql set syntax=cql
augroup END

augroup jenkins
    autocmd!
    autocmd BufNewFile,BufRead Jenkinsfile set filetype=groovy expandtab
augroup END

function! Javap()
    :silent %! javap -v %
    set filetype=java-bytecode
    " TODO fold constant pool
    " TODO fold method details

    "set foldmethod=indent
    "set shiftwidth=2
    "set foldcolumn=4
    "set foldlevel=0
endfunction

augroup javabytecode
    autocmd!
    autocmd BufNewFile,BufRead *.class call Javap()
    autocmd BufNewFile,BufRead zipfile:*.class echo "hello"
augroup END

nnoremap <leader>d <esc>:windo diffthis


" use proper indent for yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

set expandtab
