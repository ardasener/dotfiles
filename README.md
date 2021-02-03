# Dot Files

These are configuration files for several tools I use. I am running Endeavor OS at the
time of writing, so the instructions are mostly relevant for Arch based systems.
Some explanations are included in this readme file mostly to help future me.

## Installation

- Simply clone and run `./install` to link all the files.
- The `yay.txt` file can be used to install/update everything required via yay.
	+ Simply run `yay -S - < yay.txt` to do so. 

## Notation

- Note that these may differ in some operating systems.
- `C-a` : CTRL + a
- `M-a` : ALT + a
- `M-S-a` : ALT + SHIFT + a

## Neovim

### Completion

- Done manually with the tab key.
- If available LSP (Language Server Protocol) will be used. Install the servers
		with:
		+ Clangd: `pacman -S clang` (in other OS, may be in a different package)
		+ Pyls: `pip install python-language-server[yapf,pyflakes]`
		+ Rust-Analyzer: `pacman -S rust-analyzer` (or use rustup for nightly)
- LSP is also used to provide **linting**, **formatting**, and other **code
		actions**. (See the bindings in the `init.vim` file)
- If LSP is not found, it will default to standard buffer completion.
- `C-f` could be used for file/path completion.
- `C-l` could be used for line completion.

### File System

- The working path will be automatically changed to the project path if certain
		marker files (like .git, makefile, cargo.toml etc.) are found.
- `:Cdc` will switch to the path of the current file.
- `C-n` will open a tree file browser.
- `C-p` will open a fuzzy finder for the current path, history and buffers.
- `C-h` will open a fuzzy finder for the search history.

## Tmux

- `M-arrow keys` will move between panes.
- `M-S-arrow keys` will move between windows.
- `C-a "` to open a new pane. (Should retain the working path)
- `C-a c` to open a new window. (Should retain the working path)
- The battery percentage indicator reads the results from a file, may not work
		in other operating systems or older/newer versions of Linux.
- `C-q` to close pane/window.
