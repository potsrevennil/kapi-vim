-- CI smoke test. Run after `Lazy! sync`, via:
-- <package>/bin/nvim --headless -S .github/scripts/smoke-test.lua
-- (the package's nvim already has -u/--cmd baked in via wrapperArgs, so no
-- extra flags are needed to load the config).
--
-- Confirms Neovim starts cleanly, that nixd/lua-language-server (the base
-- lsp/default.nix always includes, regardless of any toggle) resolve on
-- PATH, and, for whichever languages are named in $KAPI_VIM_LANGS
-- (comma-separated -- the same value used to build the package under test,
-- see .github/workflows/ci.yml), that language's LSP binary resolves too.
-- $KAPI_VIM_LANGS is unset for packages.lite (no languages enabled), so
-- only the base gets checked there.

local language_binaries = {
  python = "pylsp",
  shell = "bash-language-server",
  typst = "tinymist",
  c = "clangd",
  rust = "rust-analyzer", -- via rustup shim
  go = "gopls",
  -- config (prettierd/taplo/yaml-language-server) and js (nodejs) don't have
  -- one single obvious "the LSP binary" to check, and haskell/lean aren't
  -- exercised by any CI job yet -- add here once/if that changes.
}

local required_binaries = { "nixd", "lua-language-server" }

for lang in (os.getenv("KAPI_VIM_LANGS") or ""):gmatch("[^,]+") do
  local bin = language_binaries[lang]
  if bin then
    table.insert(required_binaries, bin)
  end
end

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

print("kapi-vim smoke test passed: startup clean, expected LSP binaries present (" .. table.concat(required_binaries, ", ") .. ")")
vim.cmd("qa!")
