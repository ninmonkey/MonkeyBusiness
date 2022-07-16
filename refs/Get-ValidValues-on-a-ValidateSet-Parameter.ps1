# [3] cmdinfo -> params -> ['Name']
$cmdinfo = Get-Command Get-Culture
$params = $cmdInfo.Parameters #| InspectObject -SkipNull

requires pass/finish

$params['Name'].Attributes | InspectObject | Format-Table -AutoSize
