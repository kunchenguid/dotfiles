return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- main-branch API: install parsers, then enable highlighting per filetype
      require('nvim-treesitter').install({
        'markdown',
        'markdown_inline',
        'html',
        'latex',
        'typst',
        'yaml',
      })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'markdown', 'html', 'tex', 'typst', 'yaml' },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}
