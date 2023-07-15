# MenuComplete on Tab instead of Ctrl+Space
Set-PSReadLineKeyHandler Tab MenuComplete

function MakeConfigEasierVersion() {
    Get-Content -Path "$MAKE_CONFIG_EASIER_PATH\VERSION"
}
