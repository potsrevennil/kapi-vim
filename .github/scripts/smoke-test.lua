-- CI smoke test for the kapi-vim-lite package. Run after `Lazy! sync`, via:
-- <lite>/bin/nvim --headless -S .github/scripts/smoke-test.lua
-- (lite's nvim already has -u/--cmd baked in via wrapperArgs, so no extra
-- flags are needed to load the config).
--
-- lite has every default-on language toggle (markdown/python/shell/typst/
-- c/rust/go) off, so the only LSP binaries it guarantees are the ones
-- lsp/default.nix always includes regardless of toggles: nixd and
-- lua-language-server. Per-language binaries (pylsp, gopls, etc.) belong to
-- the heavier default/bundle packages tested in a separate workflow.

local required_binaries = {
  "lua-language-server", -- lua_ls
  "nixd",
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

print("kapi-vim smoke test passed: startup clean, base LSP binaries present")
vim.cmd("qa!")
