set shell=/bin/bash
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"	alternatively, pass a path where Vundle should install plugins
"	call vundle#begin('~/some/path/here')

"	let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'lervag/vimtex'
Plugin 'https://github.com/ycm-core/YouCompleteMe'
Plugin 'vim-syntastic/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'jupyter-vim/jupyter-vim'
Plugin 'https://github.com/ConradIrwin/vim-bracketed-paste'
Plugin 'https://github.com/goerz/jupytext.vim'
" Plugin 'jistr/vim-nerdtree-tabs'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'"
" Plugin 'https://github.com/davidhalter/jedi-vim'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'"
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}"
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

let g:vimtex_view_general_viewer = 'evince'
set rnu
set tabstop=4 shiftwidth=4

" split navigations
"nnoremap <C-J> <C-W><C-J>
"nnoremap <C-K> <C-W><C-K>
"nnoremap <C-L> <C-W><C-L>
"nnoremap <C-H> <C-W><C-H>

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
"nnoremap <space> za

" remember folds
" CAREFUL: also remembers when filetype was manually changed and maybe other settings
" CAREFUL: generally can make problems with all :Plugin* commands
augroup remember_folds
	autocmd!
	set viewoptions=folds
	au BufWinLeave * silent! mkview
	au BufWinEnter * silent! loadview
augroup END

" set default encoding
set encoding=utf-8


let python_highlight_all=1
syntax on

if has('gui_running')
	"set background=dark
	colorscheme solarized
else
	colorscheme zenburn
	" make background transparent
	let g:zenburn_transparent = 1
	hi Normal ctermbg=NONE
	hi LineNr ctermbg=NONE
	" make powerline appear always
	set laststatus=2
endif

" easyily toggle darkmode 
call togglebg#map("<F5>")

" map NERDTree to Ctrl-n
map <C-n> :NERDTree<CR>

" use Ctrl-c to copy selection to clipboard
vmap <C-c> "+y
" commands such as :yank :put will be sent to clipboard
set clipboard=unnamedplus

let g:Powerline_symbols = 'fancy'

" split navigations, plain
"nnoremap <C-J> <C-W><C-J>
"nnoremap <C-K> <C-W><C-K>
"nnoremap <C-L> <C-W><C-L>
"nnoremap <C-H> <C-W><C-H>

" split navigations, with resize
function Splitresize()
    let hmax = max([winwidth(0), float2nr(&columns*0.66), 90])
    let vmax = max([winheight(0), float2nr(&lines*0.66), 25])
    exe "vertical resize" . (min([hmax, 140]))
    exe "resize" . (min([vmax, 60]))
endfunction

nnoremap <silent><C-J> <C-W><C-J>:call Splitresize()<CR>
nnoremap <silent><C-K> <C-W><C-K>:call Splitresize()<CR>
nnoremap <silent><C-L> <C-W><C-L>:call Splitresize()<CR>
nnoremap <silent><C-H> <C-W><C-H>:call Splitresize()<CR>

let g:jupytext_filetype_map = {'md': 'python'}
let g:jupytext_fmt = 'py:percent'
let g:jupyter_mapkeys = 0

