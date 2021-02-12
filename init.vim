"{{{ README
" Use zm to fold this file into sections
" Use za to toggle the sections open/closed
"
" This config file aims to be the simplest/dependency free it could be.
"		- Anything that can intuitively be done with vim itself is done so.
"		- If required pure vimscript plugins are prefered.
"		- LSP is used as it reduces the number of additional plugins required
"		(Check LSP section to see what to install)
"
"}}}


"{{{1 PLUGINS

" Installs vim plug if it is not already
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
	silent !curl -fLo  ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin('~/.local/share/nvim/site/plugged')


"{{{2 CUSTOM OPERATORS

" Allows creating custom operators
Plug 'jeanCarloMachado/vim-toop'

" Change surround with cs<new><old>
" delete it with ds<old>
" add it with ys<move>
Plug 'tpope/vim-surround'

" Comment stuff with gc<move>
Plug 'tpope/vim-commentary'

" Allows repeating actions of plugins with .
Plug 'tpope/vim-repeat'

" Replace with register using gr<move>
Plug 'vim-scripts/ReplaceWithRegister'

" Sort objects alphabetically with gs<move>
Plug 'christoomey/vim-sort-motion'


"2}}}
"{{{2 CUSTOM TEXT OBJECTS

" Dependency for the others
Plug 'kana/vim-textobj-user'

" Allows targeting line with il
Plug 'kana/vim-textobj-line'

" Allows targeting indent block with ii
Plug 'kana/vim-textobj-indent'

"2}}}
"{{{2 OTHER

" Fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'

" Colorscheme
Plug 'sainnhe/sonokai'

" Automatically switch to project root
Plug 'airblade/vim-rooter'

" Rust plugin provides support for syntastic
Plug 'rust-lang/rust.vim'

" Syntax highlighting for many languages
Plug 'sheerun/vim-polyglot'

" Tree file manager
" Similar to nerdtree, but a bit easier to use
Plug 'lambdalisue/fern.vim'

" Git integration (mostly for the statusline)
Plug 'tpope/vim-fugitive'

" Basically a tree browser for edits
Plug 'mbbill/undotree'

" Peek the contents of the registers
" Press " in normal, Ctrl+R in insert mode
" "ay will yank the text in to register a (vim's behaviour, not plugin's)
" "ap will paste the text in register a (vim's behaviour, not plugin's) 
Plug 'junegunn/vim-peekaboo'

" Lsp Configurations
Plug 'neovim/nvim-lspconfig'

" Echos function signatures
Plug 'Shougo/echodoc.vim'

" Statusline
Plug 'vim-airline/vim-airline'

" Creates a floating terminal in the middle of the screen
" No idea how this is useful but it looks cool
Plug 'voldikss/vim-floaterm'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'ardasener/vim-ultisnips-snippets'

" Like snippets for html
" html:5 for generic html template
" Example: div>ul>li
" <C-z>, will expand it
" <C-z>u will update it
Plug 'mattn/emmet-vim'

" Allows searching for any word/visual selection
" with the leader + ss
Plug 'keith/investigate.vim'

" For languages without LSP 
Plug 'sbdchd/neoformat'

"2}}}

call plug#end()

"1}}}

"{{{ SETTINGS

" Get rid of vi compatibility
set nocompatible

" Turn of annoying buzz
set noerrorbells
set novisualbell

" Split below by default (help, terminal etc.)
set splitbelow

" Enable syntax highlighting
syntax on

" Disable line wrapping
" run :set wrap! to toggle it on/off
set nowrap

" Line numbers
set number

" Always on gutter
set signcolumn=yes

" Always on statusline
set laststatus=2

" CtrlP Settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_mruf_max = 250

" CtrlP tends to be fast enough without caching
" Especially with the limits set
" With this, I never have to refresh
let g:ctrlp_use_caching = 0

" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|node_modules\|log\|tmp$\|target',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$'
  \ }

"When searching, fully lowercase strings will ignorecase
set ignorecase
set smartcase

" Tab Size -> 2 Spaces
set shiftwidth=2
set tabstop=2
set softtabstop=2
set cindent

" Font for GUI
" Just in case I decide to use it for some reason
set guifont=Dejavu\ Sans\ Mono\ 13

" Shell like completion for commands
set wildmenu

" Spell language EN_US
set spelllang=en_us

" Removing capitalization check (annoying with abbrevations)
set spellcapcheck=

" Root folder markers for both ctrlp and rooter
let g:rooter_patterns=[".git", "Makefile", "makefile", "package.json",
			\	"pom.xml", "cargo.toml", "setup.py"]
let g:ctrlp_root_markers = g:rooter_patterns
let g:gutentags_project_root = g:rooter_patterns

" Stops rooter from echoing the directory
let g:rooter_silent_chdir = 1

"C++ all highlights
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1

"mattn/emmet-vimSets the comment style for the languages listed to line comments
"So '//' instead of '/* */'. Commentary plugin will then use '//'.
autocmd FileType c,cpp,java,go,rust,javascript setlocal commentstring=//\ %s

" Folding
" Indent based folding enabled at start
" Syntax based seems to cause slow downs
" For vim uses markers {{{ and }}}
" For markdown uses the built-in filetype (set elsewhere)
" Use zm to close all, za to toggle current
set foldmethod=indent
autocmd FileType vim setlocal foldmethod=marker
set nofoldenable

" Open undotree on the right
let g:undotree_WindowLayout = 3

" Completion Options
set completeopt=menuone,noselect


" Who cares about whitespace, I will run a formatter anyway
let g:airline#extensions#whitespace#enabled = 0

" Enable nice looking tabline
let g:airline#extensions#tabline#enabled = 1

" Disable nvim lsp until they stabilize it 
let g:airline#extensions#nvimlsp#enabled = 0

" Ultisnips snippet path
let g:UltiSnipsSnippetDirectories = ['CustomSnips']

" Expand snippet with C-j
let g:UltiSnipsExpandTrigger="<C-j>"

" Limit pumheight (completion menu)
set pumheight=10

" Toggle a terminal with C-t
let g:floaterm_keymap_toggle = '<C-t>'

" Echo function signatures using virtual text
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'virtual'

" Enable highlight for inline lua,python,ruby
let g:vimsyn_embed = 'lPr'
"}}}



"{{{LSP
lua << EOF
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = { noremap=true, silent=true }
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

end



-- Add any server specific configuration here
nvim_lsp.rust_analyzer.setup{
	on_attach = on_attach
}
nvim_lsp.clangd.setup{
	on_attach = on_attach
}
nvim_lsp.pyls.setup{
	on_attach = on_attach
}

EOF
"}}}




"{{{ MARKDOWN

" Enable markdown specific folding
let g:markdown_folding = 1

" Setup for md buffers
function! MDSetup()
	setlocal complete+=kspell
	setlocal spell
	setlocal textwidth=80
	setlocal statusline+=[%{wordcount().words}]
	setlocal conceallevel=0
endfunction

" Use dict. completion for markdown files
au FileType markdown call MDSetup()
"}}}

"{{{ HIGHLIGHTSS

" Improves highlight performance
set synmaxcol=100  

if has('termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
	set termguicolors
endif

" Color Scheme
set background=dark
let g:sonokai_style = 'andromeda'
let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 1
colorscheme sonokai


" Make line numbers have transparent background
hi clear LineNr
hi LineNr ctermfg=grey guifg=#4e4e4e ctermbg=bg guibg=bg
hi CursorLineNr ctermfg=white guifg=#D0BFA1 cterm=bold gui=bold

" Remove the vertical split line color
" (will only use | characters)
hi clear VertSplit
hi VertSplit ctermfg=grey guifg=#4e4e4e guibg=bg ctermbg=bg

" Spell highlight
hi clear SpellBad
hi clear SpellLocal
hi SpellLocal cterm=underline gui=underline
hi link SpellBad SpellLocal

" Clear Gutter (bar on the left with syntax error signs)
highlight clear SignColumn

" Nicer looking border on the floating terminal
hi clear FloatermBorder
hi FloatermBorder guifg=orange ctermfg=red

" Annoying python space error highlight
hi clear Error
hi clear pythonSpaceError


"}}}

"{{{ FUNCTIONS

" Switches between source/header for C/C++/Cuda
" An alternative to a.vim
function! SwitchSourceHeader() abort
  if (expand ("%:e") == "cpp")
    silent! find %:t:r.h
    silent! find %:t:r.hpp
  elseif (expand ("%:e") == "c")
    silent! find %:t:r.h
  elseif (expand ("%:e") == "hpp")
    silent! find %:t:r.cpp
    silent! find %:t:r.cu	
  elseif (expand ("%:e") == "h")
    silent! find %:t:r.cpp
    silent! find %:t:r.c	
    silent! find %:t:r.cu	
  elseif (expand ("%:e") == "cu")	
    silent! find %:t:r.h
    silent! find %:t:r.hpp
	else
		echo "No corresponding file found"
  endif
endfunction

" Returns true if there are multiple tabs open
function! MultipleTabs() abort
	return tabpagenr('$') > 1 
endfunction

" Returns true if:
"		- Pum (completion) menu is open
"		- or there are prior non-space characters in the row
function! ShouldComplete() abort
	let line = getline('.')
	let colnr = col('.')
	return pumvisible() || (colnr > 1 && line[colnr-2] != " ")
endfunction

"}}}


"{{{ COMMANDSS


" Edit/Source Config
command! Config e ~/.config/nvim/init.vim
command! SourceConfig source ~/.config/nvim/init.vim

" Auto-formating using vim-itself
command! -bar FixIndent :normal gg=G''<CR>
command! FixTrailing %s/\s\+$//e
command! FixAll FixIndent|FixTrailing

" Toggle spell checking
command! Spell setlocal spell!

" Change pwd to current file's parent directory
command! Cdc lcd %:p:h

"}}}

"{{{ KEYBINDINGS


" The leader is the space key
let mapleader = " "

" Leader key for emmet is CTRL + z
let g:user_emmet_leader_key='<C-z>'

"Switch windows with CTRL + H,J,K,L or CTRL + arrow keys
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
nnoremap <C-Down> <C-W>j
nnoremap <C-Up> <C-W>k
nnoremap <C-Right> <C-W>l
nnoremap <C-Left> <C-W>h

"Same for the terminal mode
tnoremap <C-J> <C-W>j
tnoremap <C-K> <C-W>k
tnoremap <C-L> <C-W>l
tnoremap <C-H> <C-W>h
tnoremap <C-Down> <C-W>j
tnoremap <C-Up> <C-W>k
tnoremap <C-Right> <C-W>l
tnoremap <C-Left> <C-W>h

" Run syntax checker with CTRL + e
nmap <C-e> :SyntasticCheck<CR>

" File manager with CTRL + n
nmap <C-n> :Fern . -drawer -toggle<CR>

" Format the file with external program with Leader + ff (format file)
nmap <leader>ff :Neoformat<CR>

" Fuzzy search current pwd with CTRL + p (defined by plugin)
" Fuzzy search history with CTRL + h
" Fuzzy search buffers with CTRL + b
nnoremap <C-h> :CtrlPMRUFiles <CR>
nnoremap <C-b> :CtrlPBuffer <CR>

" Search the documentation with <leader>sd
" In normal mode searches for the word under the key
" In visual mode searches for the selection
nnoremap <leader>sd :call investigate#Investigate('n')<CR>
vnoremap <leader>sd :call investigate#Investigate('v')<CR>

" Switch between header/source with Leader + aa (alternative to a.vim?)
nnoremap <silent> <leader>aa :call SwitchSourceHeader()<cr>

" Toggle UndoTree with CTRL + U
nnoremap <C-u> :UndotreeToggle<CR>

" File/Path complete with CTRL + f
" Line complete with CTRL + l
" Omni complete with CTRL + o
" Otherwise just use tab
inoremap <C-f> <C-x><C-f>
inoremap <C-l> <C-x><C-l>
inoremap <C-o> <C-x><C-o>

" Switch tabs/buffers with tab key in normal mode
nnoremap <expr> <tab> MultipleTabs() ? ':tabnext<CR>' : ':bnext<CR>'  
nnoremap <expr> <s-tab> MultipleTabs() ? ':tabprevious<CR>' : ':bprevious<CR>'  

" Move through pum (completion menu) with tab, shift-tab
inoremap <expr> <tab> ShouldComplete() ? '<C-n>' : '<tab>'  
inoremap <expr> <s-tab> ShouldComplete() ? '<C-p>' : '<s-tab>'  

" Clear search highlight
nnoremap <C-g> :noh<CR>

" Go back
nnoremap gb <C-o>

" Determines the highlight under the cursor
" Useful for finding those annoying ones
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
			\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
			\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


"}}}
