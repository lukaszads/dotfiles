" Vim
" An example for a vimrc file.
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"             for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc

" luckrk - from default vim
set nocompatible	" Use Vim defaults (much better!)
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers

set history=400		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line
"
" Show @@@ in the last line if it is truncated.
set display=truncate

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

:set showmatch		" jump emacs style to matching bracket

"these characters can move past end of line
:set whichwrap=b,s,h,l

"default tabs are too wide IMO. uncomment to change them
" :set tabstop=6 

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" In text files, always limit the width of text to 78 characters
" autocmd BufRead *.txt set tw=78

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For *.c and *.h files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd BufRead *       set formatoptions=tcql nocindent comments&
  autocmd BufRead *.c,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
augroup END

augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPost,FileReadPost	*.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
augroup END


"let bash_is_sh = 1
"let is_bash = 1

" Uncomment to turn off arrow keys. Using arrow keys is a good habit to 
" get out of ... 

":map <left> <Nop>
":map <right> <Nop>
":map <up> <Nop>
":map <down> <Nop>
"
":imap <left> <Nop>
":imap <right> <Nop>
":imap <up> <Nop>
":imap <down> <Nop>

" Some emacs/pico like keybindings for insert mode

:imap <C-A> <ESC>0i
:imap <C-E> <ESC>$a
":imap <C-P> <ESC>ki
":imap <C-N> <ESC>ji
":imap <C-B> <ESC>la
":imap <C-F> <ESC>ha

" Some highlighting definitions

" THis is the default. 
" Doesn't use colours wisely IMO. Consider changing Repeat and Conditional
" to make them stand out a little better.

" There are two sets of defaults: for a dark and a light background.
  if &background == "dark"
    hi Comment	term=bold ctermfg=Cyan guifg=#80a0ff
    hi Constant	term=underline ctermfg=Magenta guifg=#ffa0a0
    hi Special	term=bold ctermfg=LightRed guifg=Orange
    hi Identifier term=underline cterm=bold ctermfg=Cyan guifg=#40ffff
    hi Statement term=bold ctermfg=Yellow guifg=#ffff60 gui=bold
    hi PreProc	term=underline ctermfg=LightBlue guifg=#ff80ff
    hi Type	term=underline ctermfg=LightGreen guifg=#60ff60 gui=bold
    hi Ignore	ctermfg=black guifg=bg
  else
    hi Comment	term=bold ctermfg=DarkBlue guifg=Blue
    hi Constant	term=underline ctermfg=DarkRed guifg=Magenta
    hi Special	term=bold ctermfg=DarkMagenta guifg=SlateBlue
    hi Identifier term=underline ctermfg=DarkCyan guifg=DarkCyan
    hi Statement term=bold ctermfg=Brown gui=bold guifg=Brown
    hi PreProc	term=underline ctermfg=DarkMagenta guifg=Purple
    hi Type	term=underline ctermfg=DarkGreen guifg=SeaGreen gui=bold
    hi Ignore	ctermfg=white guifg=bg
  endif
  hi Error	term=reverse ctermbg=Red ctermfg=White guibg=Red guifg=White
  hi Todo	term=standout ctermbg=Yellow ctermfg=Black guifg=Blue guibg=Yellow

  " Common groups that link to default highlighting.
  " You can specify other highlighting easily.
  hi link String	Constant
  hi link Character	Constant
  hi link Number	Constant
  hi link Boolean	Constant
  hi link Float		Number
  hi link Function	Identifier
  hi link Conditional	Statement
  hi link Repeat	Statement
  hi link Label		Statement
  hi link Operator	Statement
  hi link Keyword	Statement
  hi link Exception	Statement
  hi link Include	PreProc
  hi link Define	PreProc
  hi link Macro		PreProc
  hi link PreCondit	PreProc
  hi link StorageClass	Type
  hi link Structure	Type
  hi link Typedef	Type
  hi link Tag		Special
  hi link SpecialChar	Special
  hi link Delimiter	Special
  hi link SpecialComment Special
  hi link Debug		Special

" luckrk
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
execute pathogen#infect()
set mouse=a
set visualbell
set number
if has("gui_running")
    set background=dark
    colorscheme gruvbox
    set guifont=Hack\ 12
    set guioptions=m
    " I like highlighting strings inside C comments.
    " Revert with ":unlet c_comment_strings".
    let c_comment_strings=1
endif
