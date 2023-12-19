return {

  -- Theme
  -- use 'buschco/vim-horizon'
  { dir = '~/github.com.nosync/vim-horizon' },

  'tpope/vim-surround',
  'tpope/vim-unimpaired',
  'tpope/vim-repeat',
  -- 'unblevable/quick-scope',
  'NvChad/nvim-colorizer.lua',

  'neovim/nvim-lspconfig',

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
      { 'L3MON4D3/LuaSnip', version = "1.*" },
      'saadparwaiz1/cmp_luasnip',
      'roobert/tailwindcss-colorizer-cmp.nvim',
      { dir = '~/github.com.nosync/nvim-cmp-ts-tag-close' },
    }
  },

  -- { 'stevearc/oil.nvim', opts = {
  --   default_file_explorer = false,
  --   view_options = {
  --     is_hidden_file = function(name, bufnr)
  --       return vim.startswith(name, ".")
  --     end,
  --     show_hidden = true
  --     }
  -- } },

  -- { 'windwp/nvim-autopairs' },
  { 'mhartington/formatter.nvim' },

  -- if something breaks migrate to https://github.com/nvimtools/none-ls.nvim
  { dir = '~/github.com.nosync/null-ls.nvim', dependencies = { 'davidmh/cspell.nvim' } },

  { 'sindrets/diffview.nvim', dependencies  = { 'nvim-lua/plenary.nvim' } },

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
  {'akinsho/bufferline.nvim', version = "v3.*" },

  'numToStr/Comment.nvim',

  { 'nvim-telescope/telescope.nvim', 
    branch = '0.1.x',
    dependencies  = { 
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim', 
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      }
    }
  },
}
