$global:UsersArray = @()
function Get-NestedGroupMember{
    [CmdletBinding()] 
    param 
    (
        [Parameter(Mandatory)] 
        [string]$Group 
    )

    $members = Get-ADGroupMember -Identity $Group 

    foreach ($member in $members){
        if ($member.objectClass -eq 'group'){
            Get-NestedGroupMember -Group $member.sAMAccountName
        }
        else{
            $member.sAMAccountName  
            $global:UsersArray += $member.sAMAccountName
        }
    }
}

function CleanGroupMemberShip {
    [CmdletBinding()] 
    param 
    (
        [Parameter(Mandatory)] 
        [string]$Group 
    )    
    $CurrentMembers = (Get-ADGroupMember $Group ).sAMAccountName
    $ExpectedMembers = $global:UsersArray
    $UniqueExpectedMembers = $ExpectedMembers | Select -unique
    $ClearUsers = Compare-Object -ReferenceObject $CurrentMembers -DifferenceObject $UniqueExpectedMembers -PassThru
    foreach ($ClearUser in $ClearUsers) {
        Remove-ADGroupmember -Identity $Group -Members $ClearUser -Confirm:$False
    }
}

function AddNewUsersMembership {
    [CmdletBinding()] 
    param 
    (
        [Parameter(Mandatory)] 
        [string]$Group 
    )
    
    foreach ($UserToAdd in $global:UsersArray) {
        Add-ADGroupMember -Identity $Group -Members $UserToAdd
    }    
}

function GenerateGroupMembership{
    [CmdletBinding()] 
    param 
    (
        [Parameter(Mandatory)] 
        [string]$Group 
    )
    $NewGroup = ($Group+"-Result")
    New-ADGroup -Name $NewGroup -DisplayName $NewGroup -SamAccountName $NewGroup -Path "OU=RootGroups,DC=VWS,DC=Local" -GroupScope Global -GroupCategory Security -ErrorAction SilentlyContinue

    Get-NestedGroupMember -Group $Group
    AddNewUsersMembership -Group $NewGroup
    CleanGroupMemberShip -Group $NewGroup
}
#Get-NestedGroupMember -Group "Group-Root"
GenerateGroupMembership -Group "Group-Root"


