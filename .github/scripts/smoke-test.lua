-- CI smoke test for the kapi-vim-bundle package. Run after `Lazy! sync`,
-- via: <bundle>/bin/nvim --headless -S .github/scripts/smoke-test.lua
-- (bundle's nvim already has -u/--cmd baked in via wrapperArgs, so no
-- extra flags are needed to load the config).
--
-- Checks that every LSP binary lua/plugins/lsp.lua enables by default
-- (mason = false, so these must come from PATH, i.e. from lsp/default.nix)
-- actually resolves. Excludes servers that are either disabled by default
-- (hls, needs enable_haskell) or not currently packaged by lsp/default.nix
-- at all (dockerls, jsonls) -- neither is a regression introduced by CI.

local required_binaries = {
  "bash-language-server", -- bashls
  "clangd",
  "gopls",
  "lua-language-server", -- lua_ls
  "nixd",
  "pylsp",
  "rust-analyzer", -- via rustup shim
  "taplo",
  "tinymist",
  "yaml-language-server",
}

local missing = {}
for _, exe in ipairs(required_binaries) do
  if vim.fn.executable(exe) == 0 then
    table.insert(missing, exe)
  end
end

if #missing > 0 then
  io.stderr:write("kapi-vim smoke test FAILED -- missing LSP binaries on PATH: " .. table.concat(missing, ", ") .. "\n")
  vim.cmd("cquit 1")
end

print("kapi-vim smoke test passed: startup clean, all expected LSP binaries present")
vim.cmd("qa!")
