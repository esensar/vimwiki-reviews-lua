" -----------------------------------------------------------------------------
"     - Vimwiki extensions for working with weekly/monthly/yearly reviews -
"
"     DEPENDS ON VIMWIKI PLUGIN
" -----------------------------------------------------------------------------

if exists('g:loaded_vimwiki_reviews') || &compatible
  finish
endif
let g:loaded_vimwiki_reviews = 1

command! -count=0 VimwikiWeeklyReview :lua require('vimwiki_reviews').open_vimwiki_weekly_review(<count>, 0)
command! -count=0 VimwikiNextWeeklyReview :lua require('vimwiki_reviews').open_vimwiki_weekly_review(<count>, 1)
command! -count=0 VimwikiPrevWeeklyReview :lua require('vimwiki_reviews').open_vimwiki_weekly_review(<count>, -1)
command! -count=0 VimwikiWeeklyTemplate :lua require('vimwiki_reviews').open_review_weekly_template(<count>)
command! -count=0 VimwikiMonthlyReview :lua require('vimwiki_reviews').open_vimwiki_monthly_review(<count>, 0)
command! -count=0 VimwikiNextMonthlyReview :lua require('vimwiki_reviews').open_vimwiki_monthly_review(<count>, 1)
command! -count=0 VimwikiPrevMonthlyReview :lua require('vimwiki_reviews').open_vimwiki_monthly_review(<count>, -1)
command! -count=0 VimwikiMonthlyTemplate :lua require('vimwiki_reviews').open_review_monthly_template(<count>)
command! -count=0 VimwikiYearlyReview :lua require('vimwiki_reviews').open_vimwiki_yearly_review(<count>, 0)
command! -count=0 VimwikiNextYearlyReview :lua require('vimwiki_reviews').open_vimwiki_yearly_review(<count>, 1)
command! -count=0 VimwikiPrevYearlyReview :lua require('vimwiki_reviews').open_vimwiki_yearly_review(<count>, -1)
command! -count=0 VimwikiYearlyTemplate :lua require('vimwiki_reviews').open_review_yearly_template(<count>)
command! -count=0 VimwikiReviewIndex :lua require('vimwiki_reviews').open_vimwiki_review_index(<count>)

nnoremap <Plug>VimwikiWeeklyReview <Cmd>lua require('vimwiki_reviews').open_vimwiki_weekly_review(vim.v.count, 0)<CR>
nnoremap <Plug>VimwikiNextWeeklyReview <Cmd>lua require('vimwiki_reviews').open_vimwiki_weekly_review(vim.v.count, 1)<CR>
nnoremap <Plug>VimwikiPrevWeeklyReview <Cmd>lua require('vimwiki_reviews').open_vimwiki_weekly_review(vim.v.count, -1)<CR>
nnoremap <Plug>VimwikiWeeklyTemplate <Cmd>lua require('vimwiki_reviews').open_review_weekly_template(vim.v.count)<CR>
nnoremap <Plug>VimwikiMonthlyReview <Cmd>lua require('vimwiki_reviews').open_vimwiki_monthly_review(vim.v.count, 0)<CR>
nnoremap <Plug>VimwikiNextMonthlyReview <Cmd>lua require('vimwiki_reviews').open_vimwiki_monthly_review(vim.v.count, 1)<CR>
nnoremap <Plug>VimwikiPrevMonthlyReview <Cmd>lua require('vimwiki_reviews').open_vimwiki_monthly_review(vim.v.count, -1)<CR>
nnoremap <Plug>VimwikiMonthlyTemplate <Cmd>lua require('vimwiki_reviews').open_review_monthly_template(vim.v.count)<CR>
nnoremap <Plug>VimwikiYearlyReview <Cmd>lua require('vimwiki_reviews').open_vimwiki_yearly_review(vim.v.count, 0)<CR>
nnoremap <Plug>VimwikiNextYearlyReview <Cmd>lua require('vimwiki_reviews').open_vimwiki_yearly_review(vim.v.count, 1)<CR>
nnoremap <Plug>VimwikiPrevYearlyReview <Cmd>lua require('vimwiki_reviews').open_vimwiki_yearly_review(vim.v.count, -1)<CR>
nnoremap <Plug>VimwikiYearlyTemplate <Cmd>lua require('vimwiki_reviews').open_review_yearly_template(vim.v.count)<CR>
nnoremap <Plug>VimwikiReviewIndex <Cmd>lua require('vimwiki_reviews').open_vimwiki_review_index(vim.v.count)<CR>


if !exists('g:vimwiki_reviews_disable_maps') || !g:vimwiki_reviews_disable_maps
	nmap <Leader>wrww <Plug>VimwikiWeeklyReview
	nmap <Leader>wrwn <Plug>VimwikiNextWeeklyReview
	nmap <Leader>wrwp <Plug>VimwikiPrevWeeklyReview
	nmap <Leader>wrtw <Plug>VimwikiWeeklyTemplate
	nmap <Leader>wrmm <Plug>VimwikiMonthlyReview
	nmap <Leader>wrmn <Plug>VimwikiNextMonthlyReview
	nmap <Leader>wrmp <Plug>VimwikiPrevMonthlyReview
	nmap <Leader>wrtm <Plug>VimwikiMonthlyTemplate
	nmap <Leader>wryy <Plug>VimwikiYearlyReview
	nmap <Leader>wryn <Plug>VimwikiNextYearlyReview
	nmap <Leader>wryp <Plug>VimwikiPrevYearlyReview
	nmap <Leader>wrty <Plug>VimwikiYearlyTemplate
	nmap <Leader>wri <Plug>VimwikiReviewIndex
endif
