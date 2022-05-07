-------------------------------------------------------------------------------
--    - Vimwiki API -
--    Represents module for accessing vimwiki specific functions for easier
--    creation of vimwiki reviews
-------------------------------------------------------------------------------

local M = {}

-- Normalizes passed vimwiki index
-- This is meant to be used on user input index where:
-- 0 = default vimwiki
-- 1 = first vimwiki
-- 2 = second vimwiki
-- etc..
function M.normalize_vimwiki_index(vimwiki_index)
	if vimwiki_index == 0 then
		local current_index = vim.fn["vimwiki#vars#get_bufferlocal"]("wiki_nr")
		if current_index < 0 then
			current_index = 0
		end
		return current_index + 1
	else
		return vimwiki_index
	end
end

-- Gets syntax of vimwiki based on passed index
function M.get_vimwiki_syntax(vimwiki_index)
	vimwiki_index = M.normalize_vimwiki_index(vimwiki_index)
	return vim.g.vimwiki_wikilocal_vars[vimwiki_index]["syntax"]
end

-- Gets extension of vimwiki based on passed index
function M.get_vimwiki_extension(vimwiki_index)
	vimwiki_index = M.normalize_vimwiki_index(vimwiki_index)
	return vim.g.vimwiki_wikilocal_vars[vimwiki_index]["ext"]
end

-- Gets syntax local variable from vimwiki
-- Useful for taking templates from vimwiki
function M.get_vimwiki_syntaxlocal(key, syntax)
	if not syntax then
		syntax = vim.fn["vimwiki#vars#get_wikilocal"]["syntax"]
	end
	return vim.fn["vimwiki#vars#get_syntaxlocal"](key, syntax)
end

return M
