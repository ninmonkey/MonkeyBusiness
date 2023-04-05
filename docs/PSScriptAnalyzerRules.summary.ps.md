
- [Current Versions](#current-versions)
- [Rules: ScriptCop](#rules-scriptcop)
- [Rules: PSScriptAnalyzer](#rules-psscriptanalyzer)
- [Get-PSScriptAnalyzerRule](#get-psscriptanalyzerrule)


## Current Versions

```ps1
~~~pipescript{
Import-Module -PassThru PSScriptAnalyzer
Import-Module -PassThru Indented.ScriptAnalyzerRules
Import-Module -PassThru ScriptCop
}~~~
```




## Rules: ScriptCop

```ps1
~~~pipescript{
Import-Module -PassThru ScriptCop; gcm -m ScriptCop | sort Name | ft -AutoSize

gcm 'Get-ScriptCopFixer', 'Get-ScriptCopPatrol', 'Get-ScriptCopRule' | Ft -AutoSize

Get-ScriptCopFixer

Get-ScriptCopPatrol
}~~~
```


## Rules: PSScriptAnalyzer

```ps1
~~~pipescript{
$rules = PSScriptAnalyzer\Get-ScriptAnalyzerRule
$rules | group SourceName # | ft

$rules #   | ft -auto
}~~~
```

## Get-PSScriptAnalyzerRule