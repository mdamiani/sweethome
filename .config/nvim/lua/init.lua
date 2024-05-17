-- LSP configuration
local cmp = require('cmp')
cmp.setup {
  sources = {
    { name = 'nvim_lsp',
        entry_filter = function(entry)
            -- Disable snippets
            local cmp = require('cmp')
            return entry:get_kind() ~= cmp.lsp.CompletionItemKind.Snippet and
                   entry:get_kind() ~= cmp.lsp.CompletionItemKind.Keyword
        end
    },
    { name = 'buffer', options = {
        get_bufnrs = function()
            return vim.api.nvim_list_bufs()
        end
       }
    },
    { name = 'nvim_lsp_signature_help' },
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
    -- If nothing is selected (including preselections) add a newline as usual.
    -- If something has explicitly been selected by the user, select it.
    ["<CR>"] = cmp.mapping({
      -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm({ select = true }),
      c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    }),
  }),
  -- snippet = { expand = function() end },
  snippet = {
    -- We recommend using *actual* snippet engine.
    -- It's a simple implementation so it might not work in some of the cases.
    expand = function(args)
      unpack = unpack or table.unpack
      local line_num, col = unpack(vim.api.nvim_win_get_cursor(0))
      local line_text = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)[1]
      local indent = string.match(line_text, '^%s*')
      local replace = vim.split(args.body, '\n', true)
      local surround = string.match(line_text, '%S.*') or ''
      local surround_end = surround:sub(col)

      replace[1] = surround:sub(0, col - 1)..replace[1]
      replace[#replace] = replace[#replace]..(#surround_end > 1 and ' ' or '')..surround_end
      if indent ~= '' then
        for i, line in ipairs(replace) do
          replace[i] = indent..line
        end
      end

      vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, replace)
    end,
  },
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Turn snippets off at LSP level
capabilities.textDocument.completion.completionItem.snippetSupport = false

require('lspconfig')['zls'].setup {
    capabilities = capabilities,
}

function setAutoCmp(mode)
  if mode then
    cmp.setup({
      completion = {
        autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }
      }
    })
  else
    cmp.setup({
      completion = {
        autocomplete = false
      }
    })
  end
end
--setAutoCmp(false)

-- enable/disable automatic completion popup on typing
vim.cmd('command AutoCmpOn lua setAutoCmp(true)')
vim.cmd('command AutoCmpOff lua setAutoCmp(false)')

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300)
