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

-- lazy.nvim logs plugin-spec errors (e.g. a bad `import` target) as
-- notifications rather than failing startup or the exit code, so a broken
-- spec can sit silently until someone notices it in :messages by hand --
-- confirmed happening for real: `{ import = "lazyvim.plugins.lsp" }`
-- glob-imported a plain helper module (lsp/keymaps.lua) as if it were a
-- plugin spec, on every single startup, for as long as that import stood.
-- Catch that class of bug here instead of relying on someone noticing.
local spec_errors = {}
for _, notif in ipairs(require("lazy.core.config").spec.notifs) do
  if notif.level >= vim.log.levels.ERROR then
    table.insert(spec_errors, (notif.file and (notif.file .. ": ") or "") .. notif.msg)
  end
end

if #spec_errors > 0 then
  io.stderr:write("kapi-vim smoke test FAILED -- lazy.nvim reported plugin spec errors:\n" .. table.concat(spec_errors, "\n") .. "\n")
  vim.cmd("cquit 1")
end

-- LazyVim ships its own import-order check (fired on the VeryLazy autocmd,
-- via vim.g.lazyvim_check_order), but it only recognizes a spec module
-- literally named "lazyvim.plugins" as import #1 -- this repo replaces that
-- blanket import with per-category ones (lua/config/lazy.lua), so that
-- check always false-positives here and is disabled. It's also a plain
-- vim.notify call gated behind VeryLazy, which never fires in --headless
-- (no UI ever attaches to trigger it), so CI could never have seen it fire
-- either way. Verify the actual invariant it exists to enforce -- core
-- lazyvim.plugins.* imports before lazyvim.plugins.extras.* before our own
-- `plugins` -- directly against the resolved import list instead.
local order_errors = {}
do
  -- min/max per category, not first/last-seen -- a single misplaced import
  -- (e.g. landing in the middle of the extras list instead of before or
  -- after all of them) has to move a min or a max to be visible; tracking
  -- only "first extra" / "last core" missed exactly that case, confirmed
  -- empirically by moving `plugins` between two extras imports and seeing
  -- the then-current version of this check pass anyway.
  local core, extra, own = {}, {}, {}
  for i, m in ipairs(require("lazy.core.config").spec.modules) do
    if m:match("^lazyvim%.plugins%.extras%.") then
      extra.min, extra.max = math.min(extra.min or i, i), math.max(extra.max or i, i)
    elseif m == "plugins" then
      own.min, own.max = math.min(own.min or i, i), math.max(own.max or i, i)
    elseif m:match("^lazyvim%.plugins") then
      core.min, core.max = math.min(core.min or i, i), math.max(core.max or i, i)
    end
  end
  if core.max and extra.min and core.max > extra.min then
    table.insert(order_errors, "a lazyvim.plugins.extras.* import appears before a core lazyvim.plugins.* import")
  end
  if core.max and own.min and core.max > own.min then
    table.insert(order_errors, "the `plugins` import appears before a core lazyvim.plugins.* import")
  end
  if extra.max and own.min and extra.max > own.min then
    table.insert(order_errors, "the `plugins` import appears before a lazyvim.plugins.extras.* import")
  end
end

if #order_errors > 0 then
  io.stderr:write("kapi-vim smoke test FAILED -- lazy.nvim import order is wrong:\n" .. table.concat(order_errors, "\n") .. "\n")
  vim.cmd("cquit 1")
end

print("kapi-vim smoke test passed: startup clean, expected LSP binaries present (" .. table.concat(required_binaries, ", ") .. ")")
vim.cmd("qa!")
