# Single source of truth for every per-language LSP/toolchain toggle this
# flake exposes. Each attribute name becomes `enable_<name>` on both
# `wrapKapiVim` (flake.nix) and `lsp/default.nix`'s callPackage signature,
# and its value is that toggle's default.
#
# Intentionally does NOT import <nixpkgs>/pkgs: flake.nix needs just the
# name list (to derive "every language off" for packages.lite) without
# evaluating a full package set to get it; lsp/default.nix only needs it
# for `? default` values in its own signature -- the actual package attrs
# (prettierd, gopls, etc.) stay declared where they always were.
{
  # Editor-wide: useful on any file, independent of a project's toolchain,
  # and small. On by default.
  config = true; # generic formatter (prettierd) + TOML/YAML LSPs -- not markdown-specific
  shell = true;
  typst = true;
  js = true; # just nodejs; commitlint pulls it into the closure regardless

  # Project toolchains: the server, formatter and linter have to match the
  # project's own compiler/runtime and its CI (HLS <-> GHC, gopls <-> go,
  # black/clang-format <-> the versions CI checks with, ...), so each
  # project provides them from its flake devShell and direnv puts them
  # first on PATH. The Lua config only names the tools and stays quiet when
  # one is missing (Neovim skips non-executable servers; conform.lua and
  # none-ls.lua are set up to match). Off by default; turn one on for a
  # machine without project flakes with `kapi-vim.override { enable_go =
  # true; }`, or `KAPI_VIM_LANGS=go nix run --impure .#bundle`.
  python = false;
  c = false;
  rust = false;
  go = false;
  haskell = false;
  lean = false;
}
