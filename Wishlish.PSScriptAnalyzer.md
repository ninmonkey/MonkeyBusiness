<!--

<file:///H:\data\2023\pwsh\sketches\2023-04\sketch▸AST%20▸FormatLongLines.code-workspace>

-->

# Notes:

- I didn't specifiy severity levels yet (ie: warn / error). 
- Some of these are not compatible with the `End-Of-Life` versions of `Windows Powrshell` (ie: <= 5 )
- I'm aiming for `PowerShell 7+` 

# First to implement

- [ ] functions longer than `20 lines` should explicitly use `end` blocks instead of implicitly
- [ ] yell if anything contains command: `Wait-Debugger`
- [ ] warn when invalid defaults are set, causes could be
  - [ ] func name not exist (spelling error or missing module)
  - [ ] func name ambiguous (across installed modules)
  - [ ] parameter name wrong
  - [ ] parameter datatype wrong for that parameter type
```ps1
$PSDefaultParameterValues['Dev.Nin\_Peek-NewestItem:infa'] = 'Continue'
```

# kusto style formatting


These may be useful

- [https://github.com/PowerShell/PSScriptAnalyzer/blob/master/Rules/UseConsistentIndentation.cs#L100-L269](https://github.com/PowerShell/PSScriptAnalyzer/blob/master/Rules/UseConsistentIndentation.cs#L100-L269)
- [https://github.com/PowerShell/PSScriptAnalyzer/pull/1399](https://github.com/PowerShell/PSScriptAnalyzer/pull/1399)

# automatic min version testing

- reference here: <https://gist.github.com/ninmonkey/dd90aa7a1641b6643cfd904557115909>

- [ ] PS6 = `IValidateSetValuesGenerator` and `ArgumentCompletions`

# docs

## .link

  - [ ] warn if `.link`s to command or module that does not exist

# misc

- [ ] script uses functions from `dev.nin/public_experimental`
- [ ] script uses commands from another module **without depdency declared**

# naming

- [ ] invoking function `??` vs the operator `??`
- [ ] mixing `camelCase`
- [ ] variables and functions contain control chars
- [ ] should not be `!`, `:`, `:`, `enum`, `|` or `class`
- [ ] are outside the regular ascii encoding 
- [ ] variables and functions contain unicode
- [ ] variables and functions contain emoji
- [ ] function name is re-declared 
- [ ] function shadows existing functions
- [ ] function or alias that collide with `Get-Command -Applicate

# types

- [ ] watch for accidental reassignment of a **parameter** later in the body
- [ ] warn if variable is re-declared (maybe an accident) or redeclares typename

# Code formatting

- [ ] line should never end with `backtick`
- [ ] line should never end with `|`
- [ ] remove `system` from all type's namespaces (because it's always availabe)
- [?] complex single-line statements, separate to a list . (a -or -b -or c ...) 
- [ ] formatting pass on `calculated propeties` using `select-object`

uses <backtick> 0x60 as line continuation
  
 # More specific
  
 - [ ] when **piping** to `Join-String` and it has no args (because
 - [ ] using `+=` operator on an `array`.
 - [ ] piping to `stdout` without the `3` console encodings set to `utf8`
  
# Style, or Windows Powershell

- [ ] any `I/O` that doesn't set `-Encoding`
- [ ] using Select-Object to create a `[pscustomobject]`\
  - or maybe detect how many `hashtables` are in `-Property`, then long lines (from property names) are not set
  - [ ] wider than `n` 180 chars
  
  
