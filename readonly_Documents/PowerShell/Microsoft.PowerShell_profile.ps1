Clear-Host

Set-Alias gvim  Get-VimCommand
Set-Alias gwin  Get-WindowsCommand
Set-Alias gmap  Get-WinLinuxMap
Set-Alias gdock Get-DockerCommand
Set-Alias grex  Get-RegexExample
Set-Alias ggit  Get-GitCommand
Set-Alias gdork Get-GoogleDorkingCommand

$PSStyle.FileInfo.Directory = ""

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ── WANIKANI ──────────────────────────────────────────────────────
$data = Get-Content -Path C:\Users\Nadir\Projects\result.json | ConvertFrom-Json
$kanjiData = @(
    [PSCustomObject]@{ Header = $true },
    [PSCustomObject]@{ Empty  = $true }
) + $data.items

# ── SYSTEM INFO ───────────────────────────────────────────────────
$cpu      = "i7-12700K"
$ramFree  = "10.2"
$ramTot   = "32"
$diskFree = "234"
$diskTot  = "512"

# ── TIP OF THE DAY ────────────────────────────────────────────────
$tips = @(
    @{ Command = "git stash pop";         Desc = "ripristina ultimo stash"  },
    @{ Command = "git rebase -i HEAD~3";  Desc = "rebase interattivo"       },
    @{ Command = "git cherry-pick <sha>"; Desc = "applica commit specifico" },
    @{ Command = "git log --oneline";     Desc = "log compatto"             }
)
$tip = $tips | Get-Random

$status = "🟢"
switch($data.reviews) {
    {$_ -lt 50} {$status = "🟢"}
    {$_ -ge 50 -and $_ -lt 100} {$status = "🟡"}
    {$_ -ge 100 -and $_ -lt 200} {$status = "🟠"}
    {$_ -ge 200} {$status = "🔴"}
}
# ── RENDER: ASCII ART + KANJI AFFIANCATI ──────────────────────────
$artLines = @(
    "                                      ",
    "    ______ |\            _____        ",
    "    \     \| |____    __| _/__|______ ",
    "    /   |    |__  \  / __ ||  |_  __ \",
    "   /    |\   |/ __ \_ /_/ ||  ||  | \/",
    "   \____| \  /____  /____ ||__||__|   ",
    "           \/     \/     \/"
)

$width    = $Host.UI.RawUI.WindowSize.Width
$artWidth = $width - 70
$maxRighe = [Math]::Max($artLines.Count, $kanjiData.Count)

Write-Host ""
for ($i = 0; $i -lt $maxRighe; $i++) {
    $sinistra = if ($i -lt $artLines.Count) { $artLines[$i] } else { "" }
    $sinistra = $sinistra.PadRight($artWidth)
    Write-Host $sinistra -NoNewline -ForegroundColor Red
    if ($i -lt $kanjiData.Count) {
        $k = $kanjiData[$i]
        $color = switch ($k.Status) {
            "critical"   { "Red" }
            "mistakes"   { "Yellow" }
            "default"    { "Gray" }
        }
        if ($k.Header) {
            Write-Host "  wanikani 🐊🦀 level $($data.level) ⚔️ reviews $($data.reviews) $status" -ForegroundColor DarkGray
        }
        elseif ($k.Empty) {
            Write-Host ""
        }
        else {
            Write-Host "  $($k.Char)" -NoNewline -ForegroundColor White
            Write-Host "[ $($k.Reading)]" -NoNewline -ForegroundColor $color
            Write-Host " $($k.Meaning)" -NoNewline -ForegroundColor $color
            Write-Host "" 
        }
        
    } else {
        Write-Host ""
    }
}
# ── SYSTEM INFO + TIP ─────────────────────────────────────────────
Write-Host ""
Write-Host ("-" * $width) -ForegroundColor DarkGray
Write-Host "  💻 CPU: $cpu" -NoNewline -ForegroundColor Cyan
Write-Host "   |   " -NoNewline -ForegroundColor DarkGray
Write-Host "🧠 RAM: $ramFree / $ramTot GB" -NoNewline -ForegroundColor Cyan
Write-Host "   |   " -NoNewline -ForegroundColor DarkGray
Write-Host "💾 Disk: $diskFree / $diskTot GB" -ForegroundColor Cyan
Write-Host ("-" * $width) -ForegroundColor DarkGray
Write-Host "  tip of the day - git" -ForegroundColor DarkGray
Write-Host "  $($tip.Command)" -NoNewline -ForegroundColor Green
Write-Host "   ->  $($tip.Desc)" -ForegroundColor DarkGray
Write-Host ("-" * $width) -ForegroundColor DarkGray
                
