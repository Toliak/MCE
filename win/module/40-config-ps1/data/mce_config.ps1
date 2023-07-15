# MenuComplete on Tab instead of Ctrl+Space
Set-PSReadLineKeyHandler Tab MenuComplete

function MakeConfigEasierUpdate() {
    git --git-dir "$MAKE_CONFIG_EASIER_PATH\.git" pull
}

function MakeConfigEasierVersion() {
    Get-Content -Path "$MAKE_CONFIG_EASIER_PATH\VERSION"
}
