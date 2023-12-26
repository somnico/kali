$sshProcessInfo = Get-Process -Name ssh | Select-Object -Property ProcessName, Id
$sshProcessId = $sshProcessInfo.Id
Stop-Process -Id $sshProcessId -Force