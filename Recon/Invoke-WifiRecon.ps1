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
Write-Warning "[$(Get-Date)] I've found $NumberOfWifi Wi-Fi Connection settings stored in your system $($env:computername) : "
ForEach($SSID in $ListOfSSID){

        $passphrase = ($(netsh.exe wlan show profiles name=`"$SSID`" key=clear) | Select-String -pattern ".*Key Content.*:(.*)" -allmatches).Matches | ForEach-Object {$_.Groups[1].Value}
        $Auth = ($(netsh.exe wlan show profiles name=`"$SSID`" key=clear) | Select-String -pattern ".*Authentication.*:(.*)" -AllMatches).Matches | ForEach-Object {$_.Groups[1].Value}
        $Auth = $Auth -split "  "
        $List = [PSCustomObject]@{"PROFILE_NAME"=$SSID;"Authentication"=$Auth[0];"PASSWORD"=$passphrase}
        $List | Export-Csv -Path "$Output.csv" -Append -NoTypeInformation
}
