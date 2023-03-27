return {

  -- Theme
  -- use 'buschco/vim-horizon'
  { dir = '~/Documents/code.nosync/vim-horizon' },

  'tpope/vim-surround',
  'tpope/vim-unimpaired',
  'tpope/vim-repeat',
  'unblevable/quick-scope',
  'NvChad/nvim-colorizer.lua',

  'neovim/nvim-lspconfig',

  'lukas-reineke/lsp-format.nvim',

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      { 'L3MON4D3/LuaSnip', version = "1.*" },
      'saadparwaiz1/cmp_luasnip',
      'roobert/tailwindcss-colorizer-cmp.nvim'
    },
  },

  'ray-x/lsp_signature.nvim',
  'jose-elias-alvarez/null-ls.nvim',
  { 'sindrets/diffview.nvim',
    dependencies  = { 'nvim-lua/plenary.nvim' }
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'windwp/nvim-ts-autotag',
      --'nvim-treesitter/playground', 
    }
  },

  'tpope/vim-fugitive',
  'lewis6991/gitsigns.nvim',

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
