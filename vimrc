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
Plug 'srcery-colors/srcery-vim'

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

" Statusline
Plug 'vim-airline/vim-airline'

" Code formatting using external formatters
Plug 'sbdchd/neoformat'

" Automatic tags file generation
Plug 'ludovicchabant/vim-gutentags'

" Syntax checking (linting)
Plug 'vim-syntastic/syntastic'

" Snippets 
if(has("python3"))
	Plug 'SirVer/ultisnips'
	Plug 'honza/vim-snippets'
endif

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

" Clipboard (Copy/Yank-Paste) Sync
set clipboard=unnamedplus

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

" Open undotree on the right
let g:undotree_WindowLayout = 3

" Completion Options
set completeopt=menuone,noselect

" Makes gutentags use the .cache directory
" Otherwise the project folders get messy, and gitignore etc.
let g:gutentags_cache_dir = expand("~/.cache/tags")

" Who cares about whitespace, I will run a formatter anyway
let g:airline#extensions#whitespace#enabled = 0

" Enable nice looking tabline
let g:airline#extensions#tabline#enabled = 1

" Syntastic is not async, so it lags a lot
" This way syntastic only runs when manually called
" either with :SyntasticCheck (<C-e>) or :Errors
let g:syntastic_mode_map = {"mode":"passive"}


" Expand snippet with <C-j>
let g:UltiSnipsExpandTrigger="<C-j>"

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

" Color Scheme
if has('termguicolors')
	set termguicolors
endif
set background=dark
colorscheme srcery

" Ghetto fix for alacritty not having colors
if &term == "alacritty"        
  let &term = "xterm-256color"
endif

" Make line numbers have transparent background
hi clear LineNr
hi LineNr ctermfg=grey guifg=#4e4e4e ctermbg=bg guibg=bg
hi CursorLineNr ctermfg=white guifg=#D0BFA1 cterm=bold gui=bold

" Remove the vertical split line color
" (will only use | characters)
hi clear VertSplit
hi VertSplit ctermfg=grey guifg=#4e4e4e guibg=bg ctermbg=bg

" Highlight currentline in insert mode
" autocmd InsertEnter * set cul
" autocmd InsertLeave * set nocul

" Highlight the extra characters on lines with 80+ chars
" highlight OverLength ctermbg=red ctermfg=white guifg=#ffffff guibg=#cc6666
" match OverLength /\%80v.\+/

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

"{{{ FUNCTIONS

" Switches between source/header for C/C++/Cuda
" An alternative to a.vim
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

" With the relevant keybinding will trigger completion
" or insert a tab (or space) character depending on the context
function! TabOrComplete() abort
  " If completor is already open the `tab` cycles through suggested completions.
  if pumvisible()
    return "\<C-N>"
  " If completor is not open and we are in the middle of typing a word then
  " `tab` opens completor menu.
  elseif col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^[[:keyword:][:ident:]]'
    return "\<C-R>=completor#do('complete')\<CR>"
  else
    " If we aren't typing a word and we press `tab` simply do the normal `tab`
    " action.
    return "\<Tab>"
  endif
endfunction

" Silent allows running commands without the press Enter prompt
" The built-in silent command messes up the screen in terminal, so redraw
command! -nargs=1 Silent
\ | execute ':silent '.<q-args>
\ | execute ':redraw!'

function! Google(str)
	let url = 'https://google.com/search?q=' . &filetype . '+'. a:str
	Silent exec "!firefox " . "'" . url . "'"
endfunction

function! Devdocs(str)
	let url = 'https://devdocs.io/\\\#q=' . a:str
	Silent exec "!firefox " . "'" . url . "'"
endfunction

"}}}


"{{{ COMMANDSS


" Edit/Source Config
command! Config e ~/.vimrc
command! SourceConfig source ~/.vimrc

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
nnoremap <C-h> :CtrlPMRUFiles <CR>

" Search google for the word under cursor with Leader + sg (search google)
" Search devdocs.io for the word under cursor with Leader + sd (search devdocs)
call toop#mapFunction('Google', '<leader>sg')
call toop#mapFunction('Devdocs', '<leader>sd')

" Tag navigation
" gd (go to definition)
" gb (go back)
nnoremap gd <C-]>
nnoremap gb <C-o>

" Select all text with CTRL + a
map <C-a> <esc>ggVG<CR>

" Switch between header/source with Leader + aa (alternative to a.vim?)
nnoremap <silent> <leader>aa :call SwitchSourceHeader()<cr>

" Toggle UndoTree with CTRL + U
nnoremap <C-u> :UndotreeToggle<CR>

" Tag completion and file completion rebinds
" This ain't emacs
" Summary :
" <C-t> is tag completion
" <C-f> is path completion
" <C-l> is line completion
" <C-n> forward completion (mixed sources)
" <C-p> backwards completion (mixed sources)
" <C-j> expand snippet (not completion, but related)
inoremap <C-t> <C-x><C-]>
inoremap <C-f> <C-x><C-f>
inoremap <C-l> <C-x><C-l>


" Determines the highlight under the cursor
" Useful for finding those annoying ones
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
			\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
			\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


"}}}
