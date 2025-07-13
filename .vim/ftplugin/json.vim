" set proper PEP 8 indentation
setlocal tabstop=4 | 
setlocal softtabstop=4 | 
setlocal shiftwidth=4 |
setlocal textwidth=79 | 
setlocal expandtab |
setlocal autoindent |
setlocal fileformat=unix 

" Flagging Unnecessary Whitespace
highlight BadWhitespace ctermbg=red guibg=darkred
match BadWhitespace /\s\+$/

" make sure completion window closes when not used
let g:ycm_autoclose_preview_window_after_completion=1
" goto definition
map <C-b>  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" python with virtualenv support
python3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
	project_base_dir = os.environ['VIRTUAL_ENV']
	activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
	exec(compile(open(activate_this, "rb").read(), activate_this, 'exec'), dict(__file__=activate_this))
EOF

