Sync Nested Group membership in a single ADDS Group
===================================================

## 1. Introduction
Currently Azure Active Directory doesn't support Nest Group membership.
You can get the details in the following reference:

[Add support for nested groups in Azure AD (app access and provisioning, group-based licensing)](https://feedback.azure.com/forums/169401-azure-active-directory/suggestions/15718164-add-support-for-nested-groups-in-azure-ad-app-acc)

Due to this limitation one of the products that gets affected is Azure Storage when using Azure File Share with on-premises Active Directory Domain Services authentication over SMB for Azure file shares.

For more details check the refence bellow:

[Overview - on-premises Active Directory Domain Services authentication over SMB for Azure file shares](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-identity-auth-active-directory-enable)

## 2. Workaround
It's possible to sync nested group membership tree under a single group using PowerShell scripts.

This sample script will help the creation and synchronization of a nested group membership under a single group.

The script will do the following tasks:

- Create a group appending a sufix "-Result"
- Load all users membership from a given nested group
- Add all loaded users to a new group "\<GroupName\>-Result"
- Clean all removed users from the new group "\<GroupName\>-Result"

## 2. How to use the Script
To use the script basically invoke the script name with the name of the group you would like to scan:

        .\SyncNestedGroup.ps1 -Group "<GroupName>"

To keep the created group in sync just execute the script again.