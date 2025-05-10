---@diagnostic disable: undefined-global

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

local max_filesize = 200 * 1024 -- 200 KB

-- sync clipboards
vim.cmd([[set clipboard=unnamed ]])

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

vim.cmd([[ set diffopt+=vertical ]])
vim.cmd([[ set hidden ]])

require("lazy").setup("plugins", {
  lazy = true,
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
})

local find_git_dir_job = vim.fn.jobstart({ "git", "rev-parse", "--git-dir" })
local find_git_dir_exit_code = vim.fn.jobwait({ find_git_dir_job })[1]

local is_dotfiles = find_git_dir_exit_code > 0 and vim.fn.getcwd() == "/Users/colin"

-- Theme
vim.opt.termguicolors = true
vim.cmd([[colorscheme horizon]])

-- Coc Related options

-- Some servers have issues with backup files, see #649
-- vim.opt.backup = false
-- vim.opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 300

-- always signcolumn
vim.opt.signcolumn = "yes"

-- relative numbers
vim.opt.relativenumber = true

-- show current line number
vim.opt.number = true

vim.opt.scrolloff = 20

-- ensures that P behaves the same at the end of a line
vim.opt.virtualedit = "onemore"

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
vim.g.netrw_winsize = 30
vim.g.netrw_hide = 0
vim.g.netrw_browse_split = 3

-- folding related
vim.cmd([[set foldopen-=block]])
vim.opt.foldlevel = 1

-- fix fold on safe
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "indent"
-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- {} will jump over folds
vim.opt.foldmethod = "indent"

-- Stamp _ register into word over cursor
vim.keymap.set("n", "S", '"_diwP')

vim.keymap.set({ "n", "v" }, "<space>r", ":%s/<C-r><C-w>//gI<left><left><left>")
vim.keymap.set({ "n", "v" }, "<space>e", ":s///gI<left><left><left>")
vim.keymap.set({ "n", "v" }, "<space>t", ":%s/\\(.*\\)//gI<left><left><left>")

-- = will copy register " to clipcoard
-- nowait because vim-unimpaired binds some =
-- https://github.com/tpope/vim-unimpaired/blob/master/plugin/unimpaired.vim#L441-L442
vim.cmd([[ nmap <nowait> = :let @*=@"<CR>]])

-- https://stackoverflow.com/a/42071865/5444033
-- :bda or :Bda force deletes all buffers but not this
vim.cmd([[command! BufOnly silent! execute "%bd|e#|bd!#"]])
vim.cmd.cnoreabbrev({ "bda", "BufOnly" })
vim.cmd.cnoreabbrev({ "Bda", "BufOnly" })

--:command Inshtml :normal i your text here^V<ESC>

-- :Bd behaves like :bd
vim.cmd.cnoreabbrev({ "Bd", "bd" })

-- :W behaves like :w
vim.cmd.cnoreabbrev({ "W", "w" })

-- :Wq behaves like :wq
vim.cmd.cnoreabbrev({ "Wq", "wq" })

-- :o behaves like :i
vim.keymap.set("n", "o", "i")

-- :O behaves like :I
vim.keymap.set("n", "O", "I")

-- Use ctrl-[hjkl] to select the active split!
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>", { silent = true })
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>", { silent = true })
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>", { silent = true })
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>", { silent = true })

local fillFlowFile = function()
  local name = vim.fn.expand("%:t:r")
  vim.api.nvim_put({
    "// @flow",
    "import * as React from 'react';",
    "",
    "function " .. name .. "(): React.Node {",
    "  return <></>;",
    "}",
    "",
    "export default " .. name,
  }, "c", false, true)
  vim.cmd(":w")
end

local fillTsxFile = function()
  local name = vim.fn.expand("%:t:r")
  vim.api.nvim_put({
    "import { ReactNode } from 'react';",
    "",
    "function " .. name .. "(): ReactNode {",
    "  return <></>;",
    "}",
    "",
    "export default " .. name,
  }, "c", false, true)
  vim.cmd(":w")
end

local createAndFillFlowFile = function()
  local name = vim.fn.expand("<cword>")
  vim.cmd("e %:h/" .. name .. ".js")
  fillFlowFile()
  vim.cmd(":filetype detect")
end

local createAndFillTsxFile = function()
  local name = vim.fn.expand("<cword>")
  vim.cmd("e %:h/" .. name .. ".tsx")
  fillTsxFile()
  vim.cmd(":filetype detect")
end

local addPage = function()
  local file_path = vim.fn.getreg('%')
  os.execute('./bin/create-page.mjs ' .. file_path)
end

vim.api.nvim_create_user_command("CF", createAndFillFlowFile, {})
vim.api.nvim_create_user_command("CT", createAndFillTsxFile, {})
vim.api.nvim_create_user_command("Page", addPage, {})

-- Treesitter

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "Fastfile", "Appfile", "Matchfile", "Pluginfile" },
  callback = function()
    vim.o.filetype = "ruby"
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.plist" },
  callback = function()
    vim.o.filetype = "xml"
  end,
})

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.api.nvim_set_hl(0, "shorthand_property_identifier_pattern", { link = "Identifier" })

vim.filetype.add({
  pattern = {
    [".*.js"] = {
      priority = math.huge,
      function(path, bufnr)
        local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
        if content:find("// @flow") ~= nil then
          return "javascriptreact"
        else
          return "javascript"
        end
      end,
    },
  },
})

--local ft_to_parser = require"nvim-treesitter.parsers".filetype_to_parsername
--ft_to_parser.javascriptreact = "tsx"
vim.treesitter.language.register("tsx", "javascriptreact")
vim.treesitter.language.register("tsx", "flow")

-- colorizer
require("colorizer").setup({
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
    hsl_fn = true,
    rgb_fn = true,
    tailwind = true,
  },
})

-- Treesitter
require("nvim-treesitter.configs").setup({
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
    "typescript",
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { },

  highlight = {
    custom_captures = { ["shorthand_property_identifier_pattern"] = "@property" },
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
    -- disable slow treesitter highlight for large files
    disable = function(lang, buf)
      if lang == "txt" or lang == "help" then
        return true
      end
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },

  textobjects = {
    move = {
      enable = true,
      set_jumps = true,
      goto_previous_start = {
        ["[["] = {
          query = "@function.inner",
          desc = "jump to start of function body",
        },
      },
      goto_next_end = {
        ["]]"] = {
          query = "@function.inner",
          desc = "jump to start of function body",
        },
      },
    },
  },
})

-- https://www.reddit.com/r/neovim/comments/1144spy/will_treesitter_ever_be_stable_on_big_files/
vim.treesitter.query.set("javascript", "injections", "")
vim.treesitter.query.set("typescript", "injections", "")
vim.treesitter.query.set("tsx", "injections", "")
vim.treesitter.query.set("lua", "injections", "")

local path = require("plenary").path

function ends_with(str, ending)
  return str:sub(- #ending) == ending
end

function nice_filename(input)
  local cwd = vim.fn.getcwd()
  local full = path.new(input):normalize(cwd)

  if ends_with(full, "/index.js") then
    full = full:gsub("index.js", "")
  elseif ends_with(full, "/index.tsx") then
    full = full:gsub("index.tsx", "")
  elseif ends_with(full, "/index.ts") then
    full = full:gsub("index.ts", "")
  end

  local iter = full:reverse():gmatch("([^/]+)")

  return iter():reverse()
end

function search_result()
  local function dump(o)
    if type(o) == 'table' then
      local s = '{ '
      for k, v in pairs(o) do
        if type(k) ~= 'number' then k = '"' .. k .. '"' end
        s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
      end
      return s .. '} '
    else
      return tostring(o)
    end
  end


  if vim.v.hlsearch == 0 then
    return ''
  end
  local last_search = vim.fn.getreg('/')
  if not last_search or last_search == '' then
    return ''
  end
  local searchcount = vim.fn.searchcount { maxcount = 9999 }
  print(dump(searchcount))
  -- return last_search .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
end

vim.api.nvim_create_user_command("Sctest", search_result, {})

require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = "horizon",
    component_separators = "|",
    section_separators = "",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 4 }, "vim.fn.reg_recording()", "searchcount" },
    --lualine_c = { "filename", "vim.fn.reg_recording()" },
    lualine_x = { "require'lsp-status'.status()", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

local gs = require("gitsigns")

-- Gitsigns
gs.setup({
  worktrees = {
    {
      toplevel = vim.env.HOME,
      gitdir = vim.env.HOME .. "/github.com.nosync/dotfiles",
    },
  },
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })
  end,
})

local actions = require("telescope.actions")

-- Telescope
local telescopeConfig = require("telescope.config")

-- handle unpack deprecation
---@diagnostic disable-next-line: deprecated
table.unpack = table.unpack or unpack

-- Clone the default Telescope configuration
local vimgrep_arguments = {
  table.unpack(telescopeConfig.values.vimgrep_arguments)
}

local closeBuffFromPicker = function(prompt_bufnr)
  -- force delete the buffer even if unsaved
  local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  current_picker:delete_selection(function(selection)
    local ok = pcall(vim.api.nvim_buf_delete, selection.bufnr, { force = true })
    return ok
  end)
end

require("telescope").setup({
  pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = {
        "rg",
        "--files",
        "--hidden",
        "--glob", "!**/.git/*",
        "--ignore-file=./.vim/ignore"
      },
    },
    marks = {
      attach_mappings = function(prompt_bufnr, map)
        map({ "i", "n" }, "<C-x>", function()
          actions.delete_mark(prompt_bufnr)
        end)
        return true
      end,
    },
    git_bcommits = {
      mappings = {
        i = {
          ["<CR>"] = function(prompt_bufnr)
            actions.close(prompt_bufnr)
            local value = require("telescope.actions.state").get_selected_entry().value
            local cmd = "DiffviewOpen " .. value
            return pcall(vim.cmd(cmd))
          end,
        },
      },
    },
    buffers = {
      attach_mappings = function(promt_bufnr, map)
        map({ "i", "n" }, "<C-x>", function()
          closeBuffFromPicker(promt_bufnr)
        end
        )
        return true
      end
    }
  },
  defaults = {
    git_worktrees = {
      {
        toplevel = vim.env.HOME,
        gitdir = vim.env.HOME .. "/github.com.nosync/dotfiles",
      },
    },
    vimgrep_arguments = vimgrep_arguments,
    preview = {
      treesitter = true,
      title = false,
    },
    results_title = false,
    prompt_title = false,
    layout_strategy = "center",
    layout_config = {
      anchor = "S",
      center = { height = 0.4 },
      prompt_position = "bottom",
      height = 1,
      width = 1000,
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-u>"] = false,
        ["<C-x>"] = false,
        ["<C-d>"] = false,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<CR>"] = function(prompt_bufnr)
          local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
          local multi = picker:get_multi_selection()
          -- vim.cmd("tabnew")
          actions.select_default(prompt_bufnr)
          for _, j in pairs(multi) do
            if j.path ~= nil then
              vim.cmd(string.format("%s %s", "edit", j.path))
            end
          end
        end,
      },
    },
  },
})

require("telescope").load_extension("fzf")

-- telescope bindings
vim.keymap.set("n", "<space>y", ":Telescope registers<CR>")
vim.keymap.set("n", "<space>m", ":Telescope marks<CR>")
vim.cmd.cnoreabbrev({ "Ag", ":Telescope live_grep" })
vim.cmd.cnoreabbrev({ "A", ":Telescope live_grep" })
vim.keymap.set("n", "<space>a", function()
  return require("telescope.builtin").diagnostics({
    severity_limit = 2,
  })
end)
vim.keymap.set("n", "<space>c", function()
  return ":Telescope live_grep default_text=<" .. vim.fn.expand("<cword>") .. "<cr>"
end, { silent = true, desc = "find files", expr = true })

-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
table.insert(vimgrep_arguments, "-F")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")
table.insert(vimgrep_arguments, "--ignore-file=./.vim/ignore")

if is_dotfiles then
  -- no git dir in curren path
  vim.env.GIT_DIR = vim.fn.expand("~/github.com.nosync/dotfiles")
  vim.env.GIT_WORK_TREE = vim.fn.expand("~")
  vim.keymap.set("n", "<C-p>", ":Telescope git_files<cr>", { silent = true, desc = "find files" })
else
  vim.keymap.set("n", "<C-p>", ":Telescope find_files<cr>", { silent = true, desc = "find files" })
end

vim.keymap.set("n", "<space>w", require("telescope.builtin").grep_string, { desc = "find word" })
vim.keymap.set("n", "<space>b", require("telescope.builtin").buffers, { desc = "list buffers" })
vim.keymap.set("n", "<space>f", require("telescope.builtin").git_status, { desc = "git status" })
vim.keymap.set("n", "<space>g", require("telescope.builtin").git_bcommits, { desc = "git history for current file" })

-- LSP

local lspconfig = require("lspconfig")

local handler_without_border = function(handler)
  return function(err, result, ctx, config)
    local buf, win = handler(
      err,
      result,
      ctx,
      vim.tbl_deep_extend('force', config or {}, {
        border = { "", "", "", "", "", "", "", "" },
        max_height = vim.o.lines,
        max_width = vim.o.columns,
      })
    )
  end
end


local methods = vim.lsp.protocol.Methods
vim.lsp.handlers[methods.textDocument_hover] =
    handler_without_border(vim.lsp.handlers.hover)
vim.lsp.handlers[methods.textDocument_signatureHelp] =
    handler_without_border(vim.lsp.handlers.signature_help)


local function getWorkspaceEdit(client, old_name, new_name)
  local will_rename_params = {
    files = {
      {
        oldUri = vim.uri_from_fname(old_name),
        newUri = vim.uri_from_fname(new_name),
      },
    },
  }
  local success, resp = pcall(
    client.request_sync,
    "workspace/willRenameFiles",
    will_rename_params,
    10000
  )
  if not success then
    print("no success")
    return nil
  end
  if resp == nil or resp.result == nil then
    print("no response")
    return nil
  end
  return resp.result
end

local on_attach = function(client, bufnr)
  -- disable lsp highlighing
  -- https://www.reddit.com/r/neovim/comments/109vgtl/how_to_disable_highlight_from_lsp/
  if client ~= nil then
    client.server_capabilities.semanticTokensProvider = nil
  end

  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  if false and client.server_capabilities ~= nil and
      client.server_capabilities.workspace ~= nil and
      client.server_capabilities.workspace.fileOperations ~= nil then
    local moveFile = function()
      local file_path = vim.fn.getreg('%')
      vim.ui.input({
        prompt = 'Move file: ',
        default = file_path,
        completion = "dir",
      }, function(next_file_path)
        local edit = getWorkspaceEdit(client, file_path, next_file_path)
        if edit ~= nil then
          vim.lsp.util.apply_workspace_edit(edit, client.offset_encoding)
        end
      end)
    end

    nmap("<leader>mf", moveFile, "[M]ve [F]ile")
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap("<leader>aw", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("<space>s", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  nmap("[g", function()
    vim.diagnostic.goto_prev({
      severity = { min = vim.diagnostic.severity["WARN"] },
    })
  end, "prev error")

  nmap("]g", function()
    vim.diagnostic.goto_next({
      severity = { min = vim.diagnostic.severity["WARN"] },
    })
  end, "next error")

  -- avoid warning for lua_ls
  if client ~= nil then
    if client.server_capabilities ~= nil then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end
end

local lsp_format = require("lsp-format")
lsp_format.setup({})

local on_attach_with_format = function(client, bufnr)
  lsp_format.on_attach(client)
  on_attach()
end

local formatter_util = require("formatter.util")
require("conform").setup({
  formatters_by_ft = {
    javascriptreact = { "prettier", stop_after_first = true },
    typescript = { "prettier", "prettier", stop_after_first = true },
    typescriptreact = { "prettier", "prettier", stop_after_first = true },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

require("formatter").setup({
  filetype = {
    css = { require("formatter.filetypes.css").prettierd },
    html = { require("formatter.filetypes.html").prettierd },
    xml = { require("formatter.filetypes.xml").tidy },
    svg = { require("formatter.filetypes.xml").tidy },
    javascript = { require("formatter.filetypes.javascript").prettier },
    -- javascriptreact = { require("formatter.filetypes.javascriptreact").prettierd },
    json = { require("formatter.filetypes.json").prettierd },
    jsonc = { require("formatter.filetypes.json").prettierd },
    markdown = { require("formatter.filetypes.markdown").prettierd },
    yaml = { require("formatter.filetypes.yaml").prettierd },
    swift = {
      function()
        return {
          exe = "swift format",
          args = {
            formatter_util.escape_path(formatter_util.get_current_buffer_file_path()),
          },
          stdin = true,
        }
      end,
    },
  },
})

vim.cmd([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost * FormatWrite
  augroup END
]])

-- vim.opt.spell = true
-- vim.opt.spelllang = 'de,en'

local null_ls = require("null-ls")
local cspell = require("cspell")
local cSpellJsonPath = vim.fn.expand("~/.cspell.json")


local cSpellConfig = {
  find_json = function(cwd)
    return cSpellJsonPath
  end,
}

null_ls.setup({
  should_attach = function(bufnr)
    if is_dotfiles then
      return false
    end
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    if ok and stats and stats.size > max_filesize then
      return false
    end
    return true
  end,
  sources = {
    -- null_ls.builtins.diagnostics.tsc.with({
    --   prefer_local = "node_modules/.bin",
    -- }),
    cspell.diagnostics.with({
      timeout_ms = 5000,
      config = cSpellConfig,
      diagnostics_postprocess = function(diagnostic)
        diagnostic.severity = vim.diagnostic.severity["HINT"]
      end,
    }),
    cspell.code_actions.with({ config = cSpellConfig }),
  },
  on_attach = on_attach,
})

lspconfig.flow.setup({
  cmd = { "yarn", "flow", "lsp" },
  on_attach = on_attach,
  filetypes = { "javascriptreact" },
})


local configs = require("lspconfig.configs")

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

if not configs.fiona then
  configs.fiona = {
    default_config = {
      --cmd = { "node", "--inspect=6009", "../fiona/packages/fiona-lsp/out/fiona-lsp.js", "--stdio" },
      cmd = { "npx", "fiona-lsp", "--stdio" },
      root_dir = lspconfig.util.find_package_json_ancestor,
      filetypes = { "javascriptreact", "typescriptreact" },
    },
  }
end

lspconfig.fiona.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.sourcekit.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = {
    "sourcekit-lsp"
    --"$(xcode-select -p)
    -- "/Applications/Xcode-16.2.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
  },
  root_dir = function(filename, _)
    return lspconfig.util.root_pattern("buildServer.json")(filename)
        or lspconfig.util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
        or lspconfig.util.find_git_ancestor(filename)
        or lspconfig.util.root_pattern("Package.swift")(filename)
  end
}
)

lspconfig.clangd.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.tailwindcss.setup({
  -- on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "html",
    "javascript",
    "javascriptreact",
    "typescript",
    -- "typescript.tsx",
    "typescriptreact",
  },
})

lspconfig.eslint.setup({
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    -- use this if eslint_d (provided by null-ls) is not used
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  capabilities = capabilities,
  settings = { packageManager = "yarn" },
})

lspconfig.gopls.setup({
  on_attach = on_attach_with_format,
  capabilities = capabilities,
})

lspconfig.lua_ls.setup({
  on_attach = on_attach_with_format,
  capabilities = capabilities,
})

lspconfig.jsonls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    json = {
      schemas = {
        {
          description = "TypeScript compiler configuration file",
          fileMatch = { "tsconfig.json", "tsconfig.*.json" },
          url = "http://json.schemastore.org/tsconfig",
        },
        {
          description = "Babel configuration",
          fileMatch = { ".babelrc.json", ".babelrc", "babel.config.json" },
          url = "http://json.schemastore.org/lerna",
        },
        {
          description = "ESLint config",
          fileMatch = { "eslint.config.js", ".eslintrc.json", ".eslintrc" },
          url = "http://json.schemastore.org/eslintrc",
        },
        {
          description = "Prettier config",
          fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
          url = "http://json.schemastore.org/prettierrc",
        },
        {
          description = "node based packgage.json",
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
      },
    },
  },
})

lspconfig.ruby_lsp.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig.yamlls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] =
        "/.gitlab-ci.yml",
      },
    },
  },
})

lspconfig.ts_ls.setup({
  on_attach = function(client, bufnr)
    -- print(vim.bo.filetype)
    -- require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
    on_attach(client, bufnr)
  end,
  filetypes = {
    "typescript",
    "typescriptreact",
    -- 'typescript.tsx',
    "javascript",
  },
})

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    severity = {
      min = vim.diagnostic.severity["WARN"],
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = false,
  -- disables `Diagnostig:\n` header in float preview
  float = { source = true, header = false },
})

local luasnip = require("luasnip")

-- remove snippet linking after leaving snippet insert
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
  command = ":LuaSnipUnlinkCurrent",
})

local t = luasnip.text_node
local f = luasnip.function_node
local i = luasnip.insert_node
local s = luasnip.snippet
local function copy(args)
  return args[1]
end

-- console.log('cbu', ${1})
local conso = s("conso", {
  t("console.log('cbu',"),
  i(1),
  t(")"),
})

local function uppercaseFirst(args)
  return args[1][1]:sub(0, 1):upper() .. args[1][1]:sub(2)
end


local function lowercaseFirst(args)
  return args[1][1]:sub(0, 1):lower() .. args[1][1]:sub(2)
end

luasnip.add_snippets("javascriptreact", {
  -- const get${1}: Selector<${2}> = createFSelector(
  --     'get${1}',
  --     [],
  --     () => {
  --       return { };
  --     }
  -- );
  -- s("selector", {
  --   t("const get"),
  --   f(copy, 1),
  --   t(": Selector<number> = createFSelector('get"),
  --   i(1),
  --   t({ "',", "[],", "() => {", "return { }", "}", ");" }),
  -- }),

  -- const [ state, setState ] = React.useState<mixed>()
  s("useState", {
    t("const [ "),
    i(1),
    t(", set"),
    f(uppercaseFirst, 1),
    t(" ] = React.useState<mixed>()"),
  }),

  -- s("uPageSheet", {
  --   t("const [ open"),
  --   i(1),
  --   t(", "),
  --   f(lowercaseFirst, 1),
  --   t('SheetProps ] = useFPageSheetProps("'),
  --   f(copy, 1),
  --   t('")')
  -- }),
  --
  -- s("uBottomSheet", {
  --   t("const [ open"),
  --   i(1),
  --   t(", "),
  --   f(lowercaseFirst, 1),
  --   t('SheetProps ] = useFBottomSheetProps("'),
  --   f(copy, 1),
  --   t('")'),
  -- }),

  -- function ${1} ():ThunkAction {
  -- 	return (dispatch, getState) => {
  --
  -- 	}
  -- }
  -- s("action", {
  --   t("function "),
  --   i(1),
  --   t({
  --     " ():ThunkAction {",
  --     "return (dispatch, getState) => {",
  --     "",
  --     "}",
  --     "}",
  --   }),
  -- }),

  conso,

  -- import * as React from 'react';
  --
  -- function ${1}(): React.Node {
  --   return <></>;
  -- }
  --
  -- export default ${1};
  s("fcomp", {
    t({ "", "function " }),
    i(1),
    t({
      "(): React.Node {",
      "return <></>;",
      "}",
      "export default ",
    }),
    f(copy, 1),
  }),

  -- .navigationOptions = (): NavigationOptions => ({
  -- });
  -- s("nav", {
  --   t({
  --     ".navigationOptions = (): NavigationOptions => ({",
  --     "  ",
  --     "})",
  --   }),
  -- }),
})

luasnip.add_snippets("typescript", { conso })
luasnip.add_snippets("javascript", { conso })
luasnip.add_snippets("typescriptreact", { conso })

local cmp = require("cmp")
local compare = cmp.config.compare
require("nvim-cmp-ts-tag-close").setup({ skip_tags = { "FGlyphIcon" } })

cmp.setup({
  --performance = { debounce = 150 },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
      vim_item.kind = "■"
      vim_item.menu = ""
      return vim_item
    end,
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
    },
  },
  preselect = cmp.PreselectMode.None,
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    --   { name = 'cmp-tw2css' },
    { name = "nvim-cmp-ts-tag-close" },
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "path" },
    { name = "luasnip" },
  },
})

local harpoon = require("harpoon")

harpoon:setup()

local function toggle_telescope(harpoon_files)
  local finder = function()
    local paths = {}
    for _, item in ipairs(harpoon_files.items) do
      table.insert(paths, item.value)
    end

    return require("telescope.finders").new_table({
      results = paths,
    })
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = finder(),
    sorter = require("telescope.config").values.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<C-x>", function()
        local state = require("telescope.actions.state")
        local selected_entry = state.get_selected_entry()
        local current_picker = state.get_current_picker(prompt_bufnr)

        table.remove(harpoon_files.items, selected_entry.index)
        current_picker:refresh(finder())
      end)
      return true
    end,
  }):find()
end

vim.keymap.set("n", "<leader>w", function() harpoon:list():add() end)
vim.keymap.set("n", "<Space>d", function() toggle_telescope(harpoon:list()) end)
vim.keymap.set("n", "[w", function() harpoon:list():next() end)
vim.keymap.set("n", "]w", function() harpoon:list():prev() end)
