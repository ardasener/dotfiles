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
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin('~/.vim/plugged')


"{{{2 CUSTOM OPERATORS

" Change surround with cs<new><old>
" delete it with ds<old>
" add it with ys<move>
Plug 'tpope/vim-surround'

" Comment stuff with gc<move>
Plug 'tpope/vim-commentary'

" Allows repeating actions of plugins with .
Plug 'tpope/vim-repeat'

" Replace with register using gr<move>
" Plug 'vim-scripts/ReplaceWithRegister'

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

" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Echos function signatures to the echo area (command line below)
Plug 'Shougo/echodoc.vim'

" Colorscheme
Plug 'joshdick/onedark.vim'

" Automatically switch to project root
Plug 'airblade/vim-rooter'

" Rust plugin provides support for syntastic
Plug 'rust-lang/rust.vim'

" Syntax highlighting for many languages
Plug 'sheerun/vim-polyglot'

" Tree file manager
Plug 'lambdalisue/fern.vim'

" Git integration (mostly for the statusline)
Plug 'tpope/vim-fugitive'

" Shows indentation levels
Plug 'yggdroot/indentline'

" Toggles terminal (does more stuff but I don't use them)
Plug 'kassio/neoterm'

" Basically a tree browser for edits
Plug 'mbbill/undotree'

" Peek the contents of the registers
" Press " in normal, Ctrl+R in insert mode
" "ay will yank the text in to register a (vim's behaviour, not plugin's)
" "ap will paste the text in register a (vim's behaviour, not plugin's) 
Plug 'junegunn/vim-peekaboo'

" Puts a cooldown on hjkl and arrow keys
" Forcing you to use more advanced commands/bindings
Plug 'takac/vim-hardtime'

" Lightline (statusline)
 Plug 'itchyny/lightline.vim'

"2}}}

call plug#end()

"1}}}

"{{{ SETTINGS

" Bring it on...
let g:hardtime_default_on = 0
let g:hardtime_timeout = 500

" Get rid of vi compatibility
set nocompatible

" Turn of annoying buzz
set noerrorbells
set novisualbell

" Split below by default (help, terminal etc.)
set splitbelow

" Size of the built-in terminal window
set termwinsize=10x0

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

" Statusline Config
let g:lightline = {
			\ 'colorscheme': 'onedark', 
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ],
			\             [ 'readonly', 'filename', 'modified', ], ['cocstatus'] ],
			\   'right': [['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype']]
			\ },
			\ 'component_function': {
			\   'cocstatus': 'coc#status'
			\ },
			\ }

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

" Clipboard (Copy/Yank-Paste) Sync
set clipboard=unnamedplus

" Tab Size -> 2 Spaces
set shiftwidth=2
set tabstop=2
set softtabstop=2
set cindent

" Font for GUI
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

" Stops rooter from echoing the directory
let g:rooter_silent_chdir = 1

"C++ all highlights
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1

"Setup for echodoc
set noshowmode
let g:echodoc_enable_at_startup = 1


"Sets the comment style for the languages listed to line comments
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

" Neoterm (toggle-terminal) settings
let g:neoterm_default_mod = 'belowright'
let g:neoterm_size = 10
let g:neoterm_fixedsize = '1'
let g:neoterm_autoscroll = '1'
let g:neoterm_autoinsert=1

" Open undotree on the right
let g:undotree_WindowLayout = 3					        

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

"{{{ AUTO COMPLETE AND LSP

" A lot of the configuration is in ~/.vim/coc-settings.json
" Or simply run :CocConfig

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


"}}}

"{{{ HIGHLIGHTS

" Color Scheme
if has('termguicolors')
	set termguicolors
endif
colorscheme onedark
set background=dark

" Make line numbers have transparent background
hi clear LineNr
hi LineNr ctermfg=grey guifg=#4e4e4e ctermbg=bg guibg=bg
hi CursorLineNr ctermfg=white guifg=#c5c8c6 cterm=bold gui=bold

" Remove the vertical split line color
" (will only use | characters)
hi clear VertSplit
hi VertSplit ctermfg=grey guifg=#4e4e4e guibg=bg ctermbg=bg

" Highlight currentline in insert mode
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

hi clear CocErrorSign
hi clear CocWarningSign
hi clear CocInfoSign
hi clear CocHintSign 
hi CocErrorSign guifg=#cc6666 ctermfg=red
hi CocWarningSign guifg=#de935f ctermfg=208
hi CocInfoSign guifg=#f0c674 ctermfg=yellow
hi CocHintSign guifg=#f0c674 ctermfg=yellow


" Highlight the extra characters on lines with 80+ chars
"highlight OverLength ctermbg=red ctermfg=white guifg=#ffffff guibg=#cc6666
"match OverLength /\%80v.\+/

" Spell highlight
hi clear SpellBad
hi clear SpellLocal
hi SpellLocal cterm=underline gui=underline
hi link SpellBad SpellLocal

" Clear Gutter (bar on the left with syntax error signs)
highlight clear SignColumn

" Annoying python space error highlight
hi clear Error
hi clear pythonSpaceError
"}}}

"{{{ COMMANDS AND FUNCTIONS

" Switches between source/header for C/C++/Cuda
function! SwitchSourceHeader()
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
  endif
endfunction


" Edit/Source Config
command! Config e ~/.vimrc
command! SourceConfig source ~/.vimrc

" Auto-formating using vim-itself
command! -bar FixIndent :normal gg=G''<CR>
command! FixTrailing %s/\s\+$//e
command! FixAll FixIndent|FixTrailing

" Search google automatically using filetype and word under cursor
command! Google exec "!xdg-open 'https://google.com/search?q="
			\ . &filetype . "+<cword>'"

" Search devdocs automatically using the word under cursor
command! Devdocs exec "!xdg-open 'https://devdocs.io/\\\#q="
			\ . "<cword>'"

" Toggle spell checking
command! Spell setlocal spell!

" Change pwd to current file's parent directory
command! Cdc lcd %:p:h

command! -nargs=0 Format :call CocAction('format')
"}}}

"{{{ KEYBINDINGS

let mapleader = " "

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

" File manager with CTRL + n
nmap <C-n> :Fern . -drawer -toggle<CR>

" Fix indentation etc.
nmap <leader>f :Format<CR>

" Fuzzy search current pwd with CTRL + p
" Fuzzy search history with CTRL + h
nnoremap <C-h> :CtrlPMRUFiles <CR>

" Search google for the word under cursor with CTRL + g
" Search devdocs.io for the word under cursor with CTRL + d
nnoremap <C-g> :Google <CR>
nnoremap <C-d> :Devdocs <CR>

" Select all text with CTRL + a
map <C-a> <esc>ggVG<CR>

" COC Bindings
nmap gd <Plug>(coc-definition)
nmap gy <Plug>(coc-type-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>ca <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)


" Switch between header/source
nnoremap <silent> <leader>aa :call SwitchSourceHeader()<cr>

" Toggle terminal with CTRL + k
nnoremap <silent> <C-k> :Ttoggle<CR>
tnoremap <silent> <C-k> <C-w>k:Ttoggle<CR>

" Switch to normal mode in terminal with double tab ESC
" Return to terminal mode with i (like insert mode)
" Useful for scrolling
tnoremap <Esc><Esc> <C-\><C-n>

" Toggle UndoTree with CTRL + U
nnoremap <C-u> :UndotreeToggle<CR>

" Expand snippets with CTRL + j
imap <C-j> <Plug>snipMateNextOrTrigger

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
			\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
			\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


"}}}
