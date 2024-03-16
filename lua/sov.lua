local M = {}

local utils = require("sov.utils")
local lsp = require("sov.lsp")

M.setup = function()
    M.setup_lsp()
	require("sov.commands")
end

M.setup_lsp = function()
	local trigger = "FileType " .. "markdown"
    M.lsp_buf_auto_add(0)
    vim.api.nvim_command(string.format("autocmd %s lua require'sov'.lsp_buf_auto_add(0)", trigger))
end

M.lsp_buf_auto_add = function(bufnr)
    lsp.buf_add(bufnr)
end

M.index = function() end

M.list_tags = function() end

M.list_orphans = function() end

M.list_deadlinks = function() end

M.resolve = function(link) end

return M
