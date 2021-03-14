-------------------------------------------------------------------------------
--    - Vimwiki reviews extension library -
-------------------------------------------------------------------------------

local Path = require('plenary.path')
local scandir = require('plenary.scandir')

-- Gets path to reviews dir of provided vimwiki (by index)
local function get_reviews_dir(vimwiki_index)
	local vimwiki = {}
	if (vimwiki_index == 0)
		then
		local current_index = vim.fn['vimwiki#vars#get_bufferlocal']('wiki_nr')
		if (current_index < 0)
			then
			current_index = 0
		end
		vimwiki = vim.g.vimwiki_list[current_index + 1]
	else
		vimwiki = vim.g.vimwiki_list[vimwiki_index]
	end

	return vimwiki.path .. 'reviews/'
end

-- Finds review template path for provided review type
local function get_review_template_path(vimwiki_reviews_path, review_type)
	return vimwiki_reviews_path .. 'template-' .. review_type .. '.md'
end

-- Reads template for provided review type into current buffer
-- Uses overrides in form of files in reviews directory
-- Looks for file named template-{review_type}.md:
--  - template-week.md
--  - template-month.md
--  - template-year.md
-- Templates can use variables using %variable% syntax
-- Currently supported variables are:
--  - %date% (Puts different date based on review type)
local function read_review_template_into_buffer(vimwiki_reviews_path, review_type)
	local template_path = get_review_template_path(vimwiki_reviews_path, review_type)
	if (vim.fn.filereadable(vim.fn.glob(template_path)) ~= 0)
		then
		vim.cmd('read ' .. template_path)
		vim.cmd('0d')
	else
		if (review_type == 'week')
			then
			vim.fn.setline(1, '# %date% Weekly Review')
		elseif (review_type == 'month')
			then
			vim.fn.setline(1, '# %date% Monthly Review')
		elseif (review_type == 'year')
			then
			vim.fn.setline(1, '# %date% Yearly Review')
		end
	end
end

local function file_exists_or_open(file_name)
	local exists = Path:new(Path:new(file_name):expand()):exists()
	local open = vim.fn.bufwinnr(file_name) > 0
	return exists or open
end

local function get_filename_from_path(path)
	local _, filename, _ = string.match(path, "(.-)([^\\/]-%.?([^%.\\/]*))$")
	return filename
end

-------------------------------------------------------------------------------
--    - Public API -
-------------------------------------------------------------------------------
local M = {}

-- Edits weekly review template
function M.open_review_weekly_template(vimwiki_index)
	local reviews_dir = get_reviews_dir(vimwiki_index)
	vim.cmd('edit ' .. get_review_template_path(reviews_dir, 'week'))
end

-- Edits monthly review template
function M.open_review_monthly_template(vimwiki_index)
	local reviews_dir = get_reviews_dir(vimwiki_index)
	vim.cmd('edit ' .. get_review_template_path(reviews_dir, 'month'))
end

-- Edits yearly review template
function M.open_review_yearly_template(vimwiki_index)
	local reviews_dir = get_reviews_dir(vimwiki_index)
	vim.cmd('edit ' .. get_review_template_path(reviews_dir, 'year'))
end

-- Open current week weekly review file
-- Created buffer is dated to Sunday of current week
-- Opens current week because Sunday is good time to do this review
function M.vimwiki_weekly_review(vimwiki_index)
	local reviews_dir = get_reviews_dir(vimwiki_index)
	local days_to_sunday = 7 - tonumber(os.date('%u'))
	local week_date = os.date('%Y-%m-%d', os.time() + days_to_sunday * 24 * 60 * 60)
	local file_name = reviews_dir .. week_date .. '-week.md'
	local exists = file_exists_or_open(file_name)
	vim.cmd('edit ' .. file_name)
	if (exists == false)
		then
		read_review_template_into_buffer(reviews_dir, 'week')
		vim.cmd('%substitute/%date%/' .. week_date)
	end
end


-- Open past month monthly review file
-- Created buffer is dated to previous month
-- Previous month is calculated in an erroneous way
-- 28 days are subtracted from current time to get previous month
function M.vimwiki_monthly_review(vimwiki_index)
	local reviews_dir = get_reviews_dir(vimwiki_index)
	local month_time = os.time() - 28 * 24 * 60 * 60
	local month_date = os.date('%Y-%m', month_time)
	local file_name = reviews_dir .. month_date .. '-month.md'
	local exists = file_exists_or_open(file_name)
	vim.cmd('edit ' .. file_name)
	if (exists == false)
		then
		read_review_template_into_buffer(reviews_dir, 'month')
		vim.cmd('%substitute/%date%/' .. os.date('%Y %B', month_time))
	end
end

-- Open past year yearly review file
-- Created buffer is dated to previous year
function M.vimwiki_yearly_review(vimwiki_index)
	local reviews_dir = get_reviews_dir(vimwiki_index)
	local year_date = (tonumber(os.date('%Y')) - 1)
	local file_name = reviews_dir .. year_date .. '-year.md'
	local exists = file_exists_or_open(file_name)
	vim.cmd('edit ' .. file_name)
	if (exists == false)
		then
		read_review_template_into_buffer(reviews_dir, 'year')
		vim.cmd('%substitute/%date%/' .. year_date)
	end
end

-- Generates review index table
-- Takes arguments similar to all vimwiki calls 
-- (no args, or 1 arg representing vimwiki index)
function M.get_review_index(vimwiki_index)
	local reviews_dir = get_reviews_dir(vimwiki_index)
	local reviews_path = Path:new(reviews_dir):expand()

	local entries = scandir.scan_dir(
		reviews_path,
		{
			hidden = false,
			add_dirs = false,
			respect_gitignore = true,
			depth = 1
		})

	local index = {}
	-- TODO better default values handling
	for _,entry in pairs(entries) do
		local filename = get_filename_from_path(entry)
		if (string.match(filename, '^%d*-year.md$'))
			then
			local year = string.match(filename, '(%d*)-year')
			if (index[year] == nil)
				then
				index[year] = {
					months = {}
				}
			end
			index[year].year = filename
		elseif (string.match(filename, '^%d*-%d*-month.md$'))
			then
			local year = string.match(filename, '(%d*)-%d*-month')
			local month = string.match(filename, '(%d*)-month')
			if (index[year] == nil)
				then
				index[year] = {
					months = {}
				}
			end
			if (index[year].months[month] == nil)
				then
				index[year].months[month] = {
					weeks = {}
				}
			end
			index[year].months[month].month = filename
		elseif (string.match(filename, '^%d*-%d*-%d*-week.md$'))
			then
			local year = string.match(filename, '(%d*)-%d*-%d*-week')
			local month = string.match(filename, '(%d*)-%d*-week')
			local week = string.match(filename, '(%d*)-week')
			if (index[year] == nil)
				then
				index[year] = {
					months = {}
				}
			end
			if (index[year].months[month] == nil)
				then
				index[year].months[month] = {
					weeks = {}
				}
			end
			index[year].months[month].weeks[week] = filename
		end
	end

	return index
end

-- Open reviews index file
function M.vimwiki_review_index(vimwiki_index)
	local reviews_dir = get_reviews_dir(vimwiki_index)
	vim.cmd('edit ' .. reviews_dir .. 'reviews.md')

	local index = M.get_review_index(vimwiki_index)

	local lines = {
		'# Reviews',
		'',
	}

	local month_names = {
		'January',
		'February',
		'March',
		'April',
		'May',
		'June',
		'July',
		'August',
		'September',
		'October',
		'November',
		'December'
	}

	-- Sort index by year
	local years = {}
	for k in pairs(index) do table.insert(years, k) end
	table.sort(years, function(a, b) return a > b end)

	local tablelength = function(T)
		local count = 0
		for _ in pairs(T) do count = count + 1 end
		return count
	end

	-- Add years
	for _, year in pairs(years) do
		table.insert(lines, '## ' .. year)
		table.insert(lines, '')
		if (index[year].year)
			then
			table.insert(lines, '- [Yearly review](' .. index[year].year .. ')')
			table.insert(lines, '')
		end

		-- Sort months
		local months = {}
		for k in pairs(index[year].months) do table.insert(months, k) end
		table.sort(months, function(a, b) return a > b end)

		-- Add months
		for _, month in pairs(months) do
			table.insert(lines, '### ' .. month_names[tonumber(month)])
			table.insert(lines, '')
			if (index[year].months[month].month)
				then
				table.insert(lines, '- [Monthly review](' .. index[year].months[month].month .. ')')
			end

			-- Sort weeks
			local weeks = index[year].months[month].weeks
			local sorted = {}
			for k in pairs(weeks) do table.insert(sorted, k) end
			table.sort(sorted, function(a, b) return a > b end)

			-- Add weeks
			local count = tablelength(sorted)
			for _, week in pairs(sorted) do
				table.insert(lines, '- [Week #' .. count .. ' Review](' .. weeks[week] .. ')')
				count = count - 1
			end

			table.insert(lines, '')
		end
	end

	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})  -- Clear out
	vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)  -- Put new contents
end

return M
