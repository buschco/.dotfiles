return {

  -- Theme
  --'buschco/vim-horizon',
  { dir = '~/github.com.nosync/vim-horizon' },

  'tpope/vim-surround',
  'tpope/vim-unimpaired',
  'tpope/vim-repeat',
  -- 'unblevable/quick-scope',
  {
    'NvChad/nvim-colorizer.lua',

    opts = {
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
    }
  },

  'neovim/nvim-lspconfig',
  'artemave/workspace-diagnostics.nvim',

  'lukas-reineke/lsp-format.nvim',

  --'dhruvasagar/vim-table-mode',

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    -- dir = '~/github.com.nosync/nvim-cmp',
    --'buschco/nvim-cmp',
    -- dir = '~/Documents/code.nosync/nvim-cmp',
    dependencies = {
      -- { dir = '~/github.com.nosync/cmp-tw2css' },
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      -- { 'L3MON4D3/LuaSnip', version = "1.*" },
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = {
          'saadparwaiz1/cmp_luasnip',
        },
      },
      'roobert/tailwindcss-colorizer-cmp.nvim',
      --{ dir = '~/github.com.nosync/nvim-cmp-ts-tag-close' },
      'buschco/nvim-cmp-ts-tag-close'
    }
  },

  -- { 'windwp/nvim-autopairs' },
  { 'mhartington/formatter.nvim' },
  { 'stevearc/conform.nvim',                opts = {} },

  -- mfussenegger/nvim-lint but seems old?
  { 'nvimtools/none-ls.nvim',               dependencies = { 'davidmh/cspell.nvim' } },


  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {}
  },

  { 'AndrewRadev/linediff.vim' },

  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      -- 'nvim-treesitter/playground',
    }
  },

  'tpope/vim-fugitive',
  'lewis6991/gitsigns.nvim',
  -- { dir = '~/github.com.nosync/gitsigns.nvim' },

  'nvim-lualine/lualine.nvim',

  { 'numToStr/Comment.nvim',   opts = {} },

  {
    'nvim-telescope/telescope.nvim',
    branch       = 'master',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      }
    }
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  }
}
