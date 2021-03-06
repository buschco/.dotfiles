call plug#begin("~/.vim/plugged")
  " Plugin Section
  Plug 'tpope/vim-surround'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'haya14busa/incsearch.vim'
  Plug 'haya14busa/incsearch-fuzzy.vim'
  Plug 'airblade/vim-gitgutter'	
  Plug 'buschco/vim-horizon'
  Plug 'yuezk/vim-js'
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'leafgarland/typescript-vim'
  Plug 'maxmellon/vim-jsx-pretty' 
  Plug 'tpope/vim-fugitive'
  Plug 'AndrewRadev/linediff.vim'
  Plug 'unblevable/quick-scope'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-repeat'
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/limelight.vim'
  Plug 'lervag/vimtex'
  Plug 'udalov/kotlin-vim'
  Plug 'itchyny/lightline.vim'
  Plug 'wincent/terminus'
  Plug 'vuciv/vim-bujo'
call plug#end()

" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx

" :W behaves like :w
cnoreabbrev W w

" :o behaves like :i
nnoremap o i

" :O behaves like :I
nnoremap O I

" ensures that P behaves the same at the end of a line
set virtualedit=onemore

" Stamp _ register into word over cursor
nnoremap S "_diwP

" = will yank word into the clipcoard
nnoremap = "+yiw

" = will yank motion into the clipcoard
nnoremap + "+y

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" open registers on space y 
nnoremap <silent> <space>y  :registers<cr>

" smartcase for /
:set ignorecase
:set smartcase

" fold syntax
" :set foldmethod=manual
:set foldmethod=indent
" {} will jump over folds
:set foldopen-=block
" idk what this does :D 
:set foldlevel=1

" open netrw files in new tab
let g:netrw_browse_split = 3

" remove warning at start
let g:tex_flavor = 'latex'

" fix fold on safe
:set foldlevelstart=99
" not folded on open https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
au BufRead * normal zR

" intend fix
set expandtab
set shiftwidth=2

syntax enable
set termguicolors
colorscheme horizon

" remove --- INSERT ---
set noshowmode
set nosmd   " short for 'showmode'
set noru    " short for 'ruler'
set laststatus=2
set noshowcmd
set cmdheight=1

"show numbers relative
set relativenumber
set nu rnu

" EXPERIMENTAL
set scrolloff=20

" Distplay changes (gitgutter)
function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction
set statusline+=%{GitStatus()}
set signcolumn=yes


function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" statusline
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" lightline
let g:lightline = {
  \ 'colorscheme': 'horizon',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'cocstatus', 'readonly', 'filename', 'modified' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'syntaxItem' ] ]
  \ },
  \ 'component_function': {
  \   'cocstatus': 'coc#status',
  \   'syntaxItem': 'SyntaxItem',
  \   'gitbranch': 'FugitiveHead'
  \ }
\}


" distraction free mode
function! s:goyo_enter()
  set noshowmode
  Limelight
endfunction

function! s:goyo_leave()
  set showmode
  Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" incsearch fzf
function! s:config_fuzzyall(...) abort
  return extend(copy({
  \   'converters': [
  \     incsearch#config#fuzzy#converter()
  \   ],
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> z/ incsearch#go(<SID>config_fuzzyall())
noremap <silent><expr> z? incsearch#go(<SID>config_fuzzyall({'command': '?'}))
noremap <silent><expr> zg? incsearch#go(<SID>config_fuzzyall({'is_stay': 1}))

command! -nargs=* Ag call fzf#vim#ag
            \ (<q-args>,
            \ '--hidden --path-to-ignore ~/.ignore --ignore .git',
            \ fzf#vim#with_preview
            \ ({'options': '--delimiter : --nth 4..'}), <bang>0)

" command! -bang -nargs=* Ag call fzf#vim#ag
"      \ ('--hidden --path-to-ignore ~/.ignore --ignore .git', 
"      \ fzf#vim#with_preview
"      \ ({'options': '--delimiter : --nth 4..'}), <bang>0)
"

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction


" fzf keymaps
nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

" map ag to search current word under cursor
" nmap <silent> ag :Ag <C-R>=expand("<cword>")<CR><CR>
nmap <silent> <space>w :Ag <C-R>=expand("<cword>")<CR><CR>
nmap <silent> <space>c :Ag <C-R>="<lt>" . expand("<cword>")<CR><CR>
":Ag <C-R>='<lt>expand("<cword>")<CR><CR>
"<lt>" expand("<cword>")<CR><CR>

" vim-javascript
let g:javascript_plugin_flow = 0

" CocPrettier
"command! -nargs=0 Prettier :CocCommand prettier.formatFile
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

" Coc
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
" set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]g <Plug>(coc-diagnostic-next-error)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

