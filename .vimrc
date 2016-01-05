" ####### GENERAL OPTIONS #######
set backspace=indent,eol,start
set shiftwidth=4
set tabstop=4
set noexpandtab   " TAB vs Spaces
set autoindent
"set selectmode=mouse
set nobackup
set nowritebackup
set noswapfile
set number     " show line numbers
"set paste     " allow paste from clipboard
set nopaste    " don't allow paste from clipboard since imap doesn't work
set title      " set window title
set mouse=a    " use mouse

" Wrap lines
set wrap
set linebreak " wraps words on boundaries but conflicts with 'list' option
set showbreak=…
set textwidth=0

set winminwidth=0 " minimum windows width
set showcmd       " see partial commands while typing
syntax enable
set vb t_vb=      " set visualbell
"set autochdir "change the current directory whenever window changes
"set clipboard=unnamed " use the system clipboard as the default register for yank/paste
set timeout timeoutlen=0 " don't wait for key sequences

" Tab completition
set wildmenu                "make tab completion act more like bash
set wildmode=list:longest   "tab complete to longest common string, like bash

" Search options
set incsearch
set hlsearch
set ignorecase  " sensitive search
set smartcase   " if pattern contains uppercase chars, the search is case _sensitive_
set showmatch
set scrolloff=5 " keeps cursor away from top/bottom of screen



" ####### COLOR OPTIONS #######
if has('gui_running')
	set lines=52
	set cmdheight=2
	set columns=100
	"set background=dark
	"let g:inkpot_black_background=1
	"colorscheme inkpot
	set background=light
	colorscheme earendel
	if has("gui_macvim")
		set guifont=Monaco:h13
	endif
	set guioptions-=T    " toolbar
	set guioptions-=m    " menu
	set guioptions-=l    " left scrollbar
	set guioptions-=L    " left scrollbar
	set guioptions-=r    " right scrollbar
	set guioptions-=R    " right scrollbar
	"set transparency=10
else
	set t_Co=256
	set background=light
	"colorscheme earendel
endif

if v:version >= 703 && !has('gui_running')
	" 80 column delimiter
	set colorcolumn=80
	hi ColorColumn ctermbg=gray guibg=darkgray ctermfg=black guifg=black
	au FileType qf setlocal cc=0
endif


" ####### PROGRAMMING OPTIONS #######
syntax on
set list
set encoding=utf-8
"set listchars=tab:»•,trail:•
set listchars=tab:·\ ,trail:·
let java_space_error = 1
let python_space_error_highlight = 1
let c_gnu = 1
let c_space_errors = 1
let c_comment_strings = 1

hi ExtraWhitespace ctermbg=red guibg=red
au BufWinEnter * if expand('%') != "" | match ExtraWhitespace /[\t ]\+$/ | endif
au BufWinLeave * call clearmatches()


" Switch between header and implementation
let g:F4Ext = 'cpp'
command! SourceSwitch :exec ":e %:s,.h$,.X123X,:s,." . g:F4Ext . "$,.h,:s,.X123X$,." . g:F4Ext . ","
nmap <F4> :SourceSwitch<CR>


" Run program
nmap <F5> :w \| make<CR>
nmap <S-F5> :w \| make run<CR>
nmap <C-S-F5> :w \| make debug<CR>

" Omni completion
filetype on
filetype plugin on
"set ofu=syntaxcomplete#Complete
set completeopt=menuone ",menu,longest,preview

" Set a more informative status lines
if has('gui_running')
	:hi StatusLineNC cterm=reverse gui=reverse
	:hi StatusLine cterm=none gui=none
else
	:hi StatusLine cterm=reverse gui=reverse
	:hi StatusLineNC cterm=none gui=none
endif
set statusline=%f%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
"exec "let &l:statusline = ' '"
:set laststatus=2

" Remember last cursor position.
set viminfo='10,\"100,:20,/10,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm'\"")|else|exe "norm $"|endif|endif

" Quickfix
set shell=/bin/sh
au FileType qf setlocal wrap | setlocal linebreak
au FileType qf wincmd J
compiler! gcc

" Sessions
set sessionoptions-=curdir
set sessionoptions+=sesdir,winpos,winsize,resize,globals,localoptions
function! SaveSession()
	if v:this_session != ""
		exec 'mksession! ' . '"' . v:this_session . '"'
		echo "Session saved"
	endif
endfunction
au VimLeave * :call SaveSession()

" Qt qmake
command! -nargs=* QMakeDebug :!qmake CONFIG+=debug <args>
command! -nargs=* QMakeRelease :!qmake <args>
au BufNewFile,BufRead *.pr{o,i} set filetype=qmake

" Debug: breakpoints
nmap <F9> Oasm("int $3"); // BREAKPOINT<Esc>

" Search
command! -nargs=1 FGrep :grep -e <args> #
command! -nargs=1 RGrep :grep -I
	\ --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.hg
	\ --exclude=Session.vim --exclude=*.swp
	\ --exclude=tags --exclude=TAGS --exclude=.tags
	\ --exclude=Makefile --exclude=Doxyfile --exclude=*.o
	\ --exclude=moc_*.cpp --exclude=qrc_*.cpp --exclude=ui_*.h
	\ -r -e <args> .
nmap <F3> :copen \| silent FGrep <C-R><C-W>
nmap <S-F3> :copen \| silent RGrep <C-R><C-W>

" Tags
set showfulltag
"set tags+=~/.vimtags/stl
command! MakeTags :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q
	\ --exclude="moc_*.cpp" --exclude="ui_*.h"
	\ .
nmap <F12> :MakeTags<CR>

" Hex mode
noremap <F11> :call HexMe()<CR>
let $in_hex=0
function! HexMe()
	set binary
	set noeol
	if $in_hex>0
		:%!xxd -g1 -r
		let $in_hex=0
	else
		:%!xxd -g1
		let $in_hex=1
	endif
endfunction

" MUTT
au BufRead /tmp/mutt-* set tw=72


" ####### KEY BINDINGS #######
if has('gui_running')
	set winaltkeys=no
else
	nmap h <M-h>
	cmap h <M-h>
	nmap l <M-l>
	cmap l <M-l>
	nmap j <M-j>
	cmap j <M-j>
	nmap k <M-k>
	cmap k <M-k>
	nmap  <M-BS>
	cmap  <M-BS>
	nmap [3;3~ <M-Del>
	cmap [3;3~ <M-Del>
	nmap [14~ <F4>
endif
"-- line
nmap <Home> ^
imap <Home> <Esc><Home>i
"-- words movements
nmap <M-h> b
nmap <M-l> w
nmap <M-k> {
nmap <M-j> }
"-- words deletions
nmap <M-Del> dw
nmap <M-BS> hdiw
imap <M-Del> <C-O>dw
imap <M-BS> <C-O>h<C-O>diw
"-- command history
cmap <M-h> <S-left>
cmap <M-l> <S-right>
cmap <M-j> <Down>
cmap <M-k> <Up>
cmap <M-Del> <S-right><C-W>
cmap <M-BS> <C-W>


" ####### PLUGINS #######

" BufExplorer
function! ToggleBufExplorer()
	let l:name = bufname("%")
	if l:name == "[BufExplorer]"
		norm q
	else
		exec ":BufExplorer"
	endif
endfun
nnoremap <silent> <F7> :call ToggleBufExplorer()<CR>

" TagList
nnoremap <silent> <F8> :TlistToggle<CR>
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_SingleClick = 1
let Tlist_Sort_Type = "name"
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Display_Prototype = 0
let Tlist_Show_One_File = 1
let Tlist_Compact_Format = 0
let Tlist_Inc_Winwidth = 0
"let Tlist_Use_Horiz_Window = 1
let Tlist_WinWidth = 999
"let Tlist_WinHeight = 999
let Tlist_Close_On_Select = 1
let Tlist_GainFocus_On_ToggleOpen = 1
if has('gui_running')
	let Tlist_Show_Menu=0
endif
let tlist_make_settings  = 'make;m:makros;t:targets;i:includes'
let tlist_qmake_settings = 'qmake;t:variables'
"au FileType taglist setlocal guioptions-=L " don't show left scroll bar on taglist window

" ClangComplete
let g:clang_use_library = 1
let g:clang_complete_copen = 1
let g:clang_library_file = '/usr/lib/llvm-3.6/lib/libclang.so.1'
nmap <silent> <F2> :w \| call g:ClangUpdateQuickFix()<CR>
