$p = &{python3 -V} 2>&1; if($p -is [System.Management.Automation.ErrorRecord]){ $p.Exception.Message }else{ $p }
