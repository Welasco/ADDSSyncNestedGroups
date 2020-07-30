[CmdletBinding()] 
param 
(
    [Parameter(Mandatory)] 
    [string]$Group,
    [Parameter(Mandatory)] 
    [string]$Path
)

$global:UsersArray = @()

function Get-NestedGroupMember{
    [CmdletBinding()] 
    param 
    (
        [Parameter(Mandatory)] 
        [string]$Group 
    )

    $members = Get-ADGroupMember -Identity $Group -Recursive
    $global:UsersArray += $members.sAMAccountName
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
        [string]$Group,
        [Parameter(Mandatory)] 
        [string]$Path    
    )
    $NewGroup = ($Group+"-Result")
    try {
        Get-ADGroup $NewGroup | Out-Null
    }
    catch {
        New-ADGroup -Name $NewGroup -DisplayName $NewGroup -SamAccountName $NewGroup -Path $Path -GroupScope Global -GroupCategory Security -ErrorAction SilentlyContinue
    }
    
    Get-NestedGroupMember -Group $Group
    AddNewUsersMembership -Group $NewGroup
    CleanGroupMemberShip -Group $NewGroup
}

GenerateGroupMembership -Group $Group -Path $Path 