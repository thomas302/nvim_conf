require("config.lazy")

require("mason").setup()

require("mason-lspconfig").setup()

vim.g.python3_host_prog = os.getenv("PYTHON_PATH")

vim.opt.relativenumber = true

vim.wo.number = true

vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

local cmp = require'cmp'
  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),

    sources = cmp.config.sources({ 
        { name = 'path' },                              -- file paths
        { name = 'nvim_lsp', keyword_length = 3},
        { name = 'luasnip', keyword_length = 2}, 
        { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
        { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
        { name = 'buffer', keyword_length = 2 },
        { name = 'render-markdown' }
    })
  })

 cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  -- require'lspconfig'.jedi_language_server.setup{}
  require('lspconfig').basedpyright.setup({})

  require('java').setup()
  require'lspconfig'.jdtls.setup({})

  require'lspconfig'.julials.setup{}
  require'lspconfig'.koto.setup{}
  require'lspconfig'.rust_analyzer.setup{}




vim.cmd([[
nnoremap <C-x> gt
nnoremap <C-z> gT
]])

vim.api.nvim_create_autocmd("FileType", {
  pattern = "koto",
  callback = function()
    vim.lsp.start({
      cmd = { "koto-ls" },
      root_dir = vim.fn.getcwd(),
    })
  end
})

-- require('platformio').setup({
-- lsp = "ccls" --default: ccls, other option: clangd
                 -- If you pick clangd, it also creates compile_commands.json
--})

require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>cs', builtin.colorscheme, { desc = 'Telescope Available colorshemes' })

vim.keymap.set('n', '<leader>fr', function() builtin.lsp_references() end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fd', function() builtin.lsp_definitions() end, { noremap = true, silent = true })

-- Run the current unsaved buffer directly through Python
vim.keymap.set('n', '<leader>rp', ':w !python<CR>', { desc = 'Run unsaved buffer with Python' })

vim.keymap.set('n', '<leader>rpo', function()
  -- 1. Grab all lines from the current active buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  
  -- 2. Pass the lines directly to Python via system standard input
  local output = vim.fn.system('python', lines)
  
  -- 3. Open a new horizontal split window
  vim.cmd('new')
  
  -- 4. Mark the new buffer as a temporary scratchpad
  local new_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = new_buf })
  vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = new_buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = new_buf })
  
  -- 5. Split the output string into individual lines and write them
  local output_lines = vim.split(output, '\n')
  vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, output_lines)
  end, { desc = 'Run buffer in Python and pipe output to new split' }
)


vim.opt.linebreak = true

local function goyo_enter()
  vim.keymap.set("n", "j", "gj", { buffer = 0 })
  vim.keymap.set("n", "k", "gk", { buffer = 0 })
end

-- Function when leaving Goyo
local function goyo_leave()
  vim.keymap.del("n", "j", { buffer = 0 })
  vim.keymap.del("n", "k", { buffer = 0 })
end

-- Autocommands for Goyo events
vim.api.nvim_create_autocmd("User", {
  pattern = "GoyoEnter",
  callback = goyo_enter,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "GoyoLeave",
  callback = goyo_leave,
})

-- ==========================================================================
-- GOOGLE DOCS-STYLE WORD COUNTER CONFIGURATION
-- ==========================================================================

-- Namespace block to avoid any early startup collisions
_G.GDocs = {
  enabled = false,
  
  count = function()
    local lines = {}
    local mode = vim.api.nvim_get_mode().mode

    if mode:match("[vV]") then
      local _, s_line, _, _ = unpack(vim.fn.getpos("v"))
      local _, e_line, _, _ = unpack(vim.fn.getpos("."))
      if s_line > e_line then s_line, e_line = e_line, s_line end
      lines = vim.api.nvim_buf_get_lines(0, s_line - 1, e_line, false)
    else
      lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    end

    local word_count = 0
    for _, line in ipairs(lines) do
      local normalized_line = line:gsub("([%.,])", " ")
      for _ in string.gmatch(normalized_line, "[^%s]+") do
        word_count = word_count + 1
      end
    end

    return "📝 " .. word_count .. " words"
  end
}

-- Create the user toggle command
vim.api.nvim_create_user_command("WCToggle", function()
  _G.GDocs.enabled = not _G.GDocs.enabled
  -- Safe call execution protects the statusline redraw pipeline
  pcall(function() require("lualine").refresh() end)
  print("Google Docs Word Count: " .. (_G.GDocs.enabled and "ON" or "OFF"))
end, {})


-- Create an autocommand group for Goyo integration
-- local goyo_group = vim.api.nvim_create_augroup("GoyoLualine", { clear = true })
-- 
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "GoyoEnter",
--   group = goyo_group,
--   callback = function()
--     require("lualine").hide({ place = { "statusline", "tabline", "winbar" }, unhide = false })
--   end,
-- })
-- 
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "GoyoLeave",
--   group = goyo_group,
--   callback = function()
--     require("lualine").hide({ place = { "statusline", "tabline", "winbar" }, unhide = true })
--   end,
-- })
