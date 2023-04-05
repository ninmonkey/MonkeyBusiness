function Test-ValidateHasPropertyName {
    param (
        # Target
        [Alias('Target')]
        [Parameter(Mandatory)]
        [Object]$InputObject,

        # Property names to test
        [Alias('Name')]
        [Parameter(Mandatory)]
        [string[]]$PropertyName

        #  require it to be a base object property
        # [switch]$TestBase
    )
    $allProps = $InputObject.psobject.properties.Name
    # todo: on $TestBase
    $allBaseProps = $InputObject.psbase.psobject.properties

    foreach ($P in $PropertyName) {
        if ($AllProps -notcontains $P) {
            # Write-Error -ea stop "ObjectMissingProperty '$p' in $InputObject"
            Write-Error "ObjectMissingProperty '$p' in '$InputObject' [$($InputObject.GetType())]"
        }

    }
}

function _fmt_mdTableRow {
    <#
    .EXAMPLE
    PS> 'Name', 'Length', 'FullName' | _fmt_mdTableRow

        | Name | Length | FullName |
    #>
    param(
        [Parameter(ValueFromPipeline)]
        [String[]]$InputText
    )
    begin {
        $lines = @()
    }
    process {
        foreach ($line in $InputText) {
            $LineS += $line
        }
    }
    end {

        # $lines | Join-String -sep ' | ' -op '| ' -os " |`n"
        $lines | Join-String -sep ' | ' -op '| ' -os ' |'
    }
}

function Format-PropertyTableMarkdown {
    <#
    .synopsis
        output object properties as a MD table
    .NOTES
        todo: ValidateProperty exists is (at least first) object  before loop
    #>
    [Alias('_mdTable')]
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject,

        [Alias('Name')]
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String[]]$PropertyNameOrder,

        [hashtable]$Options = @{}
    )
    begin {
        $Config = Ninmonkey.Console\Join-Hashtable -OtherHash $Options -BaseHash @{
            OutputHeader         = "`n"
            OutputFooter         = "`n"
            String               = @{
                MissingProperty = '￼'
                IsTrueNull      = '␀'
                IsBlank         = '␠'
            }
            # AllowMissing = @(
            #     'IO.DirectoryInfo'
            # )
            AllowMissingProperty = $true # what kind of exception
        }
        $objects = [list[object]]::new()
    }
    process {
        $objects.AddRange( $InputObject )
    }

    end {
        $TotalColumns = $PropertyNameOrder.Count
        if ($TotalColumns -eq 0) {
            Write-Error 'Zero Properties Selected'
            return
        }

        $firstObj = @($Objects)[0]
        $validateProps = @{
            InputObject  = $FirstObject
            PropertyName = $PropertyNameOrder
            ErrorAction  = 'continue'
        }
        if ( $firstObj -is 'IO.DirectoryInfo' -or $Config.AllowMissingProperty) {
            $validateProps.ErrorAction = 'SilentlyContinue'
        }

        Test-ValidateHasPropertyName @validateProps


        $Config.OutputHeader
        $PropertyNameOrder | _fmt_mdTableRow
        @(, '-' * $TotalColumns ) | _fmt_mdTableRow

        $objects | ForEach-Object {
            $obj = $_
            if ($obj -is 'text') {
                Write-Warning "Is text: '$Obj'"
            }
            @(foreach ($PropName in $PropertyNameOrder) {
                    # future: $
                    $nextVal = $obj.$PropName
                    if ($null -eq $NextVal) {
                        $Config.String.IsTrueNull
                    } elseif ( [String]::IsNullOrWhiteSpace($nextVal)) {
                        $Config.String.IsBlank
                    } else {
                        $NextVal
                    }
                }) | _fmt_mdTableRow
        } #| Join-String -sep "`n"

        $Config.OutputFooter
    }
}


function Find-VSCodeScriptAnalyzerConfig {
    <#
    .synopsis
        from the logs, find the active config ScriptAnalyzer is using
    .notes
    .example
       PS> Find-VSCodeScriptAnalyzerConfig 'ms-vscode.powershell-2022.5.1'

       # <json payload>
    #>
    [OutputType('System.String')]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompletions('ms-vscode.powershell-2022.5.1')]
        [string]$Version,

        # [Parameter(Mandatory, Position=0)]
        # [ArgumentCompletions('ms-vscode.powershell-2022.5.1')]
        # [string]$PassThru,

        #Return all lines without transforming
        [switch]$Raw

    )

    # $version = 'ms-vscode.powershell-2022.5.1'
    # $extPath = Get-Item -ea stop (Join-Path $Env:UserProfile (Join-Path '.vscode/extensions' $Version))
    # #$extPath = Join-Path $Ext
    # $latest = Get-ChildItem $extPath *.log -Recurse | Sort-Object LastWriteTime -Descending -Top 3 | s -First 1
    # $latestLine = (Select-String -Raw -Path $latest 'Created formatting hashtable:' | s -Last 1)
    # $latestLine -replace '^.*?: {', '{' | ConvertFrom-Json | ConvertTo-Json
    $extPath = Get-Item -ea stop (Join-Path $Env:UserProfile (Join-Path '.vscode/extensions' $Version))
    #$extPath = Join-Path $Ext
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

# Find-VSCodeScriptAnalyzerConfig 'ms-vscode.powershell-2022.5.1'