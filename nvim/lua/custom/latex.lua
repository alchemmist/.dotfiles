local M = {}

function M.wrap_text_in_textbf()
	local mode = vim.fn.visualmode()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)

	local lines = vim.fn.getline(start_pos[2], end_pos[2])

	if #lines == 1 then
		local line = lines[1]
		local start_col = start_pos[3]
		local end_col = end_pos[3] + 1
		local before = line:sub(1, start_col - 1)
		local selected_text = line:sub(start_col, end_col - 1)
		local after = line:sub(end_col)

		local new_line = before .. "\\textbf{" .. selected_text .. "}" .. after
		vim.fn.setline(start_pos[2], new_line)
	else
		local start_line = lines[1]
		local end_line = lines[#lines]
		local middle_lines = {}

		table.insert(middle_lines, start_line:sub(start_pos[3]) .. "\\textbf{")
		for i = 2, #lines - 1 do
			table.insert(middle_lines, lines[i])
		end
		table.insert(middle_lines, "} " .. end_line:sub(1, end_pos[3]))

		vim.fn.setline(start_pos[2], start_line:sub(1, start_pos[3] - 1) .. "\\textbf{" .. start_line:sub(start_pos[3]))
		vim.fn.setline(end_pos[2], end_line:sub(1, end_pos[3]) .. "}" .. end_line:sub(end_pos[3] + 1))

		if #middle_lines > 1 then
			vim.fn.append(start_pos[2], middle_lines)
		end
	end
end

return M
