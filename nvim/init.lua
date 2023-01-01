require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Theme
  -- use 'buschco/vim-horizon'
  use '~/Documents/code.nosync/vim-horizon'

  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-repeat'
  use 'unblevable/quick-scope'
  use 'norcalli/nvim-colorizer.lua'

  use 'jose-elias-alvarez/null-ls.nvim'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  use {
    'windwp/nvim-ts-autotag',
    after = 'nvim-treesitter',
  }

  use 'tpope/vim-fugitive'
  use 'lewis6991/gitsigns.nvim'

  use 'nvim-lualine/lualine.nvim'
  use 'numToStr/Comment.nvim'

  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }


  use { 'neoclide/coc.nvim', branch = 'release' }
  use {
    'https://build.dwins.de/fiona/fiona.git', 
    rtp = 'packages/coc', 
    run = 'yarn install --frozen-lockfile && yarn workspace @fiona/coc package',
    branch = 'main' 
  }

  use {
    'nvim-telescope/telescope-fzf-native.nvim', 
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }
end)

-- Theme
vim.opt.syntax = 'enable'
vim.opt.termguicolors = true
vim.cmd [[colorscheme horizon]]

-- Coc Related options

-- Some servers have issues with backup files, see #649
vim.opt.backup = false
vim.opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 300

-- always signcolumn
vim.opt.signcolumn = 'yes'

-- relative numbers
vim.opt.relativenumber = true 

-- show current line number
vim.opt.number = true

vim.opt.scrolloff = 20

-- ensures that P behaves the same at the end of a line
vim.opt.virtualedit = 'onemore'

-- intend fix
vim.opt.expandtab = true 
vim.opt.shiftwidth = 2

-- remove --- INSERT ---
vim.opt.laststatus = 2
vim.opt.ruler = false
vim.opt.cmdheight = 0

-- / search case improve
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- netrw remove banner
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 3
vim.g.netrw_winsize  = 30
vim.g.netrw_hide  = 0
vim.g.netrw_browse_split = 3

-- folding related
vim.cmd [[set foldopen-=block]]
vim.opt.foldlevel = 1

-- fix fold on safe
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = 'indent'
-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- {} will jump over folds
vim.opt.foldmethod = 'indent'

-- Stamp _ register into word over cursor
vim.keymap.set('n', 'S', '"_diwP')

-- = will yank word into the clipcoard
-- nnoremap = 
vim.keymap.set('n', '=', '"+yiw')

-- = will yank motion into the clipcoard
vim.keymap.set('n', '+', '"+y')
vim.keymap.set('n', '+', '"+y')

-- https://stackoverflow.com/a/42071865/5444033
-- :bda or :Bda close all buffers but not this
vim.cmd [[command! BufOnly silent! execute "%bd|e#|bd#"]]
vim.cmd.cnoreabbrev({ 'bda', 'BufOnly' })
vim.cmd.cnoreabbrev({ 'Bda', 'BufOnly' })

-- :Bd behaves like :bd
vim.cmd.cnoreabbrev({ 'Bd', 'bd' })

-- :W behaves like :w
vim.cmd.cnoreabbrev({ 'W', 'w' })

-- :Wq behaves like :wq
vim.cmd.cnoreabbrev({ 'Wq', 'wq' })

-- :o behaves like :i
vim.keymap.set('n', 'o', 'i')

-- :O behaves like :I
vim.keymap.set('n', 'O', 'I')

-- Use ctrl-[hjkl] to select the active split!
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>', { silent = true })
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>', { silent = true })
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>', { silent = true })
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>', { silent = true })

-- open registers on space y 
vim.keymap.set('n', '<space>y', ':registers<CR>') 

-- Treesitter

-- fix FT for @flow files
vim.api.nvim_create_autocmd({"BufRead"}, {
  pattern = {"*.js"},
  command = "if getline(1) =~ '// @flow' | setlocal ft=javascriptreact | endif",
})

vim.api.nvim_create_autocmd({"BufNewFile","BufRead"}, {
  pattern = {"*.tsx"},
  command = "set filetype=typescript.tsx"
})

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local ft_to_parser = require"nvim-treesitter.parsers".filetype_to_parsername
ft_to_parser.javascriptreact = "tsx"

-- Comment
require('Comment').setup()

-- colorizer
require('colorizer').setup()

-- Treesitter
require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = {
    --  "bash", 
    -- "css",
    -- "dockerfile",
    -- "gitingore",
    -- "go",
    -- "html",
    -- "java",
    "javascript",
    "json",
    -- "kotlin",
    -- "latex",
    -- "make",
    -- "markdown",
    -- "prisma",
    "lua",
    "tsx",
    "typescript"
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "txt", "help" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  autotag = { enable = true }
};

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'horizon',
    component_separators = '|',
    section_separators = '',
  },
   sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', "vim.fn.reg_recording()" },
    lualine_x = {"require'lsp-status'.status()", 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
   local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})
  end
}

-- Telescope 
require('telescope').setup {
  defaults = {
    preview = {
      treesitter = true,
      title = false,
    },
    results_title = false,
    prompt_title = false,
    layout_strategy = 'center',
    layout_config = {
      anchor = 'N',
      prompt_position = 'bottom',
      vertical = { width = 0.7 },
    },
    mappings = {
      i = {
        ['<esc>'] = require("telescope.actions").close,
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- telescope bindings
vim.cmd.cnoreabbrev({ 'Ag', ":Telescope live_grep" })
vim.cmd.cnoreabbrev({ 'A', ":Telescope live_grep" })
vim.keymap.set('n', '<space>c', 
 function () return ':Telescope live_grep default_text=<' ..  vim.fn.expand '<cword>' .. '<cr>' end,
 {silent = true, desc = 'find files', expr = true }
)

local telescope = require("telescope")
local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup({
  defaults = {
    -- `hidden = true` is not supported in text grep commands.
      vimgrep_arguments = vimgrep_arguments,
    },
    pickers = {
      find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },
})

vim.keymap.set('n', '<C-p>', ":Telescope find_files<cr>", { silent = true, desc = 'find files' })
vim.keymap.set('n', '<space>w', require('telescope.builtin').grep_string, { desc = 'find word' })
vim.keymap.set('n', '<space>b', require('telescope.builtin').buffers, { desc = 'list buffers' })
vim.keymap.set('n', '<space>a', function()
  require('telescope.builtin').diagnostics({
    severity_limit = vim.diagnostic.severity["WARN"]
  })
end, { desc = 'list buffers' })

-- coc keymaps

-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end
-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
vim.keymap.set("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use <c-j> to trigger snippets
vim.keymap.set("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use <c-space> to trigger completion
vim.keymap.set("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

-- GoTo code navigation
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", {silent = true})
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", {silent = true})
vim.keymap.set("n", "gr", "<Plug>(coc-references)", {silent = true})


-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
vim.keymap.set("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})


-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})


-- Symbol renaming
vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})


-- Formatting selected code
vim.keymap.set("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
vim.keymap.set("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})


-- Setup formatexpr specified filetype(s)
vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
})

-- Update signature help on jump placeholder
vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
})

-- Apply codeAction to the selected region
-- Example: `<leader>aap` for current paragraph
local opts = {silent = true, nowait = true}
vim.keymap.set("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
vim.keymap.set("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

-- Remap keys for apply code actions at the cursor position.
vim.keymap.set("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
-- Remap keys for apply code actions affect whole buffer.
vim.keymap.set("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
-- Remap keys for applying codeActions to the current buffer
vim.keymap.set("n", "<leader>ac", "<Plug>(coc-codeaction)", opts)
-- Apply the most preferred quickfix action on the current line.
vim.keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

-- Remap keys for apply refactor code actions.
vim.keymap.set("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
vim.keymap.set("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
vim.keymap.set("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

-- Run the Code Lens actions on the current line
vim.keymap.set("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)


-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server
vim.keymap.set("x", "if", "<Plug>(coc-funcobj-i)", opts)
vim.keymap.set("o", "if", "<Plug>(coc-funcobj-i)", opts)
vim.keymap.set("x", "af", "<Plug>(coc-funcobj-a)", opts)
vim.keymap.set("o", "af", "<Plug>(coc-funcobj-a)", opts)
vim.keymap.set("x", "ic", "<Plug>(coc-classobj-i)", opts)
vim.keymap.set("o", "ic", "<Plug>(coc-classobj-i)", opts)
vim.keymap.set("x", "ac", "<Plug>(coc-classobj-a)", opts)
vim.keymap.set("o", "ac", "<Plug>(coc-classobj-a)", opts)


-- Remap <C-f> and <C-b> to scroll float windows/popups
---@diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true, expr = true}
vim.keymap.set("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
vim.keymap.set("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
vim.keymap.set("i", "<C-f>",
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
vim.keymap.set("i", "<C-b>",
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
vim.keymap.set("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
vim.keymap.set("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)


-- Use CTRL-S for selections ranges
-- Requires 'textDocument/selectionRange' support of language server
vim.keymap.set("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
vim.keymap.set("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})


-- Add `:Format` command to format current buffer
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

-- " Add `:Fold` command to fold current buffer
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

-- Add `:OR` command for organize imports of the current buffer
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

-- Add (Neo)Vim's native statusline support
-- NOTE: Please see `:h coc-status` for integrations with external plugins that
-- provide custom statusline: lightline.vim, vim-airline
vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

-- Mappings for CoCList
-- code actions and coc stuff
---@diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true}
-- Show all diagnostics
vim.keymap.set("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
-- Manage extensions
vim.keymap.set("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
-- Show commands
vim.keymap.set("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
-- Find symbol of current document
vim.keymap.set("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
-- Search workspace symbols
vim.keymap.set("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
-- Do default action for next item
vim.keymap.set("n", "<space>j", ":<C-u>CocNext<cr>", opts)
-- Do default action for previous item
vim.keymap.set("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
-- Resume latest coc list
vim.keymap.set("n", "<space>p", ":<C-u>CocListResume<cr>", opts)

