-- config for neovim 0.11.4+

vim.opt.swapfile = false

-- Make the colorscheme most closely resemble default vim colors
vim.cmd"colorscheme vim"
vim.opt.background = "light"
-- Small fixup
vim.api.nvim_set_hl(0, "Statement", {ctermfg="DarkYellow"})
vim.cmd"highlight SignColumn guibg=NONE ctermbg=NONE"
vim.opt.guicursor = "a:block"

-- Status line and command line
vim.cmd"highlight StatusLine   gui=NONE cterm=NONE ctermbg=NONE ctermfg=blue     guifg=blue    "
vim.cmd"highlight StatusLineNC gui=NONE cterm=NONE ctermbg=NONE ctermfg=darkgray guifg=darkgray"
vim.opt.laststatus = 1
vim.opt.rulerformat = "%=%{%v:lua.ruler_diagnostics()%}%l,%c %P"
vim.opt.statusline = "%f %= %{%v:lua.ruler_diagnostics()%}%l,%c"
vim.opt.fillchars:append({
  stl = "─",
  stlnc = "─",
})

-- LSP
vim.lsp.config["clangd"] = { 
  cmd = { "clangd" },
  filetypes = { "c", "cpp" },
  root_markers = { ".git", "Makefile" },
}
vim.lsp.config["luals"] = { 
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".git", "Makefile" },
}
vim.diagnostic.config({
  virtual_text={virt_text_pos="right_align"}
})
-- remove semantic highlighting bs
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end
vim.diagnostic.enable(false)
vim.keymap.set('n', ' ', function()
  vim.lsp.enable("clangd")
  vim.lsp.enable("luals")
  local en = vim.diagnostic.is_enabled()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    vim.wo[win].signcolumn = en and "no" or "yes"
  end
  vim.diagnostic.enable(not en, {bufnr=nil})
end, { desc = "Toggle diagnostics" })

-- block in insert mode
vim.opt.guicursor = ""

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- remove echo'ing chars in normal mode
vim.opt.showcmd = false

vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true, silent = true })

-- Completion
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.api.nvim_set_keymap("i", "<c-n>", "<c-x><c-o>", { noremap = true, silent=true })
vim.api.nvim_set_keymap("i", "<c-p>", "<c-x><c-o>", { noremap = true, silent=true })

vim.api.nvim_set_keymap("n", "gq", "gggqG", { noremap = true,
silent = true })

function _G.ruler_diagnostics()
  local d = vim.diagnostic
  local e = d.count(0, {})
  return (e[d.severity.ERROR] and "E:"..e[d.severity.ERROR].." " or "")
      .. (e[d.severity.WARN ] and "W:"..e[d.severity.WARN ].." " or "")
end

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  callback = function() vim.cmd("redrawstatus") end,
})

-- remove highlighting
vim.treesitter.start = function() end
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function() vim.treesitter.stop() end,
})

-- remove intro screen & don't press enter after :w
vim.opt.shortmess = "It"
vim.opt.smartindent = true
-- autoindent is on by default

-- no switch case indent
vim.opt.cino = ":0"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.smartcase = true

vim.api.nvim_set_keymap('i', '<C-Space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Space>', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
