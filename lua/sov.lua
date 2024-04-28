local M = {}

local lsp = require("sov.lsp")
local commands = require("sov.commands")
local conceal = require("sov.conceal")

table.unpack = table.unpack or unpack -- 5.1 compatibility

M.config = {
	root_dir = "",
}

M.setup = function(opts)
	opts = opts or {}
	M.config = vim.tbl_extend("force", M.config, opts)
	M.setup_lsp()
	conceal.setup_conceal()

	commands.add("SovIndex", M.index)
	commands.add("SovDaily", M.daily)
	commands.add("SovScriptRun", M.script_run)
	commands.add("SovScriptInsert", M.script_insert)
	commands.add("SovFindFiles", M.find_files)
	commands.add("SovFuzzySearch", M.fuzzy_search)
	-- commands.add("SovListTags", M.list_tags)
	-- commands.add("SovListOrphans", M.list_orphans)
	-- commands.add("SovListDeadlinks", M.list_deadlinks)
end

M.setup_lsp = function()
	local trigger = "FileType " .. "markdown"
	vim.api.nvim_command(string.format("autocmd %s lua require'sov'.lsp_buf_auto_add(0)", trigger))

	-- start the lsp server in the background to always be ready for commands
	-- TODO: this is not the best, find a better way
	lsp.start(M.config)
end

M.lsp_buf_auto_add = function(bufnr)
	lsp.buf_add(M.config, bufnr)
end

M.index = function()
	lsp.execute_command(M.config, "index", {}, function(err)
		assert(not err, tostring(err))
		print("Indexing complete")
	end)
end

M.daily = function()
	local res = lsp.execute_sync_command(M.config, "daily", {})
	local daily_path = res.result
	assert(daily_path ~= nil)
	vim.api.nvim_command("e " .. daily_path)
end

M.script_insert = function(script_name, rem_args)
	rem_args = rem_args or {}
	local args = { script_name, table.unpack(rem_args) }
	lsp.execute_command(M.config, "script.run", args, function(err, content)
		assert(not err, tostring(err))
		local lines = vim.split(content, "\n")
		-- insert content at cursor
		vim.api.nvim_put(lines, "l", true, true)
	end)
end

M.script_run = function(script_name, rem_args)
	rem_args = rem_args or {}
	local args = { script_name, table.unpack(rem_args) }

	local res = lsp.execute_sync_command(M.config, "script.run", args)
	local result = res.result
	assert(result ~= nil)
	return result
end

M.script_create = function(note_name, script_name, rem_args)
	rem_args = rem_args or {}
	local args = { note_name, script_name, table.unpack(rem_args) }

	local res = lsp.execute_sync_command(M.config, "script.create", args)
	local result = res.result
	assert(result ~= nil)
	return result
end

M.list_tags = function()
	lsp.execute_command(M.config, "list.tags", {}, function(err, tags)
		assert(not err, tostring(err))
		print(tags)
		-- TODO: open telescope with tags
	end)
end

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
