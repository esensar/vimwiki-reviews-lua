-------------------------------------------------------------------------------
--    - Vimwiki reviews utilities -
-------------------------------------------------------------------------------

local api = require("vimwiki_reviews.vimwiki_api")
local Path = require("plenary.path")
local templates = require("vimwiki_reviews.templates")

local M = {}

-- Gets path to reviews dir of provided vimwiki (by index)
function M.get_reviews_dir(vimwiki_index)
	vimwiki_index = api.normalize_vimwiki_index(vimwiki_index)
	local vimwiki = vim.g.vimwiki_list[vimwiki_index]

	return vimwiki.path .. "reviews/"
end

-- Converts days to seconds
function M.days_to_seconds(days)
	return days * 24 * 60 * 60
end

-- Finds review template path for provided review type
function M.get_review_template_path(vimwiki_index, review_type)
	return M.get_review_filename(vimwiki_index, "template-" .. review_type)
end

-- Reads template for provided review type into current buffer
-- Uses overrides in form of files in reviews directory
-- Looks for file named template-{review_type}.ext:
--  - template-week.ext
--  - template-month.ext
--  - template-year.ext
-- Templates can use variables using %variable% syntax
-- Currently supported variables are:
--  - %date% (Puts different date based on review type)
function M.read_review_template_into_buffer(review_type)
	local template_path = M.get_review_template_path(0, review_type) -- 0 = current vimwiki
	local builder = templates.for_vimwiki(0) -- 0 = current vimwiki
	if vim.fn.filereadable(vim.fn.glob(template_path)) ~= 0 then
		vim.cmd("read " .. template_path)
		vim.cmd("0d")
	else
		if review_type == "week" then
			vim.fn.setline(1, builder.header(1, "%date% Weekly Review"))
		elseif review_type == "month" then
			vim.fn.setline(1, builder.header(1, "%date% Monthly Review"))
		elseif review_type == "year" then
			vim.fn.setline(1, builder.header(1, "%date% Yearly Review"))
		end
	end
end

-- Takes in passed review name and generates full path to it
function M.get_review_filename(vimwiki_index, name)
	local reviews_dir = M.get_reviews_dir(vimwiki_index)
	local ext = api.get_vimwiki_extension(vimwiki_index)
	return reviews_dir .. name .. ext
end

-- Returns true if file exists or is open in current buffer
function M.file_exists_or_open(file_name)
	local exists = Path:new(Path:new(file_name):expand()):exists()
	local open = vim.fn.bufwinnr(file_name) > 0
	return exists or open
end

-- Takes filename from full path
function M.get_filename_from_path(path)
	local _, filename, _ = string.match(path, "(.-)([^\\/]-%.?([^%.\\/]*))$")
	return filename
end

return M
