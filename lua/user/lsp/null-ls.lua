local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            -- apply whatever logic you want (in this example, we'll only use null-ls)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
    })
end

local on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                lsp_formatting(bufnr)
            end,
        })
    end
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
-- local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/prettier-solidity/prettier-plugin-solidity
null_ls.setup {
  on_attach,
  debug = false,
  sources = {
    formatting.prettier.with {
      -- extra_filetypes = { "toml" },
      -- extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
      -- extra_args = {},
    },
    formatting.stylua,
    -- formatting.prismals,
    -- formatting.prismaFmt,
    -- formatting.black.with { extra_args = { "--fast" } },
    -- formatting.google_java_format,
    -- diagnostics.flake8,
  },
}
