" >>> 基础配置 <<<
let mapleader = ","
set nocompatible
filetype on
filetype plugin on
set noeb
syntax enable
syntax on
set t_Co=256
set cmdheight=2
set showcmd
set ruler
set laststatus=2
set number
set cursorline
set whichwrap+=<,>,h,l
set ttimeoutlen=0
set scrolloff=2
set path +=.,/usr/include
set fileformats=unix,dos
" set mouse=a

if has("gui_running")
    " shell macVim中文输入法问题
    " defaults write org.vim.MacVim MMUseInlineIm 0
    set guifont=UbuntuMonoNerdFontComplete-Regular:h16
    set guioptions-=m " 隐藏菜单栏
    set guioptions-=T " 隐藏工具栏
    set guioptions-=L " 隐藏左侧滚动条
    set guioptions-=r " 隐藏右侧滚动条
    set guioptions-=b " 隐藏底部滚动条
    set showtabline=0 " 隐藏Tab栏
endif

set autoindent
set cindent
set cinoptions=g0,:0,N-s,(0
set smartindent
filetype indent on
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set wrap
set textwidth=0
set nolinebreak
set backspace=2
set sidescroll=10
set nofoldenable

set wildmenu
set completeopt-=preview

set hlsearch
set incsearch
set ignorecase
set smartcase

set nobackup
set noswapfile
set autoread
set autowrite
set confirm

set langmenu=zh_CN.UTF-8
set helplang=cn
set termencoding=utf-8
set encoding=utf8
set fileencodings=utf8,ucs-bom,gbk,cp936,gb2312,gb18030

" diff配色
" highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
" highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
" highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
" highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red


nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

function! Get_visual_selection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][:column_end - 1]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

" vmap <c-c> "+y
function! Get_visual_selection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    " check if last word is long utf8
    let n = -1
    if &enc == 'utf-8'
        let c = char2nr(lines[-1][column_end - 1:column_end - 1])
        while and(c, 0x80) != 0 && and(c, 0xc0) != 0x80
          let c = c * 2
          let n = n + 1
        endwhile
    else
        " if not utf-8 then select [)
        let n = -2
    endif
    let lines[-1] = lines[-1][:column_end + n]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

" for ssh
" vmap <silent> <c-c> :<c-u>call system('nc -c ${SSH_CONNECTION%% *} 2000', Get_visual_selection())<cr>

" 远端拷贝
" 自行实现命令pbcopy-remote
" vnoremap <c-c> :w !pbcopy-remote<CR><CR>
" #!/usr/bin/env bash
" pbcopy
" _remote_ip="${SSH_CLIENT%% *}"
" if [ ! -z "$_remote_ip" ]; then
"   pbpaste | nc "$_remote_ip" 2000
" fi

vmap <c-c> "+y

" cd to path of current file 
nnoremap <silent> <leader><leader>cd :lcd %:p:h<cr>

autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif

set background=dark
let g:onedark_termcolors=256
colorscheme Tomorrow-Night

" >>> 插件 <<<

call plug#begin()

Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'chxuan/cpp-mode'
Plug 'preservim/tagbar'
Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 ./install.py --clangd-completer --go-completer --rust-completer' }
Plug 'jasontbradshaw/pigeon.vim'
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'haya14busa/incsearch.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround' " `cs(]` 修改成对符号()->[]
Plug 'tpope/vim-commentary' " 将代码注释掉
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'skywind3000/asyncrun.vim'
Plug 'zivyangll/git-blame.vim'
Plug 'ZhuzhuNo3/vim-ack'
" Plug 'Shougo/deol.nvim'
" Plug 'Shougo/deoplete.nvim'
" Plug 'Shougo/deoplete-zsh'
" Plug 'Shougo/unite.vim'
" Plug 'Shougo/vimproc'
" Plug 'Shougo/vimfiler'
" Plug 'Shougo/neossh.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'rust-lang/rust.vim'
" Plug 'junegunn/vim-slash'
Plug 'junegunn/gv.vim'
" Plug 'terryma/vim-smooth-scroll'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'Vimjas/vim-python-pep8-indent' " python 缩进
" Plug 'MarcWeber/vim-addon-mw-utils'
" Plug 'tomtom/tlib_vim'
" Plug 'garbas/vim-snipmate'
" Plug 'honza/vim-snippets'

call plug#end()

nnoremap <leader><leader>i :PlugInstall<cr>
nnoremap <leader><leader>u :PlugUpdate<cr>
nnoremap <leader><leader>c :PlugClean<cr>

" >>> 插件配置 <<<

" nerdtree
nnoremap <silent> <leader>n :NERDTreeToggle<cr>
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeHighlightFolders = 1
let g:NERDTreeHighlightFoldersFullName = 1
let g:NERDTreeDirArrowExpandable='▷'
let g:NERDTreeDirArrowCollapsible='▼'
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }

" cpp-mode
nnoremap <leader>y :CopyCode<cr>
nnoremap <leader>p :PasteCode<cr>
" nnoremap <leader>U :GoToFunImpl<cr>
nnoremap <silent> <leader>a :Switch<cr>

" tagbar
let g:tagbar_width = 30
nnoremap <silent> <leader>t :TagbarToggle<cr>
" tagbar go support
let g:tagbar_type_go = {
            \ 'ctagstype' : 'go',
            \ 'kinds'     : [
            \ 'p:package',
            \ 'i:imports',
            \ 'c:constants',
            \ 'v:variables',
            \ 't:types',
            \ 'n:interfaces',
            \ 'w:fields',
            \ 'e:embedded',
            \ 'm:methods',
            \ 'r:constructor',
            \ 'f:functions'
            \ ],
            \ 'sro' : '.',
            \ 'kind2scope' : {
            \ 't' : 'ctype',
            \ 'n' : 'ntype'
            \ },
            \ 'scope2kind' : {
            \ 'ctype' : 't',
            \ 'ntype' : 'n'
            \ },
            \ 'ctagsbin'  : 'gotags',
            \ 'ctagsargs' : '-sort -silent'
            \ }

" YCM
let g:ycm_clangd_args=['--header-insertion=never']
let g:ycm_server_log_level = 'debug'
let g:ycm_show_diagnostics_ui = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_auto_hover = ''
" let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'
" let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_error_symbol = '✗'
let g:ycm_warning_symbol = '✹'
" let g:ycm_seed_identifiers_with_syntax = 1 
let g:ycm_echo_current_diagnostic = 'virtual-text'
let g:ycm_complete_in_comments = 1 
let g:ycm_complete_in_strings = 1 
let g:ycm_collect_identifiers_from_tags_files = 1
" let g:ycm_log_level='debug'
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_semantic_triggers =  {
            \   'c,cpp,objcpp' : ['->', '.', '::','re!\w{2}'],
            \   'python,go' : ['.','re!\w{1}'],
            \   'ruby,rust': ['.', '::'],
            \ }
            " \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.','re!\w{2}'],
" 使用自定义的 LSP 位置
" go install golang.org/x/tools/gopls@latest
let g:ycm_gopls_binary_path='/Users/zz/Code/go/bin/gopls'
" brew install llvm
let g:ycm_clangd_binary_path='/usr/bin/clangd'
" rustup component add rust-analyzer
let g:ycm_rust_toolchain_root = '/Users/zz/.cargo'

nnoremap <leader>U :YcmCompleter GoToDeclaration<cr>
nnoremap <leader>u :YcmCompleter GoToDefinition<cr>
nnoremap <leader>o :YcmCompleter GoToInclude<cr>
nnoremap <leader>ff :YcmCompleter FixIt<cr>
nmap <leader>h <plug>(YCMHover)

" pigeon
au BufRead,BufNewFile *.peg set ft=pigeon

" LeaderF
" <leader>f -> search from current path
nnoremap <leader><leader>f :LeaderfFile ~/<cr>
let g:Lf_WildIgnore = {
            \ 'dir': ['.svn','.git','.hg','.vscode','.wine','.deepinwine','.oh-my-zsh'],
            \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
            \}
let g:Lf_UseCache = 0

" incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
let g:easy_align_ignore_groups = ['String']

" git-blame
let g:enable_git_blame = 0
nnoremap <silent><leader>b :if (g:enable_git_blame == 0) \| let g:enable_git_blame = 1 \| execute ":GitBlame" \| else \| let g:enable_git_blame = 0 \| echo '' \| endif<cr>
autocmd CursorMoved * if (g:enable_git_blame != 0) | exec ":GitBlame" | endif

" AsyncRun
let $PYTHONUNBUFFERED=1

" ack
let g:ack_focus_after_search = 1
" let g:ack_program_lists = []
vnoremap <silent> <leader>F :call ack#search(1,"")<cr>
nnoremap <silent> <leader>F :call ack#search(0,"")<cr>
hi QuickFixLine ctermfg=NONE ctermbg=12 guifg=NONE guibg=#de935f

" deol 用了tmux之后还是tmux更香
" tnoremap <ESC> <ESC><C-\><C-n>
" " nnoremap <silent> <leader>T :botright vs \| Deol \|vertical resize 50<cr>
" nnoremap <silent> <leader>T :botright sp \| Deol \|resize 10<cr>
" let g:deol#extra_options = {'term_finish':'close'}
" augroup deolresize
"     autocmd BufEnter * :if &ft == 'deol' | resize 10 | normal! i | endif
" augroup END

" airline
let g:airline_powerline_fonts = 1
let g:airline_section_b = '%{airline#extensions#branch#get_head()[:-4]} '
" don't show progress line
let g:airline_section_x = '%#__accent_bold#%#__restore__#%{airline#util#prepend("",0)}%{airline#util#prepend(airline#extensions#tagbar#currenttag(),0)}%{airline#util#prepend("",0)}%{airline#util#prepend("",0)}%{airline#util#prepend("",0)}'
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

" gv
nnoremap <leader>g :GV<cr>
nnoremap <leader>G :GV!<cr>

" " vim-smooth-scroll
" noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 8, 1)<CR>
" noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 8, 1)<CR>

" markdown
let g:mkdp_path_to_chrome = "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome"
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_math = 1
" let g:mkdp_markdown_css='githubdiy.css'
let g:mkdp_markdown_css="/Users/zz/Library/Application\\ Support/abnerworks.Typora/themes/githubdiy.css"
let g:mkdp_auto_close = 0
nmap <silent> <F7> <Plug>MarkdownPreview
imap <silent> <F7> <Plug>MarkdownPreview
nmap <silent> <F8> <Plug>MarkdownPreviewStop
imap <silent> <F8> <Plug>MarkdownPreviewStop

" >>> 瞎折腾产物 <<<

" 编辑golang代码时，按ESC自动格式化
function! KeepView(f, ...)
  " 保存未命名寄存器
  let l:save_unnamed_register = getreg('')
  " 保存当前视图状态
  let l:save_view = winsaveview()
  " 请求方法
  call call(a:f, a:000)
  " 恢复视图状态
  call winrestview(l:save_view)
  " 恢复未命名寄存器
  call setreg('', l:save_unnamed_register)
endfunction

function! ResetLine(start_pos, old, new)
  if a:old == a:new
    return
  endif
  if a:old > a:new
    execute (a:start_pos+a:new) . ',' . (a:start_pos+a:old-1) . 'd _'
    return
  endif
  call append(a:start_pos+a:old-1, repeat([''], a:new-a:old))
endfunction

function! GetGlobalGoDef(line)
  if a:line < 1
    return 1
  endif
  if a:line > line('$')
    return line('$')
  endif
  call cursor(a:line, 0)
  let l:ans = search('^\%(func\|const\|var\|type\)\>', 'bcnW')
  if l:ans < 1
    return 1
  endif
  return l:ans
endfunction

function! GetGlobalGoDefEnd(line)
  if a:line < 0
    return 0
  endif
  if a:line > line('$')
    return line('$')
  endif
  call cursor(a:line, strlen(getline(a:line)))
  let l:end_pos = search('^}', 'cnW')
  if l:end_pos == 0
    let l:end_pos = line('$')
  endif
  return l:end_pos
endfunction

function! FormatGoCode(start, end)
  if a:end < a:start
    let [a:end, a:start] = [a:start, a:end]
  endif
  " 查找当前光标所在位置的函数、定义开始
  let l:start_pos = GetGlobalGoDef(a:start)
  " 查找结束位置
  let l:end_pos = GetGlobalGoDefEnd(GetGlobalGoDef(a:end))
  " 向上下进行扩充
  let l:start_pos = GetGlobalGoDef(l:start_pos-1)
  let l:end_pos = GetGlobalGoDefEnd(l:end_pos+1)
  " 使用 gofmt 格式化代码
  let l:formatted = system('gofmt', join(getline(l:start_pos, l:end_pos), "\n"))
  " 检查 gofmt 是否执行成功
  if v:shell_error != 0
    return
  endif
  " 将格式化的结果分割成行列表
  let l:lines = split(l:formatted, "\n", 1)
  " 从列表末尾开始移除空字符串
  while !empty(l:lines) && l:lines[-1] ==# ''
    call remove(l:lines, -1)
  endwhile
  " 确保行数正确
  call ResetLine(l:start_pos, l:end_pos-l:start_pos+1, len(l:lines))
  " 替换缓冲区内容至新的行数或当前行数的最小值
  call setline(l:start_pos, l:lines)
  " 保存
  write
endfunction

augroup GoFileTypeMappings
  autocmd!
  autocmd FileType go nnoremap <silent><buffer> ==  :call KeepView('FormatGoCode', line('.'), line('.'))<CR>
  autocmd FileType go nnoremap <silent><buffer> =G  :call KeepView('FormatGoCode', line('.'), line('$'))<CR>
  autocmd FileType go nnoremap <silent><buffer> =gg :call KeepView('FormatGoCode', 1, line('.'))<CR>
  autocmd FileType go vnoremap <silent><buffer> =   :call KeepView('FormatGoCode', line("'<"), line("'>"))<CR>
augroup END

" 格式化Json
nnoremap <silent> <leader>j :execute '%!jq -M --indent 2' \| :set ft=json \| :1<cr>
vnoremap <silent> <leader>j :!jq -M --indent 2<cr>
" or use: JsonFormat
" #!/bin/zsh
" python -m json.tool|python -c "import re,sys;sys.stdout.write(re.sub(r\"\\\u[0-9a-f]{4}\", lambda m:m.group().decode(\"unicode_escape\").encode(\"utf-8\"), sys.stdin.read()))"

" URL encode/decode selection
vnoremap <leader>en :!python3 -c 'import sys; from urllib import parse; print(parse.quote_plus(sys.stdin.read().strip()))'<cr>
vnoremap <leader>de :!python3 -c 'import sys; from urllib import parse; print(parse.unquote_plus(sys.stdin.read().strip()))'<cr>

" mouse mode convert
nnoremap <silent><leader>m :if &mouse == 'a' \| set mouse= \| echo 'mouse mode off' \| else \| set mouse=a \| echo 'mouse mode on' \| endif<cr>

" 文件编码转换
nnoremap <silent><leader>l :if &fenc == 'utf-8' \| e! ++enc=cp936 \| else \| e ++enc=utf-8 \| endif<cr>

" utf8 2 gbk hex
" shell: iconv -f utf8 -t cp936 | hexdump -e '16/1 "%.1x"' | sed 's/../\\x&/g'
" vnoremap <silent><leader>c :<c-u>s/\%V.*\%V./\=system('u8_2gbkhex', submatch(0))/g<cr>:noh<cr>``
" nnoremap <silent><leader>c :<c-u>s/\%#./\=system('u8_2gbkhex', submatch(0))/g<cr>:noh<cr>``

" 8进制中文转换 如：\346\230\257\347\232\204 == 是的
vnoremap <silent><leader>c :s/\(\(\\\d\{3\}\)\{3,\}\)/\=system('x=`cat`&&awk "BEGIN{printf \"$x\"}"', submatch(1))/g<cr>:noh<cr>
nnoremap <silent><leader>c :s/\(\(\\\d\{3\}\)\{3,\}\)/\=system('x=`cat`&&awk "BEGIN{printf \"$x\"}"', submatch(1))/g<cr>:noh<cr>

" 代码折叠 折叠最近的大括号
set foldmethod=syntax
command! -nargs=0 FoldCurrentField :call <sid>fold_current_field()
" augroup foldFunc
"     autocmd! BufWritePre,BufWinLeave *.js,*.c,*.cc,*.cpp,*.h,*.hh,*.hpp,*.go mkview
"     autocmd! BufWinEnter             *.js,*.c,*.cc,*.cpp,*.h,*.hh,*.hpp,*.go call <sid>fold_init()
" augroup END
" function! s:fold_init()
"     loadview
"     if v:foldstart
"         execute "normal! zR"
"         return
"     endif
"     let curpos = getcurpos()
"     call setpos('.', [0, 1, 1, 0, 0])
"     while 1
"         let l:l = search('{', 'W', 0, 0, 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string\\|comment"')    
"         let pos = getcurpos()
"         let l:rl = searchpair('{', '', '}', 'W', 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string\\|comment"')
"         if (l:l == 0 || l:rl == 0)
"             call setpos('.', curpos)
"             execute "normal! zR"
"             return
"         endif
"         call setpos('.', pos)
"         if (l:rl - l:l > 2)
"             execute (l:l+1).",".(l:rl-1)."fo"
"         endif
"     endwhile
" endfunction
function! s:fold_current_field()
    if (-1 != foldclosed(line('.')))
        silent execute "normal! zo"
        return
    endif
    let curpos = getcurpos()
    execute "normal! g_"
    let searchline = searchpair('{', '', '}', 'cbW', 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string\\|comment"')
    let rsearchline = searchpair('{', '', '}', 'W', 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string\\|comment"')
    call setpos('.', curpos)
    if (searchline == 0 || rsearchline == 0)
        echo "折叠失败"
        return
    elseif (rsearchline - searchline < 3)
        echo "行数过短, 无法折叠"
        return
    endif
    call cursor(searchline+1,0)
    if (-1 != foldclosed(line('.')))
        silent execute "normal! zo"
        return
    endif
    if (0 == foldlevel('.'))
        execute (searchline+1).",".(rsearchline-1)."fo"
    endif
    execute "normal! zc"
endf
" nnoremap <silent> za :FoldCurrentField<cr>

" buffer开关
command! -nargs=0 CloseBufferFirst :call <sid>close_current_buffer()
command! -nargs=0 CloseWindowFirst :call <sid>close_current_window()

function! s:is_no_file()
  return &bt == 'quickfix' || &bt == 'nofile'
endfunction

autocmd BufLeave * if !s:is_no_file() | let g:last_bufnr = bufnr('%') | endif

function! SkipNofile(cmd)
    let curr = bufnr('%')
    execute a:cmd
    while bufnr('%') != curr && s:is_no_file()
        execute a:cmd
    endwhile
endf

function! s:close_current_buffer()
    let l:curr = bufnr("%")
    if exists("g:last_bufnr") && bufexists(g:last_bufnr) && g:last_bufnr != l:curr
        execute ":b " . g:last_bufnr
    else
        let l:n = winnr('$')
        while l:n > 0
            if l:curr == bufnr("%")
                call SkipNofile(":bn")
            endif
            let l:n -= 1
        endwhile
    endif
    execute ":bw " . l:curr
endf

function! s:close_current_window()
    let l:curr = bufnr('%')
    let l:exist_bufsize = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    let l:ignore_buffers = ["nofile","quickfix"]
    let l:ig_size = len(filter(range(1,winnr('$')), "index(l:ignore_buffers, getbufvar(winbufnr(v:val), '&bt'))>=0"))
    let l:nig_size = len(filter(range(1,winnr('$')), "index(l:ignore_buffers, getbufvar(winbufnr(v:val), '&bt'))<0"))
    if l:nig_size == 1 && l:exist_bufsize > l:ig_size + 1 && index(l:ignore_buffers, getbufvar(l:curr, '&bt')) < 0
        if exists("g:last_bufnr") && bufexists(g:last_bufnr) && g:last_bufnr != l:curr
            execute ":b " . g:last_bufnr
        else
            execute ":bn " . l:curr
        endif
        execute ":bw " . l:curr
        return
    endif

    if winnr('$') > 1
        execute ":close"
    elseif l:exist_bufsize == 1
        execute ":q"
    else
        execute ":bw " . l:curr
    endif
endf

" nnoremap <silent> <c-p> :bp \| if &filetype == 'deol' \| bp \| endif<cr>
" nnoremap <silent> <c-n> :bn \| if &filetype == 'deol' \| bn \| endif<cr>
nnoremap <silent> <c-p> :call SkipNofile("bp")<cr>
nnoremap <silent> <c-n> :call SkipNofile("bn")<cr>
nnoremap <silent> <leader>d :CloseWindowFirst<cr>
nnoremap <silent> <leader>D :CloseBufferFirst<cr>

nnoremap <leader>- :vertical resize -3<CR>
nnoremap <leader>= :vertical resize +3<CR>

" 运行代码
nnoremap <leader>r :call RunCode()<cr>
function! RunCode()
    exec "w"
    if &filetype == 'c'
        let compile_flag = input("Flags: ")
        silent execute ":AsyncRun -strip -raw gcc " . expand("%") . " -o " . expand("%<") . " " . compile_flag . " && chmod +x " . expand("%<") . " && ./" . expand("%<")
        silent execute ":copen"
    elseif &filetype == 'cpp'
        let compile_flag = input("Flags: ")
        silent execute ":AsyncRun -strip -raw g++ " . expand("%") . " -o " . expand("%<") . " " . compile_flag . " && chmod +x " . expand("%<") . " && ./" . expand("%<")
        silent execute ":copen"
    elseif &filetype == 'go'
        silent execute ":AsyncRun -strip -raw go run " . expand("%:p")
        silent execute ":copen"
    elseif &filetype == 'python'
        silent execute ":AsyncRun -strip -raw python3 " . expand("%:p")
        silent execute ":copen"
    endif
endfunction

" 新文件自动填充
autocmd BufNewFile *.sh exec ":call AddNewSh()"
autocmd BufNewFile *.c exec ":call AddNewC()"
autocmd BufNewFile *.cpp,*.cc exec ":call AddNewCPP()"
autocmd BufNewFile *.h,*.hpp exec ":call AddNewHPP()"
autocmd BufNewFile *.go exec ":call AddNewGo()"

function! AddNewSh()
	call append(0, "#!/usr/bin/env bash")
endfunction

function! AddNewC()
	call append(0, "#include <stdio.h>")
	call append(1, "")
	call append(2, "int main()")
	call append(3, "{")
	call append(4, "  ")
	call append(5, "}")
endf

function! AddNewCPP()
  call append(0, "#include <iostream>")
  call append(1, "using namespace std;")
  call append(2, "")
  call append(3, "int main()")
  call append(4, "{")
  call append(5, "  ")
  call append(6, "}")
endf

function! AddNewHPP()
  let fileName = expand("%:r")
  call append(0, "#ifndef ".toupper(fileName)."_H_")
  call append(1, "#define ".toupper(fileName)."_H_")
  call append(2, "")
  call append(3, "")
  call append(4, "#endif /* ".toupper(fileName)."_H_ */")
endf

function! AddNewGo()
  call append(0, "package main")
  call append(1, "")
  call append(2, "import (")
  call append(3, "  \"fmt\"")
  call append(4, ")")
  call append(5, "")
  call append(6, "func main() {")
  call append(7, "  fmt.Println(\"Zzz\")")
  call append(8, "}")
  call append(9, "")
endf

