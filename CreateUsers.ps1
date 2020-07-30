$ArrUsers = 1..100
foreach ($ArrUser in $ArrUsers) {
    $UserName = "User-"+("{0:d2}" -f $ArrUser)
    New-ADUser -Name $UserName -Path "OU=RootUsers,DC=VWS,DC=Local" -SamAccountName $UserName -DisplayName $UserName -UserPrincipalName ($UserName+"@vws.local") -AccountPassword (ConvertTo-SecureString "ComplexP@ssw0rd!1" -AsPlainText -Force) -ChangePasswordAtLogon $false -Enabled $false
}

New-ADUser -Name Victor2 -Path "OU=RootUsers,DC=VWS,DC=Local" -SamAccountName Victor2 -DisplayName Victor2 -UserPrincipalName "Victor2@vws.local" `
    -AccountPassword (ConvertTo-SecureString "ComplexP@ssw0rd!1" -AsPlainText -Force) -ChangePasswordAtLogon $false -Enabled $false

$ArrUsers = 1..6
foreach ($ArrUser in $ArrUsers) {
    $UserName = "Test-"+("{0:d2}" -f $ArrUser)
    New-ADUser -Name $UserName -Path "OU=RootUsers,DC=VWS,DC=Local" -SamAccountName $UserName -DisplayName $UserName -UserPrincipalName ($UserName+"@vws.local") -AccountPassword (ConvertTo-SecureString "ComplexP@ssw0rd!1" -AsPlainText -Force) -ChangePasswordAtLogon $false -Enabled $false
}    