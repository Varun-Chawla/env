colorscheme gruvbox

set relativenumber
set background=dark
set mouse=a
set showcmd
set foldmethod=syntax

:let mapleader = ","
:let maplocalleader = "\\"
:nnoremap <leader>ev :vsplit $MYVIMRC<cr>
:nnoremap <leader>sv :source $MYVIMRC<cr>

" Specify a directory for plugins - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-fugitive'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-syntastic/syntastic'
Plug 'scrooloose/nerdtree'
Plug 'pangloss/vim-javascript'
Plug 'vim-airline/vim-airline'
call plug#end()

" Default to filename searches - so that appctrl will find application controller
let g:ctrlp_by_filename = 1
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
  let &grepprg = 'ag --vimgrep --ignore={out,obj,objd,packages,Logs,QLogs,TestResults,"*log","*wrn","*dll","*pdb","*exe","*lib","*obj","*bin","*Cache","*hash*","*user","*filters"}'
  let g:ctrlp_user_command = 'ag %s -l --nocolor --ignore={Certs,MDM,out,obj,objd,packages,Logs,QLogs,TestResults,"*log","*wrn","*dll","*pdb","*exe","*lib","*obj","*bin","*Cache","*hash*","*user","*filters"} -g ""'
endif
" Bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes render properly when inside 256-color tmux and GNU screen. See also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" * and # search for next/previous of selected text when used in visual mode
xno * :<c-u>cal<SID>VisualSearch()<cr>/<cr>
xno # :<c-u>cal<SID>VisualSearch()<cr>?<cr>

fun! s:VisualSearch()
  let old = @" | norm! gvy
  let @/ = '\V'.substitute(escape(@", '\'), '\n', '\\n', 'g')
  let @" = old
endf
