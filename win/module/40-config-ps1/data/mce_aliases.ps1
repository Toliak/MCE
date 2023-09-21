function New-SymLink {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$SourcePath,

        [Parameter(Mandatory=$true)]
        [string]$TargetPath,

        [Parameter(Mandatory=$false)]
        [Alias("s")]
        [Switch]$IsSymlink
    )

    New-Item -Type SymbolicLink  -Value $SourcePath -Path $TargetPath
}

function New-AdminTerminal() {
    if (Get-Command wt -errorAction SilentlyContinue) {
        # Open Windows Terminal
        # https://learn.microsoft.com/en-us/windows/terminal/command-line-arguments?tabs=windows#passing-an-argument-to-the-default-shell

        # Create a new process object that starts PowerShell
        $newProcess = new-object System.Diagnostics.ProcessStartInfo "wt";
        $newProcess.Arguments = @("new-tab PowerShell -NoExit -c cd `"$pwd`"")
        $newProcess.WorkingDirectory = $pwd;
        $newProcess.Verb = "runAs";
        [System.Diagnostics.Process]::Start($newProcess);
    } else {
        # Open Powershell
        # https://learn.microsoft.com/en-us/archive/blogs/virtual_pc_guy/a-self-elevating-powershell-script
        
        # Create a new process object that starts PowerShell
        $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
        $newProcess.Arguments = @("-NoExit", "-Command", "cd `"$pwd`"")
        $newProcess.WorkingDirectory = $pwd;
        $newProcess.Verb = "runAs";
        [System.Diagnostics.Process]::Start($newProcess);
    }
}

function Show-RandomAmongus() {
    $colors = ("red", "cyan", "yellow", "white", "green", "magenta")
    $color = $colors[$( Get-Random -Minimum 0 -Maximum $colors.Length )]

    Write-Host -ForegroundColor $color '             sWWWWWWWWWWWWWWss      '
    Write-Host -ForegroundColor $color '         sWWWWWWsssssssssssWWWWWWWs  '
    Write-Host -ForegroundColor $color '        WWss                 sWWWWss '
    Write-Host -ForegroundColor $color '       sWs       ssWWWWWWWWWWWWWWWWWss   '
    Write-Host -ForegroundColor $color '       sWs      sWWWs             sWWWs'
    Write-Host -ForegroundColor $color '  sWWWWWWWs     sWWWs              sWWWs'
    Write-Host -ForegroundColor $color ' sWWsssWWWWs    sWWWs              sWWWs'
    Write-Host -ForegroundColor $color ' sWW    WWs      sWWWssssssssssssssWWWs '
    Write-Host -ForegroundColor $color ' sWW    WWs       sWWWWWWWWWWWWWWWWWWs  '
    Write-Host -ForegroundColor $color ' sWW    WWs                       sWW'
    Write-Host -ForegroundColor $color ' sWW    WWs                       sWs'
    Write-Host -ForegroundColor $color ' sWW    WWs                       sWs'
    Write-Host -ForegroundColor $color ' sWW    WWs                       sWs'
    Write-Host -ForegroundColor $color ' sWW    WWs       ssWWWWWss       sWs'
    Write-Host -ForegroundColor $color '  sssWWWWWs      sWWWWsWWWWs      sWW  '
    Write-Host -ForegroundColor $color '        WWs      WWs     sWW      sWW  '
    Write-Host -ForegroundColor $color '        WWs      WWs     sWW      sWW  '
    Write-Host -ForegroundColor $color '        sWWWsssWWWss     ssWWWsssWWWs  '
    Write-Host -ForegroundColor $color '         ssWWWWWsss       sssWWWWWss   '
}

function New-AmongusTerminal() {
    Show-RandomAmongus
    New-AdminTerminal
}

function gitadog() { git log --all --oneline --graph --decorate }

function ssr() { ssh -l root $args }

function ..() {  Set-Location ".."}
function ...() {  Set-Location "../.."}
function ....() {  Set-Location "../../.."}
function .....() {  Set-Location "../../../.."}
function ......() {  Set-Location "../../../../.."}

function cdp() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    $RealLocation = Get-Item $Path | Select-Object -ExpandProperty Target
    if ($null -eq $RealLocation) {
        Set-Location $Path
    } else {
        Set-Location $RealLocation
    }
}

function mkdircd() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    New-Item -Type Directory -Path $Path
    Set-Location $Path
}

function ll() {
    Get-ChildItem -Force
}

Set-Alias -Name c -Value Clear-Host
Set-Alias -Name cl -Value Clear-Host
Set-Alias -Name ckear -Value Clear-Host
Set-Alias -Name clr -Value Clear-Host

Set-Alias -Name l -Value ll
Set-Alias -Name ln -Value New-SymLink
Set-Alias -Name sus -Value New-AmongusTerminal
