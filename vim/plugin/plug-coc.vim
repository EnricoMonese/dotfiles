" plugin/plug-coc.vim

if !dkoplug#IsLoaded('coc.nvim') | finish | endif

augroup dkococ
  autocmd!
augroup END

let g:coc_auto_copen = 0
let g:coc_snippet_next = '<C-f>'
let g:coc_snippet_prev = '<C-b>'

function! s:ShowDocumentation()
  if &filetype ==# 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

let s:cpo_save = &cpoptions
set cpoptions&vim

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> K :<C-U>call <SID>ShowDocumentation()<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
