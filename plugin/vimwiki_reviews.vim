command! -count=0 VimwikiWeeklyReview :lua require('vimwiki_reviews').vimwiki_weekly_review(<count>)
command! -count=0 VimwikiWeeklyTemplate :lua require('vimwiki_reviews').open_review_weekly_template(<count>)
command! -count=0 VimwikiMonthlyReview :lua require('vimwiki_reviews').vimwiki_monthly_review(<count>)
command! -count=0 VimwikiMonthlyTemplate :lua require('vimwiki_reviews').open_review_monthly_template(<count>)
command! -count=0 VimwikiYearlyReview :lua require('vimwiki_reviews').vimwiki_yearly_review(<count>)
command! -count=0 VimwikiYearlyTemplate :lua require('vimwiki_reviews').open_review_yearly_template(<count>)
command! -count=0 VimwikiReviewIndex :lua require('vimwiki_reviews').vimwiki_review_index(<count>)

nnoremap <Leader>wrw <Cmd>lua require('vimwiki_reviews').vimwiki_weekly_review(vim.v.count)<CR>
nnoremap <Leader>wrtw <Cmd>lua require('vimwiki_reviews').open_review_weekly_template(vim.v.count)<CR>
nnoremap <Leader>wrm <Cmd>lua require('vimwiki_reviews').vimwiki_monthly_review(vim.v.count)<CR>
nnoremap <Leader>wrtm <Cmd>lua require('vimwiki_reviews').open_review_monthly_template(vim.v.count)<CR>
nnoremap <Leader>wry <Cmd>lua require('vimwiki_reviews').vimwiki_yearly_review(vim.v.count)<CR>
nnoremap <Leader>wrty <Cmd>lua require('vimwiki_reviews').open_review_yearly_template(vim.v.count)<CR>
nnoremap <Leader>wri <Cmd>lua require('vimwiki_reviews').vimwiki_review_index(vim.v.count)<CR>
