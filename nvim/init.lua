-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- Theme
  use 'buschco/vim-horizon'

  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-repeat'
  use 'unblevable/quick-scope'

  use { 'neovim/nvim-lspconfig', requires = { 'j-hui/fidget.nvim', 'folke/neodev.nvim', } }
  use 'jose-elias-alvarez/null-ls.nvim'

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'lewis6991/gitsigns.nvim'

  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- Theme
vim.opt.syntax = 'enable'
vim.opt.termguicolors = true
vim.cmd [[colorscheme horizon]]

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

local ft_to_parser = require"nvim-treesitter.parsers".filetype_to_parsername
ft_to_parser.javascriptreact = "tsx"

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
  }
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
-- See `:help gitsigns.txt`
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
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
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
require('Comment').setup()

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.diagnostics.cspell.with({
      extra_args = { "--config", vim.fn.expand("~/.cspell.json") },
      diagnostics_postprocess = function(diagnostic) diagnostic.severity = vim.diagnostic.severity["HINT"] end,
    }),
    -- null_ls.builtins.code_actions.cspell,
    null_ls.builtins.formatting.prettier
  },
  on_attach = function(client, bufnr)
    if client.supports_method 'textDocument/formatting' then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
      })
    end
  end,
})

-- lsp setup

local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
end

local lspconfig = require('lspconfig')

lspconfig.flow.setup{
  cmd = { 'yarn', 'flow', 'lsp' },
  on_attach = on_attach,
}

local configs = require('lspconfig.configs')

if not configs.fiona then
  configs.fiona = {
    default_config = {
      cmd = { 'yarn', 'fiona-lsp', '--stdio' },
      root_dir = lspconfig.util.find_package_json_ancestor,
      filetypes = { 'javascriptreact' },
    },
  }
end

lspconfig.fiona.setup{}

lspconfig.tsserver.setup{
  on_attach = on_attach,
  filetypes = { 'typescript', 'typescript.tsx' }
}

vim.diagnostic.config({
  virtual_text = false,
  signs = { 
    severity = {
      min = vim.diagnostic.severity["WARN"]
    }
  },
  underline = true,
  update_in_insert = false,
  severity_sort = false,
  -- disables `Diagnostig:\n` header in float preview
  float = { header = false }
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- lsp bindings
vim.keymap.set('n', '[g', function() vim.diagnostic.goto_prev({ 
    severity = {
      min = vim.diagnostic.severity["WARN"]
    }
}) end)
vim.keymap.set('n', ']g', function() vim.diagnostic.goto_next({ 
    severity = {
      min = vim.diagnostic.severity["WARN"]
    }
}) end)
vim.keymap.set('n', '<C-k>', vim.diagnostic.open_float)
