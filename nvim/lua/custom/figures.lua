print("Module custom.figures loaded successfully")

local M = {}
-- ~/.config/nvim/lua/figures.lua

-- Функция для получения выделенного текста
function M.get_visual_selection()
	local start_row, start_col = table.unpack(vim.api.nvim_buf_get_mark(0, "<"))
	local end_row, end_col = table.unpack(vim.api.nvim_buf_get_mark(0, ">"))

	-- Если начало и конец на одной строке, поправляем столбцы
	if start_row == end_row then
		end_col = end_col + 1
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
	if #lines == 0 then
		return ""
	end

	lines[#lines] = string.sub(lines[#lines], 1, end_col)
	lines[1] = string.sub(lines[1], start_col + 1)
	return table.concat(lines, "\n")
end

-- Команда для создания новой фигуры
function M.create_figure()
	local selected_text = M.get_visual_selection()
	if selected_text and selected_text ~= "" then
		local cmd = "inkscape-figures create " .. selected_text .. " /home/alchemmist/knowledge-base/CU/figures"
		vim.cmd("! " .. cmd)
	else
		print("No text selected.")
	end
end

-- Команда для редактирования существующей фигуры
function M.edit_figure()
	local selected_text = M.get_visual_selection()
	if selected_text and selected_text ~= "" then
		local cmd = "inkscape-figures edit /home/alchemmist/knowledge-base/CU/figures/" .. selected_text .. ".svg"
		vim.cmd("! " .. cmd)
	else
		print("No text selected.")
	end
end

-- Экспортируем функции
return M
