" ####### GENERAL OPTIONS #######
set backspace=indent,eol,start
set shiftwidth=4
set tabstop=4
set expandtab   " TAB vs Spaces
set autoindent
"set selectmode=mouse
set nobackup
set nowritebackup
set noswapfile
set number     " show line numbers
set signcolumn=number " show errors signs in the numbers column.
"set relativenumber " show relative line numbers (slow)
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
set clipboard^=unnamed,unnamedplus " use the system/selection clipboard as the default register for yank/paste
set timeout timeoutlen=0 " don't wait for key sequences

" Tab completition
set wildmenu                "make tab completion act more like bash
set wildmode=list:longest   "tab complete to longest common string, like bash

" Search options
set incsearch
set hlsearch
set ignorecase  " sensitive search
set wildignorecase " open files case insensitive
set smartcase   " if pattern contains uppercase chars, the search is case _sensitive_
set showmatch
set scrolloff=5 " keeps cursor away from top/bottom of screen

"""""" Auto reload modified files
" https://www.reddit.com/r/neovim/comments/f0qx2y/automatically_reload_file_if_contents_changed/
" trigger `autoread` when files changes on disk
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" notification after file change
autocmd FileChangedShellPost *
\ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
""""""

""
" Highlight errors
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
""
hi ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * hi ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * if expand('%') != "" | match ExtraWhitespace /[\t ]\+$/ | endif
autocmd BufWinLeave * call clearmatches()

" ####### COLOR OPTIONS #######
if has('gui_running')
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
	"set transparency=10
else
	set t_Co=256
	"set background=light
	set background=dark
	"colorscheme earendel
	"colorscheme inkpot
endif

if v:version >= 703 && !has('gui_running')
	" 80 column delimiter
	set colorcolumn=120
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


" Switch between header and implementation
"let g:F4Ext = 'cpp'
"command! SourceSwitch :exec ":e %:s,.h$,.X123X,:s,." . g:F4Ext . "$,.h,:s,.X123X$,." . g:F4Ext . ","
"nmap <F4> :SourceSwitch<CR>
function! SourceSwitch()
    " get the current buffer name, without extension
    let l:curname = expand('%:t:r')
    let l:curfull = expand('%:p')

    " match another buffer with the same basename
    for n in range(1, bufnr('$'))
        let l:bufname = expand('#'. n. ':t:r')
        let l:buffull = expand('#'. n. ':p')

        if l:bufname == l:curname && l:buffull != l:curfull
            exec ':b' . n
        endif
    endfor
endfunction
nmap <F4> :call SourceSwitch()<CR>


" Run program
"nmap <F5> :w \| make<CR>
"nmap <S-F5> :w \| make run<CR>
"nmap <C-S-F5> :w \| make debug<CR>

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
" set statusline=%f%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set statusline=[%n]\ %<%F%m\ %=%{&ff}%y\ %5l/%L%4v\ 0x%04B
"exec "let &l:statusline = ' '"
:set laststatus=2

" Remember last cursor position.
set viminfo='10,\"100,:20,/10,n~/.config/nvim/info.vim
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
au BufNewFile,BufRead *.pr{o,i} set filetype=qmake
au BufNewFile,BufRead *.qml set filetype=javascript

" PlantUML
autocmd BufRead,BufNewFile * :if getline(1) =~ '^.*startuml.*$'|  setfiletype plantuml | endif
autocmd BufRead,BufNewFile *.pu,*.uml,*.plantuml set filetype=plantuml

" TOML
autocmd BufRead,BufNewFile *.toml set filetype=dosini

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
set tagcase=match
"set tags+=~/.vimtags/stl
command! MakeTags :!ctags -R .
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
au BufRead /tmp/mutt-* set tw=72 nowrap

" Go
augroup gogroup
	autocmd!
	"autocmd FileType go setlocal shiftwidth=8 tabstop=8 softtabstop=8     " set tab stops to 8 for Go files
	autocmd FileType go setlocal noexpandtab                              " don't expand tabs to spaces for Go files
	"autocmd BufWritePre  *.go call FmtBuf("gofmt", "-s")                  " call format function and save cursor position
	autocmd BufWritePre  *.go call FmtBuf("goimports")
augroup END

" C/C++
augroup clangfmtgroup
	autocmd!
	autocmd FileType c,cpp setlocal expandtab
	autocmd BufWritePre *.c,*.cpp,*.h,*.hpp call FmtBuf("clang-format", "-style=file", "-fallback-style=none")
augroup END

" Zig
" augroup zigfmtgroup
" 	autocmd!
" 	autocmd FileType zig,zir setlocal expandtab
" 	autocmd BufWritePre *.zi{g,r} call FmtBuf("zig", "fmt", "--stdin")
" augroup END

function! FmtBuf(formatter, ...)
	if executable(a:formatter)
		"""
		" Let's add a fake change to preserve cursor position after an undo
		" http://vim.wikia.com/wiki/Restore_the_cursor_position_after_undoing_text_change_made_by_a_script
		"""
		normal ix
		normal "_x
		let l:fmt_row=line('.')
		let l:fmt_col=col('.')
		:execute "%!" . a:formatter join(a:000, ' ')
		if v:shell_error
			:%print
			:u
		endif
		" Let's add a fake change to preserve cursor position after an undo
		call cursor(l:fmt_row, l:fmt_col)
		" Let's add a fake change to preserve mark for last change `.
		normal ix
		normal "_x
	endif
endfunction


" ####### KEY BINDINGS #######
if has('macunix')
	if has("gui_macvim")
		set macmeta
	endif
endif
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
" -- omnifunc
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>


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

" Plug configuration
call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
"Plug 'ray-x/lsp_signature.nvim'

" Zig
Plug 'ziglang/zig.vim'

call plug#end()

" Disable quickfix fmt errors.
let g:zig_fmt_parse_errors=0

" LSP configuration
:lua << EOF
    local cmp = require('cmp')
    cmp.setup {
      sources = {
        { name = 'nvim_lsp',
            entry_filter = function(entry)
                -- Disable snippets
                local cmp = require('cmp')
                return entry:get_kind() ~= cmp.lsp.CompletionItemKind.Snippet and
                       entry:get_kind() ~= cmp.lsp.CompletionItemKind.Keyword
            end
        },
        { name = 'buffer', options = {
            get_bufnrs = function()
                return vim.api.nvim_list_bufs()
            end
           }
        },
        { name = 'nvim_lsp_signature_help' },
      },
      window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        -- If nothing is selected (including preselections) add a newline as usual.
        -- If something has explicitly been selected by the user, select it.
        ["<CR>"] = cmp.mapping({
          -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
              fallback()
            end
          end,
          s = cmp.mapping.confirm({ select = true }),
          c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        }),
      }),
      -- snippet = { expand = function() end },
      snippet = {
        -- We recommend using *actual* snippet engine.
        -- It's a simple implementation so it might not work in some of the cases.
        expand = function(args)
          unpack = unpack or table.unpack
          local line_num, col = unpack(vim.api.nvim_win_get_cursor(0))
          local line_text = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)[1]
          local indent = string.match(line_text, '^%s*')
          local replace = vim.split(args.body, '\n', true)
          local surround = string.match(line_text, '%S.*') or ''
          local surround_end = surround:sub(col)

          replace[1] = surround:sub(0, col - 1)..replace[1]
          replace[#replace] = replace[#replace]..(#surround_end > 1 and ' ' or '')..surround_end
          if indent ~= '' then
            for i, line in ipairs(replace) do
              replace[i] = indent..line
            end
          end

          vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, replace)
        end,
      },
    }
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    require('lspconfig')['zls'].setup {
        capabilities = capabilities,
    }

    function setAutoCmp(mode)
      if mode then
        cmp.setup({
          completion = {
            autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }
          }
        })
      else
        cmp.setup({
          completion = {
            autocomplete = false
          }
        })
      end
    end
    --setAutoCmp(false)

    -- enable/disable automatic completion popup on typing
    vim.cmd('command AutoCmpOn lua setAutoCmp(true)')
    vim.cmd('command AutoCmpOff lua setAutoCmp(false)')

    -- Set completeopt to have a better completion experience
    -- :help completeopt
    -- menuone: popup even when there's only one match
    -- noinsert: Do not insert text until a selection is made
    -- noselect: Do not select, force to select one from the menu
    -- shortness: avoid showing extra messages when using completion
    -- updatetime: set updatetime for CursorHold
    vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
    vim.opt.shortmess = vim.opt.shortmess + { c = true}
    vim.api.nvim_set_option('updatetime', 300)
EOF

