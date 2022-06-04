$Acl = Get-Acl "D:\"
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule('Everyone', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
$Acl.SetAccessRule($Ar)
Set-Acl 'D:\' $Acl

Remove-SmbShare -Name 'D' -Force
New-SmbShare -Path D:\\ -Name 'D' -FullAccess Everyone

Remove-LocalUser 'Visitor'
New-LocalUser 'Visitor' -NoPassword
Add-LocalGroupMember -Group 'Guests' -Member 'Visitor'
