
# function  _findVersionValidCompletion {
#     Get-Item -ea stop (Join-Path $Env:UserProfile '.vscode/extensions')
#     | Get-ChildItem
#     | Where-Object { $_ -match 'ms-vscode.powershell' }
#     | Sort-Object
# }

function Find-VSCodeScriptAnalyzerConfig {
    <#
    .synopsis
        from the logs, find the active config ScriptAnalyzer is using
    .notes
        Use -Verbose -Debug for more info
    .example
       PS> Find-VSCodeScriptAnalyzerConfig 'ms-vscode.powershell-2022.5.1' -Raw

            2022-06-04 16:58:33.925 -05:00 [DBG] Created formatting hashtable: {"IncludeRules":["PSPlaceCloseBrace","PSPlaceOpenBrace","PSUseConsistentWhitespace","PSUseConsistentIndentation","PSAlignAssignmentStatement","PSAvoidUsingDoubleQuotesForConstantString"],"Rules":{"PSAvoidUsingCmdletAliases":{},"PSUseConsistentWhitespace":{"CheckInnerBrace":true,"CheckPipe":true,"CheckOpenParen":true,"CheckSeparator":true,"CheckParameter":true,"Enable":true,"CheckOpenBrace":true,"CheckPipeForRedundantWhitespace":true,"CheckOperator":true},"PSAlignAssignmentStatement":{"Enable":true,"CheckHashtable":true},"PSPlaceCloseBrace":{"NewLineAfter":false,"IgnoreOneLineBlock":false,"Enable":true},"PSUseConsistentIndentation":{"IndentationSize":4,"PipelineIndentation":2,"Kind":"space","Enable":true},"PSAvoidUsingDoubleQuotesForConstantString":{"Enable":true},"PSUseCorrectCasing":{"Enable":true},"PSPlaceOpenBrace":{"NewLineAfter":true,"Enable":true,"IgnoreOneLineBlock":false,"OnSameLine":true}}}
            2022-06-04 17:29:38.222 -05:00 [DBG] Created formatting hashtable: {"IncludeRules":["PSPlaceCloseBrace","PSPlaceOpenBrace","PSUseConsistentWhitespace","PSUseConsistentIndentation","PSAlignAssignmentStatement","PSAvoidUsingDoubleQuotesForConstantString"],"Rules":{"PSAvoidUsingCmdletAliases":{},"PSUseConsistentWhitespace":{"CheckInnerBrace":true,"CheckPipe":true,"CheckOpenParen":true,"CheckSeparator":true,"CheckParameter":true,"Enable":true,"CheckOpenBrace":true,"CheckPipeForRedundantWhitespace":true,"CheckOperator":true},"PSAlignAssignmentStatement":{"Enable":true,"CheckHashtable":true},"PSPlaceCloseBrace":{"NewLineAfter":false,"IgnoreOneLineBlock":false,"Enable":true},"PSUseConsistentIndentation":{"IndentationSize":4,"PipelineIndentation":2,"Kind":"space","Enable":true},"PSAvoidUsingDoubleQuotesForConstantString":{"Enable":true},"PSUseCorrectCasing":{"Enable":true},"PSPlaceOpenBrace":{"NewLineAfter":true,"Enable":true,"IgnoreOneLineBlock":false,"OnSameLine":true}}}
    .example
       PS> Find-VSCodeScriptAnalyzerConfig 'ms-vscode.powershell-2022.5.1'

        {
            "IncludeRules": [
                "PSPlaceCloseBrace",
                "PSPlaceOpenBrace",
                "PSUseConsistentWhitespace",
                "PSUseConsistentIndentation",
                "PSAlignAssignmentStatement",
                "PSAvoidUsingDoubleQuotesForConstantString"
            ],
            "Rules": {
                "PSAvoidUsingCmdletAliases": {},
                "PSUseConsistentWhitespace": {
                "CheckInnerBrace": true,

            <json continues>
    #>
    [Alias('Find-CodePSSAConfig')] # 'dev->findPSSAConfig'
    [OutputType('System.String')]
    param(
        # Version name as text
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompletions('ms-vscode.powershell-2022.5.1')]
        [string]$Version,

        # Return all lines without transforming
        [switch]$Raw

    )
    $extPath = Get-Item -ea stop (Join-Path $Env:UserProfile (Join-Path '.vscode/extensions' $Version))
    $ExtPath | Write-Verbose

    $latest = Get-ChildItem $extPath *.log -Recurse | Sort-Object LastWriteTime -Descending -Top 1 | s -First 1
    $Latest | Join-String -sep ', ' -DoubleQuote | Write-Debug
    $latestLine = Select-String -Raw -Path $latest 'Created formatting hashtable:'
    'LatestLine.Count {0}' -f $latestLine.Count | Write-Verbose
    if ($Raw) {
        return $latestLine
    }
    $LatestLine = $LatestLine | Select-Object -Last 1
    $latestLine -replace '^.*?: {', '{' | ConvertFrom-Json | ConvertTo-Json
}
