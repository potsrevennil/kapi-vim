lua require('rust-tools-config')

command! RustSetInlayHints 
    \ lua require('rust-tools.inlay_hints').set_inlay_hints()

command! RustDisableInlayHints
    \ lua require('rust-tools.inlay_hints').disable_inlay_hints()

command! RustToggleInlayHints
    \ lua require('rust-tools.inlay_hints').toggle_inlay_hints()

command! RustRunnables
    \ lua require('rust-tools.runnables').runnables()

command! RustExpandMacro
    \ lua require('rust-tools.expand_macro').expand_macro()

command! RustMoveItemUp
    \ lua require('rust-tools.move_item').move_item(true)

command! RustMoveItemDown
    \ lua require('rust-tools.move_item').move_item(false)

command! RustHoverActions
    \ lua require('rust-tools.hover_actions').hover_actions()

command! RustOpenCargo
    \ lua require('rust-tools.open_cargo_toml').open_cargo_toml()

command! RustParentModule
    \ lua require('rust-tools.parent_module').parent_module()

command! RustJoinLines
    \ lua require('rust-tools.join_lines').join_lines()

let b:ale_fixers = ['analyzer', 'remove_trailing_lines', 'trim_whitespace']
let b:ale_linters = ['analyzer']
