local sov = require("sov")

local name_fn_map = {}

local function add(name, fn, opts)
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
	name_fn_map[name] = fn
end

local function del(name)
  name_fn_map[name] = nil
  vim.api.nvim_del_user_command(name)
end

add("SovIndex", sov.index)
add("SovListTags", sov.list_tags)
add("SovListOrphans", sov.list_orphans)
add("SovListDeadlinks", sov.list_deadlinks)
add("SovResolve", sov.resolve)
