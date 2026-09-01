return {
  {
    'NeogitOrg/neogit',
    dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
    keys = { { '<leader>g', function() require('neogit').open() end, desc = 'Neogit' } },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufWinEnter',
    -- current_line_blame's eol virtual text on a wrapped line triggers a
    -- herdr redraw/ghosting bug; use `:Gitsigns blame_line` on demand instead
    keys = { { '<leader>gb', function() require('gitsigns').blame_line() end, desc = 'Blame Line' } },
  },
}

