-- Automatically install packer start
local ensure_packer = function()
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
	    vim.cmd [[packadd packer.nvim]]
		return true
		  end
		    return false
	    end

local packer_bootstrap = ensure_packer()
-- Automatically install packer end
--
--
return require('packer').startup(function(use)
-- Plugins
-- Specifying the packer here so it does not ask me to delete itself each time.
use { "wbthomason/packer.nvim" }
-------------------------- Colortheme --------------------------
use { 'bluz71/vim-moonfly-colors', branch = 'cterm-compat' }

-------------------------- Fuzzy finder --------------------------
--
-- Faster c sorter for telescope
use {'nvim-telescope/telescope-fzy-native.nvim'}

-- The best fuzzy finder in the world and the reason why I switched back to nvim.
use {
  'nvim-telescope/telescope.nvim', tag = '0.1.0',
   requires = { {'nvim-lua/plenary.nvim'}},
}

-- Overwriting the telescope built in sorter with the compiled c engine.
require('telescope').setup {
    extensions = {
	    fzy_native = {
		override_generic_sorter = false,
		override_file_sorter = true,
		 }
	}
}
require('telescope').load_extension('fzy_native')
-------------------------- Fuzzy finder END --------------------------


-------------------------- Installer --------------------------
use { "williamboman/mason.nvim" } 
require("mason").setup()
-------------------------- Installer END --------------------------
--
-------------------------- LSP servers --------------------------
use { "williamboman/mason-lspconfig.nvim" }

local lsp_servers = {"pyright", "tsserver", "gopls", "jsonls", "sumneko_lua" ,"marksman", "tailwindcss"}
require("mason-lspconfig").setup({
	ensure_installed = lsp_servers
})
use { "neovim/nvim-lspconfig" }

for _, server in ipairs(lsp_servers) do
	  require('lspconfig')[server].setup{}
end

-- Configuring the lua language server seperately because we have a lot of stuff to say to it.
require("lspconfig").sumneko_lua.setup{
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
		diagnostics = {
				globals = { 'vim' },
			},
		}
	}
}

-------------------------- LSP servers END --------------------------
--
-- Automatically set up configuration after cloning packer.
if packer_bootstrap then
	require('packer').sync()
end

-- Options start
vim.opt.iskeyword:append('-')
vim.opt.shortmess:append("c")
vim.o.clipboard = 'unnamedplus'
vim.o.path = "$PWD/**"
vim.o.number = true
vim.o.smartindent = true
vim.o.relativenumber = true
vim.cmd[[colorscheme moonfly]]
-- Options end
--
end)
