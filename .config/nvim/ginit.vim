" ####### GUI CONFIG #######

set lines=52
set cmdheight=2
set columns=120
set background=dark
"let g:inkpot_black_background=1
"colorscheme inkpot
"set background=light
colorscheme earendel
"colorscheme solarized
if has("gui_macvim")
    set guifont=Menlo:h13
endif
set guioptions-=T    " toolbar
set guioptions-=m    " menu
set guioptions-=l    " left scrollbar
set guioptions-=L    " left scrollbar
set guioptions-=r    " right scrollbar
set guioptions-=R    " right scrollbar

" Set a more informative status lines
:hi StatusLineNC cterm=reverse gui=reverse
:hi StatusLine cterm=none gui=none


" ####### KEY BINDINGS #######
set winaltkeys=no



" because default map doesn't work in neovim-qt
nn <C-Space> :CtrlSpace<CR>

if !exists('s:is_neovim_gtk_gui')
	let s:is_neovim_gtk_gui = exists('g:GtkGuiLoaded') ? 1 : 0
en

" works for neovim-gtk and for neovim-qt since a250faf from 25-07-2018.
" earlier neovim-qt have been supposed to be run with --no-ext-tabline option.
cal rpcnotify((s:is_neovim_gtk_gui ? 1 : 0), 'Gui', 'Option', 'Tabline', 0)




" ####### FONTS #######

let s:font_family = 'DejaVu Sans Mono'
let s:font_size_def = 10
let s:font_size = s:font_size_def

fu! s:update_font()
	if s:is_neovim_gtk_gui " neovim-gtk
		cal rpcnotify(
			\ 1, 'Gui', 'Font', s:font_family.' '.string(s:font_size))
	el " neovim-qt
		cal rpcnotify(
			\ 0, 'Gui', 'Font', s:font_family.':h'.string(s:font_size))
	en
	redr!
endf

fu! s:set_font_family(family)
	let s:font_family = a:family
	cal s:update_font()
endf

com! -nargs=1 GuiFontFamily cal <SID>set_font_family(<args>)

" fast font inc/dec

cal s:update_font()

" too small value may cause freezes because amount of chars is getting extreme
let s:min_size = 9

fu! s:font_size_dec(count)
	let l:count = a:count | if l:count < 1 | let l:count = 1 | en
	let s:font_size = s:font_size - l:count
	if s:font_size < s:min_size | let s:font_size = s:min_size | en
	cal s:update_font()
endf

fu! s:font_size_inc(count)
	let l:count = a:count | if l:count < 1 | let l:count = 1 | en
	let s:font_size = s:font_size + l:count
	if s:font_size < s:min_size | let s:font_size = s:min_size | en
	cal s:update_font()
endf

fu! s:font_size_def()
	let s:font_size = s:font_size_def
	cal s:update_font()
endf

com! GuiFontSizeDec cal <SID>font_size_dec(1)
com! GuiFontSizeInc cal <SID>font_size_inc(1)
com! GuiFontSizeDef cal <SID>font_size_def()

nn <leader>- :<C-u>cal <SID>GuiFontSizeDec<CR>
nn <leader>+ :<C-u>cal <SID>GuiFontSizeInc<CR>
nn <leader>= :<C-u>cal <SID>GuiFontSizeDef<CR>

exe 'nn <expr> <C-ScrollWheelUp>   <SID>font_size_inc(1)'
exe 'nn <expr> <C-ScrollWheelDown> <SID>font_size_dec(1)'

" applying local additional config
let g:local_guirc_post = $HOME . '/.neovimrc-gui-local-post'
if filereadable(g:local_guirc_post) | exe 'so ' . g:local_guirc_post | en
