$Acl = Get-Acl "D:\"
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule('Everyone', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
$Acl.SetAccessRule($Ar)
Set-Acl 'D:\' $Acl
