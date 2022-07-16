Write-Warning 'there''s a better version including strict class typing, in dev.nin or somewhere'

. (Join-Path $PSScriptRoot 'markdown-utils.ps1')
function collectExtensionVersion {
    <#
        .SYNOPSIS
            table of all addons, that match a regex
    #>
    param( [string]$Regex )

    code.cmd --list-extensions --show-versions
    | ForEach-Object { $Name, $Version = $_ -split '@'
        [pscustomobject]@{ Name = $Name ; Version = $Version ; }
    } | Where-Object {
        if ( -not $Regex) {
            return $true
        }
        $_.Name -Match $Regex
    |
        Sort-Object name

    }
}
function _codeVenv_installExtensionsSetup {
    # context: https://github.com/PowerShell/vscode-powershell/issues/3947#issuecomment-1115418405
    @('74th.monokai-charcoal-high-contrast@3.4.0', 'bungcip.better-toml@0.3.2', 'cake-build.cake-vscode@2.0.0', 'DavidAnson.vscode-markdownlint@0.47.0', 'eamodio.gitlens@12.0.6', 'EditorConfig.EditorConfig@0.16.4', 'esbenp.prettier-vscode@9.5.0', 'felipecaputo.git-project-manager@1.8.2', 'GitHub.github-vscode-theme@6.0.0', 'GitHub.vscode-pull-request-github@0.40.0', 'GrapeCity.gc-excelviewer@4.2.54', 'johnpapa.vscode-peacock@4.0.1', 'mhutchie.git-graph@1.30.0', 'ms-dotnettools.csharp@1.24.4', 'ms-dotnettools.dotnet-interactive-vscode@1.0.3227011', 'ms-toolsai.jupyter@2022.3.1000901801', 'ms-toolsai.jupyter-keymap@1.0.0', 'ms-toolsai.jupyter-renderers@1.0.6', 'ms-vscode-remote.remote-containers@0.233.0', 'ms-vscode.hexeditor@1.9.6', 'ms-vscode.powershell@2021.12.0', 'ms-vscode.powershell-preview@2022.4.3', 'ms-vscode.vscode-typescript-tslint-plugin@1.3.4', 'rebornix.ruby@0.28.1', 'redhat.vscode-yaml@1.7.0', 'shardulm94.trailing-spaces@0.3.1', 'shd101wyy.markdown-preview-enhanced@0.6.2', 'sinedied.vscode-windows-xp-theme@0.1.0', 'tomphilbin.gruvbox-themes@1.0.0', 'TylerLeonhardt.vscode-inline-values-powershell@0.0.5', 'vsls-contrib.gistfs@0.4.1', 'wingrunr21.vscode-ruby@0.28.0', 'yzhang.markdown-all-in-one@3.4.3') | ForEach-Object {
        code-insiders --install-extension ($_.Split('@')[0])
    }
}

$AddonGroups = @{
    Powershell = 'pwsh|(power.*shell)|pester|(edit.*service)'
}

Label 'Addon' 'Groups'
$AddonGroups | Format-Table -AutoSize -Wrap

Hr -fg magenta

collectExtensionVersion -Regex $AddonGroups.Powershell

Hr
collectExtensionVersion -Regex $AddonGroups.Powershell
| _mdTable 'Name', 'Length' -ea ignore

Hr -fg orange
@(
    Get-ChildItem . | Sort-Object length -desc | s -first 2
    Get-Item .
)
| _mdTable 'Name', 'Length'
return