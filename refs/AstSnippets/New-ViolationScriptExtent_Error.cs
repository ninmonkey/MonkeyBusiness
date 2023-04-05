/*
    see: ./refs_no_commit/PSScriptAnalyzer🍴/Rules/AvoidLongLines.cs
*/
public override IEnumerable<DiagnosticRecord> AnalyzeScript(Ast ast, string fileName)
{
    if (ast == null)
    {
        throw new ArgumentNullException(nameof(ast));
    }

    var diagnosticRecords = new List<DiagnosticRecord>();

    string[] lines = ast.Extent.Text.Split(s_lineSeparators, StringSplitOptions.None);

    for (int lineNumber = 0; lineNumber < lines.Length; lineNumber++)
    {
        string line = lines[lineNumber];

        if (line.Length <= MaximumLineLength)
        {
            continue;
        }

        int startLine = lineNumber + 1;
        int endLine = startLine;
        int startColumn = 1;
        int endColumn = line.Length;

        var violationExtent = new ScriptExtent(
            new ScriptPosition(
                ast.Extent.File,
                startLine,
                startColumn,
                line
            ),
            new ScriptPosition(
                ast.Extent.File,
                endLine,
                endColumn,
                line
            ));

        var record = new DiagnosticRecord(
                String.Format(CultureInfo.CurrentCulture,
                    String.Format(Strings.AvoidLongLinesError, MaximumLineLength)),
                violationExtent,
                GetName(),
                GetDiagnosticSeverity(),
                ast.Extent.File,
                null
            );
        diagnosticRecords.Add(record);
    }

    return diagnosticRecords;
}
