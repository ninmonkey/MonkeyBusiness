## See also:

- module `Indented.ScriptAnalyzerRules`
  - [Invoke-CustomSCriptAnalyzerRule](./../refs_no_commit/Indented.ScriptAnalyzerRules/Indented.ScriptAnalyzerRules/public/helper/Invoke-CustomScriptAnalyzerRule.ps1)
- [PSScriptAnalyzerTestHelper.psm1](./../refs_no_commit/PSScriptAnalyzer🍴/Tests/PSScriptAnalyzerTestHelper.psm1)
  - [PSScriptAnalyzerTestHelper.psm1](./psc/PSScriptAnalyzer/Tests/PSScriptAnalyzerTestHelper.psm1)

## Module Commands

<!-- Get-ScriptAnalyzerRule -->


```ps
~~~pipescript{

Import-Module pipescript, PSScriptAnalyzer, 'Indented.ScriptAnalyzerRules', 'ScriptCop' -ea 'silentlycontinue' -passthru
| sort Name| ft

gcm -m 'Indented.ScriptAnalyzerRules' | sort Source, Name | Ft

}~~~
```

## Built in Ast Types


```md
~~~pipescript{

ClassExplorer\Find-Type -FullName *Ast* 
# this Ft triggers the Pipescript bug v0.2.4 
# | ft -auto


ClassExplorer\Find-Type -FullName *Ast* 

}~~~
```