local M = {}

local current_timestamp = os.time() -- in seconds
current_timestamp = current_timestamp + 8 * 3600 -- UTC+8
local days_from_epoch = math.floor(current_timestamp / 86400)

function M.today_choice(list)
	local list_size = #list
	local selected_index = (days_from_epoch % list_size) + 1
	return list[selected_index]
end

return M
