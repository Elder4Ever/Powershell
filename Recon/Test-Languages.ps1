$py = &{python3 -V} 2>&1; if($py -is [System.Management.Automation.ErrorRecord]){ $py.Exception.Message }else{ $py }
$ps1 = &{$PSVersionTable.PSVersion} 2>&1; if($ps1 -is [System.Management.Automation.ErrorRecord]){ $ps1.Exception.Message }else{Write-Host 'Powershell' $PSVersionTable.PSVersion}
