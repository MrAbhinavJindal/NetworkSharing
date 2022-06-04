Remove-LocalUser 'Visitor'
$GuestPassword = Read-Host -AsSecureString
New-LocalUser 'Visitor' -Password $GuestPassword
Add-LocalGroupMember -Group 'Guests' -Member 'Visitor'