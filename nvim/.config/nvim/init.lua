local opt = vim.opt
opt.tabstop     = 4
opt.shiftwidth  = 4
opt.softtabstop = 4
opt.expandtab   = true
opt.splitright  = true
opt.splitbelow  = true

local g = vim.g
g.slime_target                  = "neovim"
g.AutoPairs                     = {
  ['(']=')', ['[']=']', ['{']='}', ["'"]="'", ['"']='"',
  ['`']='`', ['```']='```', ['"""']='"""', ["'''"]="'''", ['$']='$'
}
g.AutoPairsShortcutFastWrap     = '<C-e>'
g.julia_indent_align_brackets   = 0
g.netrw_banner                  = 0
g.copilot_filetypes             = { ['*'] = true, markdown = false, typst = false, tex = false, }
g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

-- Bootstrap packer.nvim if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      'git', 'clone', '--depth', '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path
    })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'

  use {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup()
    end,
  }

  -- REPL & workflow
  use 'jpalardy/vim-slime'

  -- Auto-pairs & surrounding
  use 'jiangmiao/auto-pairs'
  use 'tpope/vim-surround'

  use {
    'navarasu/onedark.nvim',
    config = function()
      require('onedark').setup { style = 'darker' }
      require('onedark').load()
    end,
  }

  use 'raivivek/vim-snakemake'

  use {
    'JuliaEditorSupport/julia-vim',
    config = function()
      -- load matchit for % matching in Julia
      vim.cmd 'runtime macros/matchit.vim'
    end
  }

  use 'vim-scripts/indentpython.vim'

  -- Typst
  use 'kaarmu/typst.vim'
  use 'chomosuke/typst-preview.nvim'

  -- text-objects
  use 'kana/vim-textobj-user'
  use 'sgur/vim-textobj-parameter'
  use {
    'lucapette/vim-textobj-underscore',
    requires = { 'kana/vim-textobj-user' },
  }
  
  use {
    'fvictorio/vim-textobj-backticks',
    requires = { 'kana/vim-textobj-user' },
  }
  use 'glts/vim-textobj-comment'

  use 'vimlab/split-term.vim'
  use 'tpope/vim-fugitive'

  use {
    'williamboman/mason.nvim',
    -- optional but recommended: keep Mason’s registry up-to-date
    run = function() pcall(vim.cmd, 'MasonUpdate') end,
  }

  -- (optionally, to bridge Mason with lspconfig)
  use { 'williamboman/mason-lspconfig.nvim' }

  use {
    'greggh/claude-code.nvim',
    requires = {
      'nvim-lua/plenary.nvim', -- Required for git operations
    },
    config = function()
      require('claude-code').setup()
    end
  }

  use {
    '3rd/image.nvim',
    requires = { 'vhyrro/luarocks.nvim', },
  }

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
  }

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

local km = vim.keymap.set
km('n', '<leader>ev', ':vsplit $MYVIMRC<CR>', { noremap = true, silent = true })
km('n', '<leader>sv', ':source $MYVIMRC<CR>', { noremap = true, silent = true })
km('x', '<<', '<gv', { noremap = true })
km('x', '>>', '>gv', { noremap = true })
km('t', '<S-Space>', '<Space>', { noremap = true })
km('t', '<S-Enter>', '<Enter>', { noremap = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    km('n', '<F9>', ':wa<CR>:!%:p<CR>', { buffer = true, noremap = true })
    km('i', '<F9>', '<ESC>:wa<CR>:!%:p<CR>', { buffer = true, noremap = true })
  end,
})

require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = {
      'pyright',
      -- 'julials',
      'tinymist',
  },
}

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "scp://*",
  callback = function()
    if vim.bo.buftype ~= "" then
      vim.bo.completefunc = "v:lua.CompleteDummy"
    end
  end,
})

vim.api.nvim_create_user_command('RemoveTrailingWhitespace', function()
  vim.cmd([[%s/\s\+$//e]])
end, {})

function _G.CompleteDummy(findstart, base)
  if findstart == 1 then return 0 else return {} end
end

require("conform").setup({
    formatters = {
        runic = {
            command = "julia",
            args = {"--project=@runic", "-e", "using Runic; exit(Runic.main(ARGS))"},
        },
    },
    formatters_by_ft = {
        julia = {"runic"},
        c = {"clang-format"},
        cpp = {"clang-format"},
        sql = {"sql_formatter"},
    },
    default_format_opts = {
        -- Increase the timeout in case Runic needs to precompile
        -- (e.g. after upgrading Julia and/or Runic).
        timeout_ms = 10000,
    },
})

vim.keymap.set("n", "<leader>f", function()
  require("conform").format({
    lsp_fallback = true,
    async = false,      -- block until formatting is done
    timeout_ms = 3000,  -- fail if formatting takes more than 3s
  })
end, { desc = "Format buffer with Conform" })

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
    view = {width = 50},
})
require('image').setup({
  max_width = 400,
  max_height = 100,
  max_width_window_percentage = 30,
  max_height_window_percentage = 30,
  integrations = {
    nvim_tree = {
      enabled = true,
    },
  },
})
