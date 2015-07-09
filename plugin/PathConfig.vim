if exists("g:loaded_pathconfig") || &cp
	"finish
endif
let g:loaded_pathconfig	= 1
let s:keepcpo           = &cpo
set cpo&vim
"""""""""""""""""""""""""""""""""""""""""""""
" initialize python
python << EOF
import vim
import os, fnmatch
EOF

" global variables
if !exists('g:pathconfig_path_configs')
	let g:pathconfig_path_configs = []
endif

" autocmd
augroup PathConfigAutoCmds
	autocmd!
	autocmd BufEnter * call s:ApplyConfig()
augroup END

" functions
fun! s:ApplyConfig()
python << EOF
filepath = vim.eval('expand(\'<afile>:p\')')
path_configs = vim.eval('g:pathconfig_path_configs')
for pattern, config in path_configs:
	if fnmatch.fnmatch(filepath, pattern):

		if 'setlocals' in config:
			for setparam in config['setlocals']:
				vim.command('exec \'setlocal %s\''%setparam)

		if 'localmaps' in config:
			for mapdata in config['localmaps']:
				for mapcmd in mapdata[0]:
					vim.command('exec \'%s <buffer> %s %s\''%(mapcmd, mapdata[1], mapdata[2]))

	break
EOF
endfun

"""""""""""""""""""""""""""""""""""""""""""""
let &cpo= s:keepcpo
unlet s:keepcpo
