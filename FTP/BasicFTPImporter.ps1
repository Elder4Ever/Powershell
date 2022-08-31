$file = Read-Host "File Path"
$ext = (Get-ChildItem $file).Extension

$date = Date -Format "yyyyMMdd_HHmm"

$IP = Read-Host "FTP Server IP"

if(Test-Connection -ComputerName $IP -Count 1 -Delay 1 -ErrorAction SilentlyContinue){
    Write-host "$IP is Online"
    Write-Host ""
    Write-Host "LOGIN TO FTP SERVER"
    $User = Read-Host "Username"
    $Pass = Read-Host "Password" -AsSecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Pass)
    $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    $name = Get-WMIObject Win32_ComputerSystem
    $hostname = $name.name

    $serverfile = "$hostname-$date$ext"

    $client = New-Object System.Net.WebClient
    $client.Credentials = New-Object System.Net.NetworkCredential("$User", "$Password")
    $client.UploadFile("ftp://$IP/$serverfile", "$file")
}else{
    Write-Host "$IP is Offline"
}

