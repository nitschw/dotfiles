call plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'preservim/nerdtree'
Plug 'dinhhuy258/vim-local-history', {'branch': 'master', 'do': ':UpdateRemotePlugins'}
Plug 'dense-analysis/ale'
Plug 'EdenEast/nightfox.nvim' " Vim-Plug
Plug 'cjuniet/clang-format.vim'
Plug 'luochen1990/rainbow'
Plug 'davidbeckingsale/writegood.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-autoformat/vim-autoformat'
call plug#end()


let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
colorscheme nightfox

" use <tab> for trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()


function! Run_cmake_format()
    	w  
    	!~/.local/venv/nvim/bin/cmake-format % -o %
   	call feedkeys(" ")
    	edit!
endfunction

function! Run_cmake_lint()
    	" !~/.local/venv/nvim/bin/cmake-lint %
	!ament_lint_cmake %
endfunction

function! Run_cpp_lint()
    	!ament_uncrustify %
endfunction

" isort, black, and pyflakes are all installed in a venv
function! Run_python_format()
    	w
    	!~/.local/venv/nvim/bin/isort %
    	!~/.local/venv/nvim/bin/black %
    	edit
endfunction

function! Run_pyflakes()
	"!~/.local/venv/nvim/bin/pyflakes %
	!ament_flake8
endfunction

" XML formatter
function! DoFormatXML() range
	" Save the file type
	let l:origft = &ft

	" Clean the file type
	set ft=

	" Add fake initial tag (so we can process multiple top-level elements)
	exe ":let l:beforeFirstLine=" . a:firstline . "-1"
	if l:beforeFirstLine < 0
		let l:beforeFirstLine=0
	endif
	exe a:lastline . "put ='</PrettyXML>'"
	exe l:beforeFirstLine . "put ='<PrettyXML>'"
	exe ":let l:newLastLine=" . a:lastline . "+2"
	if l:newLastLine > line('$')
		let l:newLastLine=line('$')
	endif

	" Remove XML header
	exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

	" Recalculate last line of the edited code
	let l:newLastLine=search('</PrettyXML>')

	" Execute external formatter
	exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

	" Recalculate first and last lines of the edited code
	let l:newFirstLine=search('<PrettyXML>')
	let l:newLastLine=search('</PrettyXML>')
	
	" Get inner range
	let l:innerFirstLine=l:newFirstLine+1
	let l:innerLastLine=l:newLastLine-1

	" Remove extra unnecessary indentation
	exe ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

	" Remove fake tag
	exe l:newLastLine . "d"
	exe l:newFirstLine . "d"

	" Put the cursor at the first line of the edited code
	exe ":" . l:newFirstLine

	" Restore the file type
	exe "set ft=" . l:origft
endfunction

function! Run_xmllint()
	!ament_xmllint %
endfunction

command! -range=% FormatXML <line1>,<line2>call DoFormatXML()

" autocmd FileType c nnoremap <F9> :ClangFormat<CR>
" autocmd FileType h nnoremap <F9> :ClangFormat<CR>
" autocmd FileType cpp nnoremap <F9> :ClangFormat<CR>
" autocmd FileType hpp nnoremap <F9> :ClangFormat<CR>
" autocmd FileType xml nnoremap <F9> :FormatXML<CR>

autocmd BufWritePre *.cpp :ClangFormat
autocmd BufWritePre *.hpp :ClangFormat
autocmd BufWritePre *.c :ClangFormat
autocmd BufWritePre *.h :ClangFormat
" autocmd BufWritePost *.cpp call Run_cpp_lint()
" autocmd BufWritePost *.hpp call Run_cpp_lint()
" autocmd BufWritePost *.c call Run_cpp_lint()
" autocmd BufWritePost *.h call Run_cpp_lint()
autocmd BufWritePre CMakeLists.txt call Run_cmake_format()
autocmd BufWritePost CMakeLists.txt call Run_cmake_lint()
autocmd BufWritePre *.py call Run_python_format()
autocmd BufWritePost *.py call Run_pyflakes()
autocmd BufWritePre *.xml :FormatXML
autocmd BufWritePost *.xml call Run_xmllint()

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
