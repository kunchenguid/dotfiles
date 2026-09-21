-- Keep yanked text when pasting over a visual selection
vim.keymap.set('x', 'p', [["_dP]], { desc = 'Paste without clobbering register' })
vim.keymap.set('n', '<leader>e', '<cmd>Oil<cr>', { desc = 'Open Oil file editor' })
