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
	autocmd FileType c,cpp setlocal noexpandtab
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
"Plug 'hrsh7th/cmp-nvim-lsp'
"Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
"Plug 'hrsh7th/cmp-buffer'
"Plug 'hrsh7th/nvim-cmp'
Plug 'ray-x/lsp_signature.nvim'

" Zig
Plug 'ziglang/zig.vim'

call plug#end()

" Disable quickfix fmt errors.
let g:zig_fmt_parse_errors=0

" LSP configuration
:lua << EOF
  cfg = {
    debug = false, -- set to true to enable debug logging
    log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
    -- default is  ~/.cache/nvim/lsp_signature.log
    verbose = false, -- show debug line number

    bind = true, -- This is mandatory, otherwise border config won't get registered.
                 -- If you want to hook lspsaga or other signature handler, pls set to false
    doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
                   -- set to 0 if you DO NOT want any API comments be shown
                   -- This setting only take effect in insert mode, it does not affect signature help in normal
                   -- mode, 10 by default

    max_height = 12, -- max height of signature floating_window
    max_width = 80, -- max_width of signature floating_window
    noice = false, -- set to true if you using noice to render markdown
    wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long

    floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

    floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
    -- will set to true when fully tested, set to false will use whichever side has more space
    -- this setting will be helpful if you do not want the PUM and floating win overlap

    floating_window_off_x = 1, -- adjust float windows x position.
                               -- can be either a number or function
    floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
                                -- can be either number or function, see examples

    close_timeout = 4000, -- close floating window after ms when laster parameter is entered
    fix_pos = false,  -- set to true, the floating window will not auto-close until finish all parameters
    hint_enable = true, -- virtual hint enable
    hint_prefix = "🐼 ",  -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
    hint_scheme = "String",
    hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
    handler_opts = {
      border = "rounded"   -- double, rounded, single, shadow, none, or a table of borders
    },

    always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

    auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
    extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
    zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

    padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc

    transparency = nil, -- disabled by default, allow floating win transparent value 1~100
    shadow_blend = 36, -- if you using shadow as border use this set the opacity
    shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
    timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
    toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'

    select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
    move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
  }

  local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
  }

  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

  local lsp_setup = {
      flags = lsp_flags,

      on_attach = function(client, bufnr)
          require('lsp_signature').on_attach(cfg, bufnr)

          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { noremap=true, silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

          -- Set completeopt to have a better completion experience
          -- :help completeopt
          -- menuone: popup even when there's only one match
          -- noinsert: Do not insert text until a selection is made
          -- noselect: Do not select, force to select one from the menu
          -- shortness: avoid showing extra messages when using completion
          -- updatetime: set updatetime for CursorHold
          vim.opt.completeopt = {'menuone'}
          vim.opt.shortmess = vim.opt.shortmess + { c = true}
          vim.api.nvim_set_option('updatetime', 300)

          -- this is for diagnositcs signs on the line number column
          -- use this to beautify the plain E W signs to more fun ones
          -- !important nerdfonts needs to be setup for this to work in your terminal
          -- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
          -- for type, icon in pairs(signs) do
          --     local hl = "DiagnosticSign" .. type
          --     vim.fn.sign_define(hl, { text = icon, texthl= hl, numhl = hl })
          -- end
      end,
  }

  local lspconfig = require('lspconfig')
  local servers = {'zls'}
  for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup(lsp_setup)
  end
EOF

":lua << EOF
"    local cmp = require('cmp')
"    cmp.setup {
"      sources = {
"        { name = 'nvim_lsp' },
"        { name = 'buffer' },
"        { name = 'nvim_lsp_signature_help' },
"      },
"      window = {
"        -- completion = cmp.config.window.bordered(),
"        -- documentation = cmp.config.window.bordered(),
"      },
"      mapping = cmp.mapping.preset.insert({
"        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
"        ['<C-f>'] = cmp.mapping.scroll_docs(4),
"        ['<C-Space>'] = cmp.mapping.complete(),
"        ['<C-e>'] = cmp.mapping.abort(),
"        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
"        ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert, }),
"      }),
"    }
"    local capabilities = require('cmp_nvim_lsp').default_capabilities()
"    require('lspconfig')['zls'].setup {
"        capabilities = capabilities,
"    }
"
"    function setAutoCmp(mode)
"      if mode then
"        cmp.setup({
"          completion = {
"            autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }
"          }
"        })
"      else
"        cmp.setup({
"          completion = {
"            autocomplete = false
"          }
"        })
"      end
"    end
"    --setAutoCmp(false)
"
"    -- enable/disable automatic completion popup on typing
"    vim.cmd('command AutoCmpOn lua setAutoCmp(true)')
"    vim.cmd('command AutoCmpOff lua setAutoCmp(false)')
"
"    -- Set completeopt to have a better completion experience
"    -- :help completeopt
"    -- menuone: popup even when there's only one match
"    -- noinsert: Do not insert text until a selection is made
"    -- noselect: Do not select, force to select one from the menu
"    -- shortness: avoid showing extra messages when using completion
"    -- updatetime: set updatetime for CursorHold
"    vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
"    vim.opt.shortmess = vim.opt.shortmess + { c = true}
"    vim.api.nvim_set_option('updatetime', 300)
"EOF

