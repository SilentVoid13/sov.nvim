local M = {}

M.start_link_concealing = function()
	vim.fn.matchadd("Conceal", "\\zs\\[\\[[^[]\\{-}[|]\\ze[^[]\\{-}\\]\\]", 0, -1, { conceal = "" })
	vim.fn.matchadd("Conceal", "\\[\\[[^[\\{-}[|][^[]\\{-}\\zs\\]\\]\\ze", 0, -1, { conceal = "" })
	vim.fn.matchadd("Conceal", "\\zs\\[\\[\\ze[^[]\\{-}\\]\\]", 0, -1, { conceal = "" })
	vim.fn.matchadd("Conceal", "\\[\\[[^[]\\{-}\\zs\\]\\]\\ze", 0, -1, { conceal = "" })

    vim.wo.conceallevel = 2
    vim.api.nvim_exec([[highlight Conceal ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE]], false)
end

local conceal_augroup = vim.api.nvim_create_augroup("SovConcealing", { clear = true })

M.setup_conceal = function()
	vim.api.nvim_create_autocmd({ "FileType", "BufRead", "BufEnter" }, {
		pattern = {"*.md"},
		callback = function()
            M.start_link_concealing()
        end,
		group = conceal_augroup,
	})
end

return M
