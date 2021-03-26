-------------------------------------------------------------------------------
--    - Vimwiki reviews extension library -
--    Main Lua file, API meant to be used by user
-------------------------------------------------------------------------------

local Path = require('plenary.path')
local scandir = require('plenary.scandir')
local utils = require('vimwiki_reviews.utils')
local api = require('vimwiki_reviews.vimwiki_api')
local templates = require('vimwiki_reviews.templates')

local M = {}

-- Edits weekly review template
function M.open_review_weekly_template(vimwiki_index)
  vim.cmd('edit ' .. utils.get_review_template_path(vimwiki_index, 'week'))
end

-- Edits monthly review template
function M.open_review_monthly_template(vimwiki_index)
  vim.cmd('edit ' .. utils.get_review_template_path(vimwiki_index, 'month'))
end

-- Edits yearly review template
function M.open_review_yearly_template(vimwiki_index)
  vim.cmd('edit ' .. utils.get_review_template_path(vimwiki_index, 'year'))
end

-- Open current week weekly review file
-- Created buffer is dated to Sunday of current week
-- Opens current week because Sunday is good time to do this review
function M.open_vimwiki_weekly_review(vimwiki_index, offset)
  local days_to_sunday = 7 - tonumber(os.date('%u'))
  local week_date = os.date('%Y-%m-%d', os.time() + utils.days_to_seconds(days_to_sunday + 7 * offset))
  local file_name = utils.get_review_filename(vimwiki_index, week_date .. '-week')
  local exists = utils.file_exists_or_open(file_name)
  vim.cmd('edit ' .. file_name)
  if (exists == false)
  then
    utils.read_review_template_into_buffer('week')
    vim.cmd('%substitute/%date%/' .. week_date)
  end
end


-- Open past month monthly review file
-- Created buffer is dated to previous month
-- Previous month is calculated in an erroneous way
-- 28 days are subtracted from current time to get previous month
function M.open_vimwiki_monthly_review(vimwiki_index, offset)
  local time = os.time()

  local year = tonumber(os.date('%Y', time))
  local month = tonumber(os.date('%m', time))

  local month_time = os.time {
    year = year,  
    -- os.time automatically handles overflows
    month = month + offset,
    day = tonumber(os.date('%d', time))
  }
  local month_date = os.date('%Y-%m', month_time)
  local file_name = utils.get_review_filename(vimwiki_index, month_date .. '-month')
  local exists = utils.file_exists_or_open(file_name)
  vim.cmd('edit ' .. file_name)
  if (exists == false)
  then
    utils.read_review_template_into_buffer('month')
    vim.cmd('%substitute/%date%/' .. os.date('%Y %B', month_time))
  end
end

-- Open past year yearly review file
-- Created buffer is dated to previous year
function M.open_vimwiki_yearly_review(vimwiki_index, offset)
  local year_date = (tonumber(os.date('%Y')) + offset)
  local file_name = utils.get_review_filename(vimwiki_index, year_date .. '-year')
  local exists = utils.file_exists_or_open(file_name)
  vim.cmd('edit ' .. file_name)
  if (exists == false)
  then
    utils.read_review_template_into_buffer('year')
    vim.cmd('%substitute/%date%/' .. year_date)
  end
end

-- Generates review index table
-- Takes arguments similar to all vimwiki calls 
-- (no args, or 1 arg representing vimwiki index)
function M.get_review_index(vimwiki_index)
  local reviews_dir = utils.get_reviews_dir(vimwiki_index)
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

  for _,entry in pairs(entries) do
    local filename = utils.get_filename_from_path(entry)
    local ext = api.get_vimwiki_extension(vimwiki_index)
    if (string.match(filename, '^%d*-year' .. ext .. '$'))
    then
      local year = string.match(filename, '(%d*)-year')
      if (index[year] == nil)
      then
        index[year] = {
          months = {}
        }
      end
      index[year].year = filename
    elseif (string.match(filename, '^%d*-%d*-month' .. ext .. '$'))
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
    elseif (string.match(filename, '^%d*-%d*-%d*-week' .. ext .. '$'))
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
function M.open_vimwiki_review_index(vimwiki_index)
  vim.cmd('edit ' .. utils.get_review_filename(vimwiki_index, 'reviews'))

  local index = M.get_review_index(vimwiki_index)

  local builder = templates.for_vimwiki(vimwiki_index)

  local lines = {
    builder.header(1, 'Reviews'),
    '',
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
    table.insert(lines, builder.header(2, year))
    table.insert(lines, '')
    if (index[year].year)
    then
      table.insert(lines, builder.list_item(builder.link(index[year].year, 'Yearly review')))
      table.insert(lines, '')
    end

    -- Sort months
    local months = {}
    for k in pairs(index[year].months) do table.insert(months, k) end
    table.sort(months, function(a, b) return a > b end)

    -- Add months
    for _, month in pairs(months) do
      local month_time = os.time {
        year = tonumber(year),
        month = tonumber(month),
        day = 1
      }
      local month_name = os.date('%B', month_time)
      table.insert(lines, builder.header(3, month_name))
      table.insert(lines, '')
      if (index[year].months[month].month)
      then
        table.insert(lines, builder.list_item(builder.link(index[year].months[month].month, 'Monthly review')))
      end

      -- Sort weeks
      local weeks = index[year].months[month].weeks
      local sorted = {}
      for k in pairs(weeks) do table.insert(sorted, k) end
      table.sort(sorted, function(a, b) return a > b end)

      -- Add weeks
      local count = tablelength(sorted)
      for _, week in pairs(sorted) do
        table.insert(lines, builder.list_item(builder.link(weeks[week], 'Week #' .. count .. ' Review')))
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
