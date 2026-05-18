-- ============================================================
-- Options
-- ============================================================
local opt = vim.opt
opt.tabstop     = 4
opt.shiftwidth  = 4
opt.softtabstop = 4
opt.expandtab   = true
opt.splitright  = true
opt.splitbelow  = true

-- ============================================================
-- Global variables (plugin configs)
-- ============================================================
local g = vim.g
g.slime_target                  = "neovim"
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

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- ============================================================
-- Plugins (vim.pack)
-- ============================================================

-- Plugins that load in both Neovim and VSCode extension
vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/jpalardy/vim-slime",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/tpope/vim-surround",
  "https://github.com/navarasu/onedark.nvim",
  "https://github.com/raivivek/vim-snakemake",
  "https://github.com/JuliaEditorSupport/julia-vim",
  "https://github.com/vim-scripts/indentpython.vim",
  "https://github.com/chomosuke/typst-preview.nvim",
  "https://github.com/kana/vim-textobj-user",
  "https://github.com/sgur/vim-textobj-parameter",
  "https://github.com/lucapette/vim-textobj-underscore",
  "https://github.com/fvictorio/vim-textobj-backticks",
  "https://github.com/glts/vim-textobj-comment",
  "https://github.com/vimlab/split-term.vim",
  "https://github.com/tpope/vim-fugitive",
})

-- Plugins that should NOT load in VSCode extension
if not vim.g.vscode then
  vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/williamboman/mason-lspconfig.nvim",
    "https://github.com/nvim-tree/nvim-tree.lua",
    "https://github.com/nvim-tree/nvim-web-devicons",
  })
end

-- ============================================================
-- Post-install / post-update hooks
-- ============================================================
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    if name == "nvim-treesitter" then
      pcall(function() require("nvim-treesitter").update() end)
    elseif name == "mason.nvim" then
      pcall(vim.cmd, "MasonUpdate")
    end
  end,
})

-- ============================================================
-- Plugin setups
-- ============================================================

-- Colorscheme (load early so subsequent highlights apply)
require("onedark").setup({ style = "darker" })
require("onedark").load()

local function typst_hl()
  local set = vim.api.nvim_set_hl

  -- 標題分層：用同色系不同亮度做出階層感
  set(0, "@markup.heading.1.typst", { fg = "#e06c75", bold = true })
  set(0, "@markup.heading.2.typst", { fg = "#d19a66", bold = true })
  set(0, "@markup.heading.3.typst", { fg = "#e5c07b", bold = true })
  set(0, "@markup.heading.4.typst", { fg = "#98c379", bold = true })
  set(0, "@markup.heading.5.typst", { fg = "#56b6c2", bold = true })
  set(0, "@markup.heading.6.typst", { fg = "#61afef", bold = true })

  -- 讓粗體、斜體真的變粗斜（而不是只換顏色）
  set(0, "@markup.strong.typst",  { bold = true })
  set(0, "@markup.italic.typst",  { italic = true })
  set(0, "@markup.underline.typst", { underline = true })
  set(0, "@markup.strikethrough.typst", { strikethrough = true })

  -- raw code 塊用稍深的背景區隔
  set(0, "@markup.raw.typst",       { fg = "#98c379" })
  set(0, "@markup.raw.block.typst", { fg = "#abb2bf", bg = "#2c313a" })

  set(0, "@markup.link.label.typst", { fg = "#61afef", underline = true })
  set(0, "@markup.link.url.typst",   { fg = "#56b6c2", italic = true })
  set(0, "@markup.list.typst",       { fg = "#e06c75" })

  -- math 模式：物理系寫 Typst 的重點
  set(0, "@markup.math.typst", { fg = "#56b6c2" })
  set(0, "@function.typst",         { fg = "#61afef" })       -- #rect(...)、#set(...)
  set(0, "@function.builtin.typst", { fg = "#56b6c2", italic = true })
  set(0, "@keyword.typst",          { fg = "#c678dd", italic = true })
  set(0, "@variable.typst",         { fg = "#e06c75" })
  set(0, "@label.typst",            { fg = "#e5c07b" })       -- <eq:foo>
  set(0, "@punctuation.special.typst", { fg = "#d19a66" })    -- #、$、@
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "onedark",
  callback = typst_hl,
})
typst_hl()  -- 如果 colorscheme 已經載入了，立即套用一次

-- Autopairs
require("nvim-autopairs").setup({
  check_ts = true,
  fast_wrap = {
    map = '<C-e>',
  },
})

local Rule = require("nvim-autopairs.rule")
require("nvim-autopairs").add_rules({
  Rule("$", "$", { "tex", "typst", "markdown" }),
})

-- Treesitter
pcall(function()
  require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })
  require("nvim-treesitter").install({
    "typst", "ocaml", "ocaml_interface",
    "python", "lua", "c", "cpp", "julia",
    "markdown", "markdown_inline", "bash",
  })
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "typst", "ocaml", "ocamlinterface",
    "python", "lua", "c", "cpp", "julia", "markdown", "bash",
  },
  callback = function(args)
    vim.treesitter.start()  -- Treesitter highlight
    -- Python uses indentpython.vim; everyone else gets treesitter indent
    if vim.bo[args.buf].filetype ~= "python" then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- julia-vim needs matchit loaded
vim.cmd("runtime macros/matchit.vim")

-- nvim-tree
require("nvim-tree").setup({ view = { width = 50 } })

-- Non-VSCode-only plugin setups
if not vim.g.vscode then
  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = { "basedpyright", "ruff", "tinymist" },
  })

  require("conform").setup({
    formatters = {
      runic = {
        command = "julia",
        args = { "--project=@runic", "-e", "using Runic; exit(Runic.main(ARGS))" },
      },
    },
    formatters_by_ft = {
      julia = { "runic" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      sql = { "sql_formatter" },
      ocaml = { 'ocamlformat' },
    },
    default_format_opts = {
      timeout_ms = 10000,
    },
  })

  vim.keymap.set({ "n", "x" }, "<leader>f", function()
    require("conform").format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 3000,
    })
  end, { desc = "Format buffer or range with Conform" })
end

-- ============================================================
-- Keymaps
-- ============================================================
local km = vim.keymap.set
km('n', '<leader>ev', ':vsplit $MYVIMRC<CR>', { noremap = true, silent = true })
km('n', '<leader>sv', ':source $MYVIMRC<CR>', { noremap = true, silent = true })
km('x', '<<', '<gv', { noremap = true })
km('x', '>>', '>gv', { noremap = true })
km('t', '<S-Space>', '<Space>', { noremap = true })
km('t', '<S-Enter>', '<Enter>', { noremap = true })
km('x', '*', [[y/\V<C-R>=escape(@", '/\')<CR><CR>]], { desc = 'Search selection forward' })
km('x', '#', [[y?\V<C-R>=escape(@", '?\')<CR><CR>]], { desc = 'Search selection backward' })

-- ============================================================
-- Autocmds & commands
-- ============================================================
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    km({ 'n', 'i' }, '<F9>', '<Cmd>wa<CR><Cmd>!%:p<CR>',
       { buffer = true, desc = 'Save all & run current file' })
  end,
})

vim.api.nvim_create_user_command('RemoveTrailingWhitespace', function()
  vim.cmd([[%s/\s\+$//e]])
end, {})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].formatexpr = ""
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "lua", "c", "cpp", "rust", "markdown", "text", "tex", "gitcommit" },
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "scp://*",
  callback = function()
    if vim.bo.buftype ~= "" then
      vim.bo.completefunc = "v:lua.CompleteDummy"
    end
  end,
})

function _G.CompleteDummy(findstart, base)
  if findstart == 1 then return 0 else return {} end
end
