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
function M.get_rofi_input()
	-- Запуск rofi с флагом -dmenu для ввода строки
	local handle = io.popen("rofi -dmenu -p 'Enter text:'")
	local result = handle:read("*a")
	handle:close()

	-- Убираем лишние символы перевода строки
	return result:gsub("%s+", "")
end

function M.create_figure()
	-- Получаем ввод от rofi
	local selected_text = M.get_rofi_input()

	-- Проверяем, что введённый текст не пустой
	if selected_text == "" then
		print("No input provided")
		return
	end

	-- Собираем команду для создания фигуры
	local command = "inkscape-figures create " .. selected_text .. " /home/alchemmist/knowledge-base/CU/figures"
	-- Выполняем команду
	vim.cmd("! " .. command)
end

-- Команда для редактирования существующей фигуры
function M.edit_figure()
	local cmd = "inkscape-figures edit /home/alchemmist/knowledge-base/CU/figures && hyprctl dispatch workspace 7"
	vim.cmd("! " .. cmd)
end

-- Экспортируем функции
return M
