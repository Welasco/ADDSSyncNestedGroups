# Populate Groups
$GroupArr = "Group-Root","Group-Level1","Group-Level2","Group-Level3","Group-Level4","Group-Level5","Group-Level6","Group-Level7","Group-Level8","Group-Level9"
foreach ($group in $GroupArr) {
    New-ADGroup -Name $group -DisplayName $group -SamAccountName $group -Path "OU=RootGroups,DC=VWS,DC=Local" -GroupScope Global -GroupCategory Security    
}

# Add Group Membership
$i = 1
$x = 11
foreach ($group in $GroupArr) {
    for ($i; $i -lt $x; $i++) {
        $UserName = "User-"+("{0:d2}" -f $i)
        Add-ADGroupMember -Identity $group -Members $UserName
        #Write-Host "`$i:" $i -NoNewline; Write-Host -NoNewline " Group:" $group; Write-Host " User:" $UserName
    }
    $x = $x+10
}

# Add Nested Groups
Add-ADGroupMember -Identity "Group-Root" -Members "Group-Level1"
Add-ADGroupMember -Identity "Group-Level1" -Members "Group-Level2"
Add-ADGroupMember -Identity "Group-Level2" -Members "Group-Level3"
Add-ADGroupMember -Identity "Group-Level3" -Members "Group-Level4"
Add-ADGroupMember -Identity "Group-Level4" -Members "Group-Level5"
Add-ADGroupMember -Identity "Group-Level5" -Members "Group-Level6"
Add-ADGroupMember -Identity "Group-Level6" -Members "Group-Level7"
Add-ADGroupMember -Identity "Group-Level7" -Members "Group-Level8"
Add-ADGroupMember -Identity "Group-Level8" -Members "Group-Level9"
