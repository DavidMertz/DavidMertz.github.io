local M = {}

local _win -- window id of the open registers popup, nil when closed
local _buf -- scratch buffer backing the popup

-- regtype -> type letter as shown by :reg (and accepted by nvim_put)
local TYPE_CHAR = { v = "c", V = "l", ["\22"] = "b" }

-- Close the popup if it is open (no-op otherwise).
local function close()
	local win, buf = _win, _buf
	_win, _buf = nil, nil
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, false)
	end
	if buf and vim.api.nvim_buf_is_valid(buf) then
		vim.api.nvim_buf_delete(buf, { force = true })
	end
end

-- Build the display lines: one entry per register, multi-line registers
-- indented under their header, control characters shown (^J, ^I, ...).
-- Returns the lines, the widest display width among them, and a map from
-- display line number to the register shown on that line.
local function build_lines()
	local registers = '"0123456789abcdefghijklmnopqrstuvwxyz*+-./:%#_='
	local lines, width, line_to_reg = {}, 0, {}

	for i = 1, #registers do
		local name = registers:sub(i, i)
		local ok, info = pcall(vim.fn.getreginfo, name)
		if
			ok
			and type(info) == "table"
			and info.regcontents
			and #info.regcontents > 0
			and not (#info.regcontents == 1 and info.regcontents[1] == "")
		then
			local t = TYPE_CHAR[info.regtype] or "c"
			local nlines = #info.regcontents
			for j, content in ipairs(info.regcontents) do
				-- Linewise registers end every line with a newline; other
				-- types only between lines.
				local text = vim.fn.strtrans(content)
				if j < nlines or t == "l" then
					text = text .. "^J"
				end
				local prefix = j == 1 and ('"' .. name .. "   " .. t .. "   ") or string.rep(" ", 9)
				lines[#lines + 1] = prefix .. text
				line_to_reg[#lines] = name
				width = math.max(width, vim.fn.strdisplaywidth(prefix .. text))
			end
		end
	end
	return lines, width, line_to_reg
end

-- Display the register list (:reg) in a centered floating window instead
-- of the message pane. Call again to close an open popup. Scrolling works
-- with normal j/k/ctrl-d etc. Press <Enter> on a register to paste it at
-- the cursor of the previously focused window (the register's own type is
-- honored); q, <Esc>, <C-c>, or clicking another window closes it without
-- pasting.
function M.registers_popup()
	if _win and vim.api.nvim_win_is_valid(_win) then
		close() -- toggle
		return
	end
	close() -- discard a stale buffer from a previous popup

	local prev_win = vim.api.nvim_get_current_win()
	local lines, content_width, line_to_reg = build_lines()
	if #lines == 0 then
		vim.notify("All registers are empty", vim.log.levels.INFO)
		return
	end

	local width = math.min(content_width, math.floor(vim.o.columns * 0.9))
	local height = math.min(#lines, math.floor(vim.o.lines * 0.6))

	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = math.floor((vim.o.lines - height) / 2) - 1,
		col = math.floor((vim.o.columns - width) / 2),
		width = width,
		height = height,
		border = "rounded",
		style = "minimal",
		title = " Registers ",
		title_pos = "center",
		zindex = 50,
	})

	_win, _buf = win, buf

	vim.wo[win].cursorline = true
	vim.wo[win].wrap = false
	vim.wo[win].number = false
	vim.wo[win].spell = false
	vim.wo[win].signcolumn = "no"
	vim.wo[win].scrolloff = 0
	vim.wo[win].sidescrolloff = 0

	-- Paste the register under the cursor into the previously focused
	-- window, then close. Uses nvim_put so the register itself and the `=`
	-- prompt are left alone.
	local function paste()
		local name
		if _win and vim.api.nvim_win_is_valid(_win) then
			name = line_to_reg[vim.api.nvim_win_get_cursor(_win)[1]]
		end
		close()
		if not name then
			return
		end
		if vim.api.nvim_win_is_valid(prev_win) then
			vim.api.nvim_set_current_win(prev_win)
		end
		local ok, info = pcall(vim.fn.getreginfo, name)
		if ok and type(info) == "table" and info.regcontents then
			vim.api.nvim_put(info.regcontents, TYPE_CHAR[info.regtype] or "c", true, true)
		end
	end

	for _, key in ipairs({ "q", "<Esc>", "<C-c>" }) do
		vim.keymap.set("n", key, close, { buffer = buf, nowait = true, silent = true })
	end
	vim.keymap.set("n", "<CR>", paste, { buffer = buf, nowait = true, silent = true })

	-- Close when focus moves to another window (e.g. clicking elsewhere).
	vim.api.nvim_create_autocmd("WinLeave", {
		buffer = buf,
		callback = close,
	})
end

-- Yank history ring: whenever a yank writes a new item to register 0,
-- shift the numbered registers down (old 0 -> 1 -> ... -> 9; old 9 is
-- dropped). Letter registers and the normal delete behavior of 1-9 are
-- untouched. TextYankPost fires after the yank already replaced register
-- 0, so keep a one-deep snapshot of the previous contents. Call once at
-- startup.
function M.setup_register_ring()
	local last0 = vim.fn.getreginfo("0")
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = vim.api.nvim_create_augroup("register-shift", { clear = true }),
		callback = function()
			local e = vim.v.event
			if e.operator ~= "y" or (e.regname ~= "" and e.regname ~= "0") then
				return -- not a write to register 0
			end
			-- An empty register 0 has nothing to preserve; shifting then
			-- would clobber the delete history in 1-9.
			local old = last0.regcontents
			if old and #old > 0 and not (#old == 1 and old[1] == "") then
				for i = 9, 2, -1 do
					local info = vim.fn.getreginfo(tostring(i - 1))
					vim.fn.setreg(i, info.regcontents, info.regtype)
				end
				vim.fn.setreg("1", old, last0.regtype)
			end
			last0 = { regcontents = e.regcontents, regtype = e.regtype }
		end,
	})
end

return M
