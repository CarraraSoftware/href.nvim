local M = {};

local _config = {};

function M.setup(config)
    _config = config or {};
    local open_file_cmd = _config.open_file_cmd or "<leader>ol"
    local preview_file_cmd = _config.preview_file_cmd or "<leader>pl"
    vim.api.nvim_set_keymap("n", open_file_cmd, '', {
        callback = M.click_link,
    });
    vim.api.nvim_set_keymap("n", preview_file_cmd, '', {
        callback = M.preview_link,
    });
end

function M.preview_link()
    local link = M.find_link();
    M.preview_file(link);
end

function M.click_link()
    local link = M.find_link();
    M.open_file(link);
end

function M.find_link()
    local cursor = vim.api.nvim_win_get_cursor(0);
    local row = cursor[1];
    local col = cursor[2];
    local line = vim.fn.getline(row);

    local start = -1;
    local final = -1;

    start = M.find_start(line, col+1);
    if start == -1 then
        error("Link: '@' not found: Expected format @[<file_path>]", 2);
    end

    local idx = start + 1;
    if string.sub(line, idx, idx) ~= '[' then
        error("Link: missing '[' after '@': Expected format @[<file_path>]", 2);
    end

    idx = idx + 1;
    start = idx;
    final = M.find_final(line, idx);
    if final == -1 then
        error("Link: missing ']': Expected format @[<file_path>]", 2);
    end

    local link = string.sub(line, start, final);
    return link
end

function M.find_start(line, idx)
    while true do
        local cur = string.sub(line, idx, idx);
        if cur == '@' then
            return idx;
        end

        idx = idx - 1;

        if idx == 0 then
            return -1;
        end
    end
end

function M.find_final(line, idx)
    while true do
        local cur = string.sub(line, idx, idx);
        if cur == '\n' then
            return -1;
        end

        if cur == ']' then
            return idx - 1;
        end

        idx = idx + 1;
    end
end

function M.open_file(file)
    local buf_id = vim.fn.bufnr(file);
    if buf_id ~= -1 then
        vim.api.nvim_buf_delete(buf_id, { force = true });
    end
    vim.cmd.edit(file);
end

function M.preview_file(file)
	local width = math.floor(vim.o.columns * 0.9);
	local height = math.floor(vim.o.lines * 0.9);
	local col = math.floor((vim.o.columns - width) / 2);
	local row = math.floor((vim.o.lines - height) / 2);
    local buf = vim.fn.bufadd(file);
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
        title = file,
        title_pos = "center",
	}
	local win = vim.api.nvim_open_win(buf, true, win_config)
	return { buf = buf, win = win }
end

return M;
