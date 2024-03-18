local client_id = nil

local M = {}

---Tries to find a client by name
function M.external_client()
	local client_name = "sov"
	local active_clients = vim.lsp.get_active_clients({ name = client_name })

	if active_clients == {} then
		return nil
	end

	-- return first lsp server that is actually in use
	for _, v in ipairs(active_clients) do
		if v.attached_buffers ~= {} then
			return v.id
		end
	end
end

---Starts an LSP client if necessary
function M.start()
	if not client_id then
		client_id = M.external_client()
	end

    -- todo: root_dir config option
	if not client_id then
		client_id = vim.lsp.start_client({
			cmd = { "sov_lsp" },
			name = "sov",
            root_dir = "/home/silent/quark/",
		})
	end
end

---Starts an LSP client if necessary, and attaches the given buffer.
---@param bufnr number
function M.buf_add(bufnr)
	bufnr = bufnr or 0
	M.start()
	vim.lsp.buf_attach_client(bufnr, client_id)
end

---Stops the LSP client managed by this plugin
function M.stop()
	local client = M.client()
	if client then
		client.stop()
	end
	client_id = nil
end

---Gets the LSP client managed by this plugin, might be nil
function M.client()
	return vim.lsp.get_client_by_id(client_id)
end

return M
