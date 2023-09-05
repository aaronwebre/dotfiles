syntax on
set mouse=n
set ttymouse=xterm
set number
set hlsearch
set tabstop=2
set shiftwidth=2
set expandtab
set backspace=2
set maxmempattern=1000000
filetype plugin indent on
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" A split will default to being creating to the right of the current.
set splitright


" Custom Fugitive shortcuts
noremap <leader>gs :Gstatus <CR>
noremap <leader>gc :Gcommit <CR>
noremap <leader>gd :Gdiff <CR>
noremap <leader>gb :Gblame <CR>

" Tab completion in command mode shows all possible completions, shell style.
set wildmenu
set wildmode=longest:full,full

" Base64 encode/decode. Special detection because, of course, OSX has its own
" super special base64 that doesn't do stuff like base64 encode things?
if has("unix")
  vnoremap <leader>64d c<c-r>=system('base64 --decode', @")<cr><esc>

  let s:uname = system("uname -s")
  if s:uname == "Darwin"
    vnoremap <leader>64e c<c-r>=system('base64 -w0', @")<cr><esc>
  else
    vnoremap <leader>64e c<c-r>=system('openssl base64 -e -A', @")<cr><esc>
  endif
endif

" Toggle paste mode on and off.
" source: http://amix.dk/vim/vimrc.html
map <leader>pp :setlocal paste!<cr>
" Allow reselection of last pasted text.
" source:
" http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" GoLang options {{{
"
" Ale linter options
let g:ale_linters = {'go': ['gofmt', 'go build']}
let g:airline#extensions#ale#enabled = 1

augroup golangstyle
  autocmd!
  autocmd FileType go set tabstop=2 shiftwidth=2 noexpandtab
  autocmd FileType go noremap <leader>gt :GoTest <CR>
  autocmd FileType go noremap <leader>gT :GoTestFunc <CR>
  autocmd FileType go noremap <leader>gi :GoInfo <CR>

  " rails.vim-inspired switch commands, stolen from vim-go docs
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
augroup END


if has('nvim')
  function! GoStatusLine()
    return exists('*go#jobcontrol#Statusline') ? go#jobcontrol#Statusline() : ''
  endfunction

  function! AirlineInit()
          let g:airline_section_c = get(g:, 'airline_section_c', g:airline_section_c)
          let g:airline_section_c .= g:airline_left_sep . ' %{GoStatusLine()}'
  endfunction
  autocmd User AirlineAfterInit call AirlineInit()
endif

" Use vim-dispatch for appropriate commands. Currently only build, but maybe
" some day test as well: https://github.com/fatih/vim-go/pull/402
let g:go_dispatch_enabled = 1

" This is a hacky fix for :GoTest breaking when you use testify. It's parsing
" the errors and expecting things to look very specific, even though testify
" isn't doing anything that the standard testing library doesn't support. This
" stops it from opening a nonexistant file because it's incorrectly parsing
" the error message.
let g:go_jump_to_error=0

" Just autoimport for me, OK?
let g:go_fmt_command = "goimports"

" }}}

let g:terraform_fmt_on_save = 1

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Searches are case insensitive, unless upper case letters are used
set ignorecase
set smartcase

let $RUBYHOME=$HOME."/.rvm/rubies/default"
set rubydll=$HOME/.rvm/rubies/default/lib/libruby.dylib

let g:go_bin_path = $HOME."/go/bin"
