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
"Plugin 'Valloric/YouCompleteMe'
Plugin 'davidhalter/jedi-vim'
Plugin 'ervandew/supertab'

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
"Plugin 'majutsushi/tagbar'

" surround
Plugin 'tpope/vim-surround'

" Latex
"Plugin 'lervag/vimtex'
"Plugin 'xuhdev/vim-latex-live-preview'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

" Notes
Plugin 'vimwiki/vimwiki'

" autoclose
"Plugin 'Townk/vim-autoclose'

call vundle#end()            " required
filetype plugin indent on    " required


"###############################################################
"####################### ENVIRONMENT ###########################
"###############################################################

let g:environment = substitute(system('uname'), '\n', "", "")
set viminfo='20,<50,s10,h


"###############################################################
"######################### SETTINGS ############################
"###############################################################

" Editor settings
set number
"set relativenumber
syntax on
noremap <Leader>s <C-s>
set colorcolumn=101
"set cursorline
set backspace=indent,eol,start
set autoindent
set lazyredraw

" handle scrolling through wrapped lines
nnoremap j gj
nnoremap k gk

" wildmenu
set wildmenu
set wildmode=longest:full,full

" highlight search
set hlsearch

" scrolling
set scrolloff=4

" Save with Ctrl + s in any mode
noremap <silent> <C-s> :update<CR>
vnoremap <silent> <C-s> <C-C>:update<CR>
"inoremap <silent> <C-s> <C-O>:update<CR>
inoremap <silent> <C-s> <Esc>:update<CR>

" Insert new line by pressing enter
noremap <CR> o<Esc>

" Stop beeping
set visualbell

" search word unter cursor
nnoremap <C-f> "zyiw:exec ":/".@z <CR>

" airline
let g:airline_theme='luna'
"let g:airline_solarized_bg='dark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_exclude_preview = 1
set t_Co=256

" Python
let python_highlight_all=1
"inoremap <silent> <F5> <Esc> :update \| call RunScript(expand('%:p')) <CR>
nnoremap <silent> <F5> :update \| call RunScript(expand('%:p'), 0) <CR>
"inoremap <silent> <F9> <Esc> y:call SendLineToPython() <CR>
nnoremap <silent> <F9> y:call SendLineToPython() <CR>
vmap <silent> <F9> y:call SendLinesToPython() <CR>

" IPython
nnoremap <silent> <F6> :call RestartIPython() <CR>

" Filetype dependent settings
autocmd BufRead,BufNewFile *.pde,*.cpp,*.h,*.cs,*.shader,*.js
		\ setlocal tabstop=4 |
		\ setlocal shiftwidth=4 |
		\ let g:comment="//" |
		\ let g:compile="redo" |
		\ inoremap <buffer> {<CR> {<CR>}<up><end><CR> |
autocmd BufRead,BufNewFile *.shader
		\ setlocal syntax=c
autocmd BufRead,BufNewFile *.vimrc
		\ let g:comment="\"" |
autocmd BufRead,BufNewFile *.pde
		\ inoremap <buffer> {<CR> {<CR>}<up><end><CR><tab>
autocmd BufRead,BufNewFile *.py,*pyx
		\ let g:comment="#" |
		\ let g:compile="script" |
		\ let g:syntastic_mode_map = {"mode": "passive"} | " start python files with passive mode
		\ setlocal tw=100 |
autocmd BufRead,BufNewFile *.tex
		\ setlocal tabstop=4 |
		\ setlocal shiftwidth=4 |
		\ let g:comment="%" |
		\ let g:compile="latex" |
		\ setlocal tw=100 |
		\ command! Spell call ToggleSpellCheck()
"		\ setlocal spell spelllang=de_de |

" comments
map <silent> <S-k> :exec ":s@^@".g:comment."@e"<CR> :noh <CR> " e at the end of search ignores errors
map <silent> <S-j> :exec ":s@\\%<3c".g:comment."@@e"<CR> :noh <CR>
vnoremap <silent> <S-k> :<C-U>exec ":'<,'>s@^@".g:comment."@e"<CR> :noh <CR>
vnoremap <silent> <S-j> :<C-U>exec ":'<,'>s@\\%<3c".g:comment."@@e"<CR> :noh <CR>

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoTo<CR>
map <c-i>  :YcmCompleter GetDoc<CR>
let g:ycm_global_ycm_extra_conf="~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
if g:environment == "MINGW64_NT-10.0" || g:environment == "MINGW64_NT-6.1"
	let g:ycm_server_python_interpreter = g:python_interpreter " set in sourcing file
endif
let g:ycm_semantic_triggers = {
	\   'python': [ 're!\w{2}' ]
	\ }

" jedi
let g:jedi#documentation_command = "<C-i>"
let g:jedi#use_tag_stack = 0
let g:jedi#popup_select_first = 0
let g:jedi#show_call_signatures = "2"

" Supertab
set completeopt=menu,longest    " Use the popup menu by default; only insert the longest common text of the completion matches; don't automatically show extra information in the preview window.
let g:SuperTabDefaultCompletionType = "<c-n>"

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
"let base16colorspace=256
let g:solarized_termcolors=256
set background=dark
colorscheme solarized
hi Normal guibg=NONE ctermbg=NONE

" vimrc
map <leader>vimrc :e ~/Dokumente/dotfiles/.vimrc<cr>
autocmd bufwritepost .vimrc source $MYVIMRC

" Persistent undo
set undofile
"set undodir=~/.vim/undo
set undodir=/d/Vim_undo/undo/
set undolevels=1000
set undoreload=10000

" UndoTree
nmap <F4> :UndotreeToggle <CR>

" Tags
if g:environment == "MINGW64_NT-10.0" || g:environment == "MINGW64_NT-6.1"
let g:tagbar_ctags_bin = g:ctags_path " set in sourcing file
endif
nmap <F8> :TagbarToggle <CR>

" Whitespace color
highlight ExtraWhitespace ctermbg=darkblue
highlight MatchParen cterm=bold ctermbg=none ctermfg=green

" Tagbar
let g:tagbar_autofocus=1

" Latex live preview
command! Latex call CompileLatex()
if g:environment == "MINGW64_NT-10.0" || g:environment == "MINGW64_NT-6.1"
let g:livepreview_engine = g:pdflatex
let g:livepreview_previewer = g:pdf_viewer
endif
command! LatexClean call CleanLatex()

" UltiSnips
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-j>"

" listchars
"set list listchars=tab:->,trail:.,nbsp:.

" json
command! FormatJson :%!python -m json.tool


" join lines without spacing and tabs
noremap <silent> gJ :j <CR>

" VimWiki
noremap <Leader>äwfabc <Plug>VimwikiFollowLink
noremap <Leader>wf :VimwikiFollowLink<CR>
let g:vimwiki_list = [{'path': '/d/Workspace/Sonstiges/notes', 'syntax': 'markdown', 'ext': '.md'}]


" Use Windows clipboard
function! ClipboardYank()
	call writefile(split(@@, "\n"), '/dev/clipboard')
endfunction

function! ClipboardPaste()
	let @@ = join(readfile('/dev/clipboard'), "\n")
endfunction

if g:environment == "MINGW64_NT-10.0" || g:environment == "MINGW64_NT-6.1"
	vnoremap <silent> y y:call ClipboardYank()<CR>
	vnoremap <silent> d d:call ClipboardYank()<CR>
	nnoremap <silent> *p :call ClipboardPaste()<CR>p
endif

" Debugging
command! Debug :normal oimport pdb; pdb.set_trace()<ESC>
command! DebugQt :normal oimport pdb;import PyQt4.QtCore;PyQt4.QtCore.pyqtRemoveInputHook();pdb.set_trace()<ESC>

" exec path
command! SetExecPath :let g:exec_path=expand("%:p")
command! UnsetExecPath :unlet exec_path

" workspace path
command! SetWorkspacePath :let g:workspace_path=expand("%:p:h")
command! UnsetWorkspacePath :unlet workspace_path

"##############################################################################
"############################# FUNCTIONS ######################################
"##############################################################################

function! RunScript(test, use_test)
	let l:path = a:test
	let l:work_path = ""
	if (a:use_test) == 0 && exists("g:exec_path")
		let l:path = g:exec_path
	endif
	if exists("g:workspace_path")
		let l:work_path = g:workspace_path
	endif

	if g:compile == "script"
		let out = system("tmux send-keys -t dev.". g:python_window ." C-u")
		if g:environment == "MINGW64_NT-10.0" || g:environment == "MINGW64_NT-6.1"
			let l:path = system("cygpath -m '".l:path."'")
			let l:path = substitute(l:path, '\n', '', '')
"			let l:path = substitute(a:test, '/d', 'd:', '')
"			let l:path = substitute(a:test, '/q', 'q:', '')
		endif
		if l:work_path != ""
			if g:environment == "MINGW64_NT-10.0" || g:environment == "MINGW64_NT-6.1"
				let l:work_path = system("cygpath -m '".l:work_path."'")
				let l:work_path = substitute(l:work_path, '\n', '', '')
			endif
			let out = system("tmux send-keys -t dev.". g:python_window ." ". shellescape('cd "'. l:work_path .'"'))
			let out = system("tmux send-keys -t dev.". g:python_window ." C-m")
		endif

		let out = system("tmux send-keys -t dev.". g:python_window ." ". shellescape('%run -i "'. l:path .'"'))
"		sleep 500m
		let out = system("tmux send-keys -t dev.". g:python_window ." C-m")
	elseif g:compile == "redo"
		let out = system("tmux send-keys -t dev.". g:python_window ." Up C-m ")
	elseif g:compile == "latex"
		call CompileLatex()
	endif
endfunction

function! SendLinesToPython()
	exec ":'<,'> w!~/.vim/.pythonbuffer"
	let lines = FixPythonBufferIndent(readfile(expand('~/.vim/.pythonbuffer')))
	call writefile(lines, expand('~/.vim/.pythonbuffer'))
	let out = RunScript('~/.vim/.pythonbuffer', 1)
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

function! CompileLatex()
	exec ":update"
	let file_name = expand("%:t:r")
	let tex_file = file_name.".tex"
	let pdf_file = file_name.".pdf"
	let output_dir = expand("%:p:h")

	let compile_latex = g:latexmk." -pdflatex='pdflatex -synctex=1 -shell-escape' -pdf ".file_name
	let forward_search = "start ".g:pdf_viewer." -reuse-instance ".pdf_file.
				\ " -forward-search ".tex_file." ".line(".")
	let out = system("tmux send-keys -t latex:1 ".
			\ shellescape(
				\ "cd '".output_dir."'
				\   && ".
				\ compile_latex.
				\ " && ".
				\ forward_search.
				\ " ;
				\ ~/sendKeys.bat Latex ''"
			\).
			\ " C-m")
endfunction

function! CleanLatex()
	let output_dir = expand("%:p:h")
	let clean_latex = g:latexmk." -c"
	let out = system("tmux send-keys -t latex:1 ".
			\ shellescape(
				\ "cd '".output_dir."'
				\   && ".
				\ clean_latex.""
			\).
			\ " C-m")
endfunction

function! ToggleSpellCheck()
	let spell_info = execute(":set spell?")
	let spell_info = substitute(spell_info, '\n', '', '')
	let spell_info = substitute(spell_info, ' ', '', '')
	if spell_info == "nospell"
		setlocal spell spelllang=de_de
	else
		set nospell
	endif
endfunction

function! SetIPythonPath()
	let curr_file_path = expand('%:p:h')
	let curr_file_path = system("cygpath -m '".curr_file_path."'")
	let out = system("tmux send-keys -t dev.". g:python_window ." 'cd ". curr_file_path ."'")
	let out = system("tmux send-keys -t dev.". g:python_window ." C-m")
endfunction


"########################################
"################ TEST ##################
"########################################

"function! g:UltiSnips_Complete()
"	call UltiSnips#ExpandSnippet()
"	if g:ulti_expand_res == 0
"		if pumvisible()
"			return "\<C-n>"
"		else
"			call UltiSnips#JumpForwards()
"			if g:ulti_jump_forwards_res == 0
"				return "\<TAB>"
"			endif
"		endif
"	endif
"	return ""
"endfunction
"
"au InsertEnter * exec "inoremap <silent> ".g:UltiSnipsExpandTrigger." <C-R>=g:UltiSnips_Complete()<cr>"
