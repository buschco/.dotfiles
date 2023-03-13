local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'


vim.cmd[[ set diffopt+=vertical ]]
vim.cmd[[ set hidden ]]

require('lazy').setup(
  'plugins',
  {
    ui = {
      icons = {
        cmd = "⌘",
        config = "🛠",
        event = "📅",
        ft = "📂",
        init = "⚙",
        keys = "🗝",
        plugin = "🔌",
        runtime = "💻",
        source = "📄",
        start = "🚀",
        task = "📌",
        lazy = "💤 ",
      },
    },
  }
)

-- Theme
vim.opt.syntax = 'enable'
vim.opt.termguicolors = true
vim.cmd [[colorscheme horizon]]

-- Coc Related options

-- Some servers have issues with backup files, see #649
--vim.opt.backup = false
--vim.opt.writebackup = false

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
vim.opt.tabstop = 2

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

-- = will copy register " to clipcoard 
vim.keymap.set('n', '=', ':let @*=@"<CR>')

-- https://stackoverflow.com/a/42071865/5444033
-- :bda or :Bda force deletes all buffers but not this
vim.cmd [[command! BufOnly silent! execute "%bd|e#|bd!#"]]
vim.cmd.cnoreabbrev({ 'bda', 'BufOnly' })
vim.cmd.cnoreabbrev({ 'Bda', 'BufOnly' })

local filetypeDetect = function()
  vim.cmd(":filetype detect")
  vim.cmd("if getline(1) =~ '// @flow' | setlocal ft=javascriptreact | endif")
end

vim.api.nvim_create_user_command('F', filetypeDetect, {})

-- fix FT for @flow files
vim.api.nvim_create_autocmd({"BufRead"}, {
  pattern = {"*.js"},
  callback = filetypeDetect
})

local createFlowFile = function() 
  vim.api.nvim_put({'// @flow'}, 'c', false, true)
  vim.cmd(':w')
  vim.cmd(':F')
end

vim.api.nvim_create_user_command('FF', createFlowFile, {})

--:command Inshtml :normal i your text here^V<ESC>

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

-- Treesitter

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

-- diffview
require("diffview").setup({ 
  use_icons = false
})

-- Comment
require('Comment').setup()

-- colorizer
require('colorizer').setup({
  filetypes = {
    "javascript",
    "javascriptreact",
    "kotlin",
    "json",
    "yaml",
    "typescript",
    "typescriptreact",
    "markdown",
    "css",
    "html",
    "rust",
    "go",
  },
  user_default_options = { 
    rgb_fn = true,
    tailwind = true
  }
})

-- Treesitter
require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = {
    -- "bash", 
    -- "css",
    -- "dockerfile",
    "gitignore",
    "go",
    -- "html",
    -- "java",
    "javascript",
    "json",
    "kotlin",
    -- "latex",
    "make",
    "markdown",
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
  autotag = {
    enable = true,
    enable_rename = false
  }
};

-- https://www.reddit.com/r/neovim/comments/1144spy/will_treesitter_ever_be_stable_on_big_files/
vim.treesitter.set_query("javascript", "injections", "")
vim.treesitter.set_query("typescript", "injections", "")
vim.treesitter.set_query("tsx", "injections", "")
vim.treesitter.set_query("lua", "injections", "")

require("bufferline").setup {
  options = {
    left_trunc_marker = '…',
    right_trunc_marker = '…',
    mode = 'tabs',
    show_buffer_icons = false,
    truncate_names = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
  }
}

vim.keymap.set('n', 'tt', ":BufferLinePick<CR>", { silent = true, desc = 'pick tab' })

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

local actions = require("telescope.actions")

-- Telescope 
local telescope = require("telescope")
local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

require('telescope').setup {
  pickers = {
    find_files = {
    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
    git_bcommits = {
      mappings = {
        i = {
          ['<CR>'] = function(prompt_bufnr)
            actions.close(prompt_bufnr)
            local value = require('telescope.actions.state').get_selected_entry().value
            local cmd = "DiffviewOpen " .. value
            return pcall(vim.cmd(cmd))
          end,
        }
      }
    }
  },
  defaults = {
    vimgrep_arguments = vimgrep_arguments,
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
      center = { width = 0.7 },
    },
    mappings = {
      i = {
        ['<esc>'] = actions.close,
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<CR>"] = function(prompt_bufnr)
          local picker = require"telescope.actions.state".get_current_picker(prompt_bufnr)
          local multi = picker:get_multi_selection()
          -- vim.cmd("tabnew")
          actions.select_default(prompt_bufnr)
          for _, j in pairs(multi) do
            if j.path ~= nil then
              vim.cmd(string.format("%s %s", "edit", j.path))
            end
          end
        end,
        ["<C-x>"] = function(prompt_bufnr) 
          -- force delete the buffer even if unsaved
          local current_picker = require"telescope.actions.state".get_current_picker(prompt_bufnr)
          current_picker:delete_selection(function(selection)
            local ok = pcall(vim.api.nvim_buf_delete, selection.bufnr, { force = true })
            return ok
          end)
        end
      },
    },
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- telescope bindings
vim.keymap.set('n', '<space>y', ':Telescope registers<CR>') 
vim.cmd.cnoreabbrev({ 'Ag', ":Telescope live_grep" })
vim.cmd.cnoreabbrev({ 'A', ":Telescope live_grep" })
vim.keymap.set('n', '<space>a', function ()
  return require('telescope.builtin').diagnostics({ 
    severity_limit = 2
  })
end
) 
vim.keymap.set('n', '<space>c', 
 function () return ':Telescope live_grep default_text=<' ..  vim.fn.expand '<cword>' .. '<cr>' end,
 {silent = true, desc = 'find files', expr = true }
)

-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

vim.keymap.set('n', '<C-p>', ":Telescope find_files<cr>", { silent = true, desc = 'find files' })
vim.keymap.set('n', '<space>w', require('telescope.builtin').grep_string, { desc = 'find word' })
vim.keymap.set('n', '<space>b', require('telescope.builtin').buffers, { desc = 'list buffers' })
vim.keymap.set('n', '<space>g', require('telescope.builtin').git_bcommits, 
  { desc = 'git history for current file' }
)

-- LSP

require("lsp-format").setup({})

local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
  require "lsp_signature".on_attach({
    bind = true,
    hint_prefix = "",
    handler_opts = { border = "none" },
  }, bufnr)

  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
      
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>aw', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('<space>s', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  nmap('[g', function() vim.diagnostic.goto_prev({ 
      severity = { min = vim.diagnostic.severity["WARN"] }
  }) end, 'prev error')

  nmap(']g', function() vim.diagnostic.goto_next({ 
      severity = { min = vim.diagnostic.severity["WARN"] }
  }) end, 'next error')

end

local on_attach_with_format = function(client, bufnr)
  require("lsp-format").on_attach(client)
  on_attach()
end

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    --null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint_d,
    --null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.diagnostics.cspell.with({
      extra_args = { "--config", vim.fn.expand("~/.cspell.json") },
      diagnostics_postprocess = function(diagnostic) diagnostic.severity = vim.diagnostic.severity["HINT"] end,
    }),
    null_ls.builtins.code_actions.cspell,
    null_ls.builtins.formatting.prettierd
  },
  on_attach = on_attach_with_format 
})

lspconfig.flow.setup{
  cmd = { 'yarn', 'flow', 'lsp' },
  on_attach = on_attach,
}

local configs = require('lspconfig.configs')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

if not configs.fiona then
  configs.fiona = {
    default_config = {
      cmd = { 'yarn', 'fiona-lsp', '--stdio' },
      root_dir = lspconfig.util.find_package_json_ancestor,
      filetypes = { 'javascriptreact' },
    },
  }
end

lspconfig.fiona.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.tailwindcss.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "html", "javascript", "javascriptreact", "typescript", "typescript.tsx", "typescriptreact" }
}

lspconfig.eslint.setup{
  on_attach = function(client, bufnr)
    on_attach(client, bufmr)
    -- use this if eslint_d (provided by null-ls) is not used 
    vim.api.nvim_create_autocmd({"BufWritePre"}, {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  capabilities = capabilities,
  settings = { packageManager = "yarn", },
}

lspconfig.gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.jsonls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    json = {
      schemas = {
        {
          description = 'TypeScript compiler configuration file',
          fileMatch = {'tsconfig.json', 'tsconfig.*.json'},
          url = 'http://json.schemastore.org/tsconfig'
        },
        {
          description = 'Babel configuration',
          fileMatch = {'.babelrc.json', '.babelrc', 'babel.config.json'},
          url = 'http://json.schemastore.org/lerna'
        },
        {
          description = 'ESLint config',
          fileMatch = {'.eslintrc.json', '.eslintrc'},
          url = 'http://json.schemastore.org/eslintrc'
        },
        {
          description = 'Prettier config',
          fileMatch = {'.prettierrc', '.prettierrc.json', 'prettier.config.json'},
          url = 'http://json.schemastore.org/prettierrc'
        },
        {
          description = 'node based packgage.json',
          fileMatch = {'package.json'},
          url = 'https://json.schemastore.org/package.json'
        }
      }
    },
  }
}

lspconfig.yamlls.setup {
  capabilities = capabilities,
  on_attach = on_attach_with_format,
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "/.gitlab-ci.yml"
      },
    },
  }
}

lspconfig.tsserver.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {
    'typescript', 
    'typescript.tsx',
    --'javascriptreact',
  }
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
  float = {source = true, header = false }
})

local luasnip = require('luasnip')

-- remove snippet linking after leaving snippet insert
vim.api.nvim_create_autocmd({"InsertLeave"}, {
  pattern = {"*"},
  command = ":LuaSnipUnlinkCurrent"
})

local t = luasnip.text_node
local f = luasnip.function_node
local i = luasnip.insert_node
local s = luasnip.snippet
local function copy(args)
  return args[1]
end

-- TODO typescript
luasnip.add_snippets("javascriptreact", {
-- const get${1}: Selector<${2}> = createFSelector(
--     'get${1}',
--     [],
--     () => {
--       return { };
--     }
-- );
  s("selector", {
    t("const get"), 
    f(copy, 1), 
    t(": Selector<number> = createFSelector('get"),
    i(1),
    t({"',","[],","() => {","return { }","}",");"})
  }),
-- function ${1} ():ThunkAction {
-- 	return (dispatch, getState) => {
-- 		
-- 	}
-- }
  s("action", {
    t("function "), 
    i(1),
    t({
      " ():ThunkAction {",
      "return (dispatch, getState) => {",
      "",
      "}",
      "}"
    })
  }),
-- console.log('cbu', ${1})
  s("conso", {
    t("console.log('cbu',"), 
    i(1),
    t(")")
  }),

-- import * as React from 'react';
--
-- function ${1}(): React.Node {
--   return <></>;
-- }
--
-- export default ${1};
  s("fcomp", {
    t({
      "import * as React from 'react';",
      "", "function "
    }),
    i(1),
    t({
      "(): React.Node {",
      "return <></>;",
      "}",
      "export default "
    }),
    f(copy, 1), 
  })
})

local cmp = require('cmp')
local compare = cmp.config.compare

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
      vim_item.kind = '■'
      vim_item.menu = '' 
      return vim_item
    end
  },
  sorting = {
    comparators = {
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    }
  },
  preselect = cmp.PreselectMode.None,
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'luasnip' },
  },
}

