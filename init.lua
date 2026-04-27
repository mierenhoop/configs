-- config for neovim 0.11.4

-- TODO: have some way to disable lsp for out of project files

-- make it most closely resemble default vim colors
vim.cmd"colorscheme vim"
vim.o.background = "light"
-- Small fixup
vim.api.nvim_set_hl(0, "Statement", {ctermfg="DarkYellow"})
vim.cmd"highlight SignColumn ctermbg=black"

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

vim.opt.completeopt = { "menuone", "noselect", "popup" }

vim.diagnostic.config({
  virtual_text={virt_text_pos="right_align"}
})

vim.lsp.enable("clangd")
vim.lsp.enable("luals")


-- remove semantic highlighting bs
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end

-- remove big status line
--vim.o.laststatus = 0
vim.o.laststatus = 2
-- block in insert mode
vim.o.guicursor = ""

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

-- remove echo'ing chars in normal mode
vim.o.showcmd = false

vim.diagnostic.enable(false)
vim.keymap.set('n', ' ', function()
  local en = vim.diagnostic.is_enabled()
  -- TODO: either do both only current buffer or all
  vim.o.signcolumn = en and "no" or "yes"
  vim.diagnostic.enable(not en, {bufnr=nil})
end, { desc = "Toggle diagnostics" })

vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "<c-n>", "<c-x><c-o>", { noremap = true, silent=true })
vim.api.nvim_set_keymap("i", "<c-p>", "<c-x><c-o>", { noremap = true, silent=true })

vim.api.nvim_set_keymap("n", "gq", "gggqG", { noremap = true,
silent = true })

vim.cmd"highlight StatusLine ctermfg=black ctermbg=blue"
vim.cmd"highlight StatusLineNC ctermfg=black ctermbg=darkgray"
vim.api.nvim_create_autocmd('DiagnosticChanged', {
  callback = function(args)
    -- TODO: with split it becomes weird
    local e = vim.diagnostic.count(0, {})
    if e[vim.diagnostic.severity.ERROR] then
      vim.cmd"highlight StatusLine ctermfg=black ctermbg=red"
    elseif e[vim.diagnostic.severity.WARN] then
      vim.cmd"highlight StatusLine ctermfg=black ctermbg=darkyellow"
    else
      vim.cmd"highlight StatusLine ctermfg=black ctermbg=blue"
    end
  end,
})

-- remove highlighting
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
	vim.treesitter.stop()
  end,
})

-- remove intro screen
vim.o.shortmess = "I"
vim.o.smartindent = true
-- autoindent is on by default

-- no switch case indent
vim.o.cino = ":0"

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.incsearch = true
vim.o.hlsearch = false
vim.o.smartcase = true

vim.api.nvim_set_keymap('i', '<C-Space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Space>', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
