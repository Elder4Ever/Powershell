param(
    $File,
    $IP,
    $User,
    $Pass
    
)
$ext = (Get-ChildItem $File).Extension

$date = Date -Format "yyyyMMdd_HHmm"

if(Test-Connection -ComputerName $IP -Count 1 -Delay 1 -ErrorAction SilentlyContinue){
    Write-host "$IP is Online"

    $name = Get-WMIObject Win32_ComputerSystem
    $hostname = $name.name

    $serverfile = "$hostname-$date$ext"

    $client = New-Object System.Net.WebClient
    $client.Credentials = New-Object System.Net.NetworkCredential("$User", "$Pass")
    $client.UploadFile("ftp://$IP/$serverfile", "$File")
}else{
    Write-Host "$IP is Offline"
}

