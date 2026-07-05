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
  config = true; # generic formatter (prettierd) + TOML/YAML LSPs -- not markdown-specific
  python = true;
  shell = true;
  typst = true;
  c = true;
  rust = true;
  go = true;
  js = true;
  haskell = false;
  lean = false;
}
