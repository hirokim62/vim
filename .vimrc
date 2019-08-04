set smartindent

set backspace=indent,eol,start

set fileencodings=utf-8,shift-jis,euc-jp

set title

set virtualedit=block

highlight FullWidthSpace ctermbg=red

match FullWidthSpace /　/

set number

set expandtab

set tabstop=8

set shiftwidth=8

set list

set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%

set cursorline

set cursorcolumn

nnoremap <Leader>c :<C-u>setlocal cursorline! cursorcolumn!<CR>

syntax on

set incsearch

set laststatus=2

set cmdheight=2

inoremap ( ()<LEFT>

inoremap [ []<LEFT>

inoremap { {<CR>}<UP><CR>

inoremap " ""<LEFT>

function! MyFoldLevel(lnum)
    return getline(a:lnum)[0]=="\t"
endfunction

setlocal foldmethod=expr
setlocal foldexpr=MyFoldLevel(v:lnum)

let &statusline = "%<%f %m%r%h%w[%{&ff}][%{(&fenc!=''?&fenc:&enc).(&bomb?':bom':'')}]"
if has('iconv')
  let &statusline .= "0x%{FencB()}"

  function! FencB()
    let c = matchstr(getline('.'),'.',col('.') - 1)
    if c != ''
      let c = iconv(c, &enc, &fenc)
      return s:Byte2hex(s:Str2byte(c))
    else
      return '0'
    endif
  endfunction
  function! s:Str2byte(str)
    return map(range(len(a:str)), 'char2nr(a:str[v:val])')
  endfunction
  function! s:Byte2hex(bytes)
    return join(map(copy(a:bytes),'printf("%02X", v:val)'), '')
  endfunction
else
  let &statusline .= "0x%B"
endif
let &statusline .= "%=%l,%c%V %P"

if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif

if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_SI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XtermPasteBegin("")
endif
