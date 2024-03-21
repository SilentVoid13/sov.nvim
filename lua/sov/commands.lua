local M = {}

M.name_fn_map = {}

M.add = function(name, fn, opts)
	opts = opts or {}
	vim.api.nvim_create_user_command(name, function(params)
		if opts.needs_selection then
			assert(
				params.range == 2,
				"Command needs a selection and must be called with '<,'> range. Try making a selection first."
			)
		end
		fn(loadstring("return " .. params.args)())
	end, { nargs = "?", force = true, range = opts.needs_selection, complete = "lua" })
	M.name_fn_map[name] = fn
end

M.del = function(name)
  M.name_fn_map[name] = nil
  vim.api.nvim_del_user_command(name)
end

return M
