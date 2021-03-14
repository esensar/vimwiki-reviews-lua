# Vimwiki reviews

Simple extension for [vimwiki](https://github.com/vimwiki/vimwiki) enabling weekly, monthly and yearly reviews.
Check out [VimL version](https://github.com/esensar/vimwiki-reviews) for Vim support.

**WORK IN PROGRESS!**

## Installation

Install using favourite plugin manager. This plugin depends on [plenary.nvim](https://github.com/nvim-lua/plenary.nvim).

## Usage

Plugin adds new commands:
- `VimwikiWeeklyReview`
- `VimwikiMonthlyReview`
- `VimwikiYearlyReview`

Bound to `<leader>wrw`, `<leader>wrm` and `<leader>wry` respectively.

Additionally, it adds commands for editing template used for reviews:
- `VimwikiWeeklyTemplate`
- `VimwikiMonthlyTemplate`
- `VimwikiYearlyTemplate`

Bound to `<leader>wrtw`, `<leader>wrtm` and `<leader>wrty` respectively.

Currently templates support `%date%` template which will be replaced with date of review.
