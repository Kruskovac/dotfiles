set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'L9'

"File Search
Plugin 'scrooloose/nerdtree'
Plugin 'ryanoasis/vim-devicons'
Plugin 'ctrlpvim/ctrlp.vim'

"Statusbar at the bottom
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

"Autocomplete
Plugin 'Valloric/YouCompleteMe'

"Syntax checking
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
"Plugin 'bronson/vim-trailing-whitespace'
Plugin 'ntpeters/vim-better-whitespace'


"tmux navigator
Plugin 'christoomey/vim-tmux-navigator'

" show undo history
Plugin 'mbbill/undotree'

" tagbar of current sourcecode
Plugin 'majutsushi/tagbar'

" surround
Plugin 'tpope/vim-surround'

" autoclose
"Plugin 'Townk/vim-autoclose'

call vundle#end()            " required
filetype plugin indent on    " required


"###############################################################
"######################### SETTINGS ############################
"###############################################################

" Editor settings
set number
set relativenumber
syntax on
noremap <Leader>s :update<CR>
set colorcolumn=101
set cursorline
set backspace=indent,eol,start
set autoindent

" airline
let g:airline_theme='luna'
let g:airline_solarized_bg='dark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_exclude_preview = 1
set t_Co=256

" Python
let python_highlight_all=1
nnoremap <silent> <F5> :update \| call RunScript(expand('%:p')) <CR>
nnoremap <silent> <F9> y:call SendLineToPython() <CR>
vmap <silent> <F9> y:call SendLinesToPython() <CR>

" IPython
nnoremap <silent> <F6> :call RestartIPython() <CR>

" Filetype dependent settings
autocmd BufRead,BufNewFile *.pde,*.cpp,*.h
		\ let g:comment="//" |
		\ let g:compile="redo" |
		\ inoremap <buffer> {<CR> {<CR>}<up><end><CR>
autocmd BufRead,BufNewFile *.pde
		\ inoremap <buffer> {<CR> {<CR>}<up><end><CR><tab>
autocmd BufRead,BufNewFile *.py
		\ let g:comment="#" |
		\ let g:compile="script" |
		\ let g:syntastic_mode_map = {"mode": "passive"} " start python files with passive mode

" comments
map <S-k> :exec ":s@^@".g:comment."@"<CR>
map <S-j> :exec ":s@\\%<3c".g:comment."@@"<CR>
vnoremap <S-k> :<C-U>exec ":'<,'>s@^@".g:comment."@"<CR>
vnoremap <S-j> :<C-U>exec ":'<,'>s@\\%<3c".g:comment."@@"<CR>

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoTo<CR>
map <c-i>  :YcmCompleter GetDoc<CR>
let g:ycm_global_ycm_extra_conf="~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
let g:ycm_server_python_interpreter = g:python_interpreter " set in sourcing file

" File search
map <F2> :NERDTreeToggle<CR>
map <F3> :browse oldfiles<CR>
set runtimepath^=~/.vim/bundle/ctrlp.vim

" Syntax checking
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" TMux
let g:python_window='right'

" move splits / tmux panes
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" move buffers
nnoremap <s-h> :update \| bp <CR>
nnoremap <s-l> :update \| bn <CR>

" Colors
let base16colorspace=256
let g:solarized_termcolors=256
set background=dark
colorscheme solarized

" vimrc
map <leader>vimrc :e ~/Dokumente/dotfiles/.vimrc<cr>
autocmd bufwritepost .vimrc source $MYVIMRC

" Persistent undo
set undofile
set undodir=~/.vim/undo
set undolevels=1000
set undoreload=10000

" UndoTree
nmap <F4> :UndotreeToggle <CR>

" Tags
let g:tagbar_ctags_bin = g:ctags_path " set in sourcing file
nmap <F8> :TagbarToggle <CR>

" Whitespace color
highlight ExtraWhitespace ctermbg=darkblue
highlight MatchParen cterm=bold ctermbg=none ctermfg=green

" Tagbar
let g:tagbar_autofocus=1

" listchars
"set list listchars=tab:->,trail:.,nbsp:.

"##############################################################################
"############################# FUNCTIONS ######################################
"##############################################################################

function! RunScript(test)
	if g:compile == "script"
		let out = system("tmux send-keys -t dev.". g:python_window ." C-u")
		let l:path = substitute(a:test, '/c', 'c:', '')
		let out = system("tmux send-keys -t dev.". g:python_window ." ". shellescape('%run -i '. l:path))
"		sleep 500m
		let out = system("tmux send-keys -t dev.". g:python_window ." C-m")
	elseif g:compile == "redo"
		let out = system("tmux send-keys -t dev.". g:python_window ." Up C-m ")
	endif
endfunction

function! SendLinesToPython()
	exec ":'<,'> w!~/.vim/.pythonbuffer"
	let lines = FixPythonBufferIndent(readfile(expand('~/.vim/.pythonbuffer')))
	call writefile(lines, expand('~/.vim/.pythonbuffer'))
	let out = RunScript('~/.vim/.pythonbuffer')
endfunction

function! FixPythonBufferIndent(buffer_lines)
	let indent = -1
	let lines = []
	for line in a:buffer_lines
		if line != '' && indent == -1
			let indent = 0
			for c in split(line, '\zs')
				if c == ' '
					let indent += 1
				else
					break
				endif
			endfor
		endif
		if indent != -1
			call add(lines, substitute(line, '\s\{0,'. indent.'\}', '', ''))
		endif
	endfor
	return lines
endfunction

function! SendLineToPython()
	let line = getline(".")
	let out = system("tmux send-keys -t dev.". g:python_window ." '". line ."'")
	let out = system("tmux send-keys -t dev.". g:python_window ." C-m")
endfunction

function! RestartIPython()
	let out = system("tmux send-keys -t dev.". g:python_window ." C-u exit")
	let out = system("tmux send-keys -t dev.". g:python_window ." C-m")
	sleep 1000m
	let out = system("tmux send-keys -t dev.". g:python_window ." ./start_ipython.sh")
	let out = system("tmux send-keys -t dev.". g:python_window ." C-m")
endfunction
