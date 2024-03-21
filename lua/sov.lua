local M = {}

local utils = require("sov.utils")
local lsp = require("sov.lsp")
local commands = require("sov.commands")

M.config = {
    root_dir = "/home/notes",
}

M.setup = function(opts)
    opts = opts or {}
    M.config = vim.tbl_extend("force", M.config, opts)
    M.setup_lsp()

    commands.add("SovFindFiles", M.find_files)
    commands.add("SovFuzzySearch", M.fuzzy_search)
    -- commands.add("SovIndex", M.index)
    -- commands.add("SovListTags", M.list_tags)
    -- commands.add("SovListOrphans", M.list_orphans)
    -- commands.add("SovListDeadlinks", M.list_deadlinks)
end

M.setup_lsp = function()
	local trigger = "FileType " .. "markdown"
    M.lsp_buf_auto_add(0)
    vim.api.nvim_command(string.format("autocmd %s lua require'sov'.lsp_buf_auto_add(0)", trigger))
end

M.lsp_buf_auto_add = function(bufnr)
    lsp.buf_add(M.config, bufnr)
end

M.index = function() end

M.list_tags = function() end

M.list_orphans = function() end

M.list_deadlinks = function() end

M.resolve = function(link) end

M.find_files = function()
    require("telescope.builtin").find_files({
        cwd = M.config.root_dir,
    })
end

M.fuzzy_search = function()
    require("telescope.builtin").live_grep({
        cwd = M.config.root_dir,
    })
end

return M
