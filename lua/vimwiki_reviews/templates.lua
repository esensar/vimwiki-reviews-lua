-------------------------------------------------------------------------------
--    - Utility functions for using templates provided by vimwiki -
-------------------------------------------------------------------------------
local api = require('vimwiki_reviews.vimwiki_api')

local M = {}

-- Returns an object with template functions 
-- matching syntax of vimwiki with passed index
function M.for_vimwiki(vimwiki_index) 
	syntax = api.get_vimwiki_syntax(vimwiki_index)
	return M.for_syntax(syntax)
end

-- Returns an object with template functions matching passed syntax
function M.for_syntax(vimwiki_syntax) 
	local syntaxed = {}

	-- Returns string representing header of passed level in correct syntax
	function syntaxed.header(level, text)
		local template = api.get_vimwiki_syntaxlocal('rxH' .. level .. '_Template', syntax)
		local result = template:gsub('__Header__', text)
		return result
	end

	-- Returns string representing link with passed link and text in correct syntax
	function syntaxed.link(link, text)
		local template = api.get_vimwiki_syntaxlocal('WikiLinkTemplate2', syntax)
		if syntax == 'markdown'
			then
			template = api.get_vimwiki_syntaxlocal('Weblink1Template', syntax)
		end
		local result = template:gsub('__LinkUrl__', link):gsub('__LinkDescription__', text)
		return result
	end

	-- Returns string representing list item with passed text in correct syntax
	function syntaxed.list_item(text)
		local bullet = vim.fn['vimwiki#lst#default_symbol']() .. ' '
		local margin = vim.fn['vimwiki#lst#get_list_margin']()
		local item_margin = string.rep(' ', margin)

		return margin .. bullet .. text
	end

	return syntaxed
end

return M
