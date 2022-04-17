
function AuthCreds($username, $nonSecurePass) {
    $secure_pass = ConvertTo-SecureString $nonSecurePass -AsPlainText -Force
    $creds = New-Object System.Management.Automation.PSCredential($username, $secure_pass)
     return $creds
}

function AuthAzureAD($username, $nonSecurePass) {
    Connect-AzureAD -Credential AuthCreds($username, $nonSecurePass)
}

function AuthAzureADWithCreds($creds) {
    Connect-AzureAD -Credential $creds
}

function AuthAzAccount($username, $nonSecurePass) {
    Connect-AzAccount -Credential AuthCreds($username, $nonSecurePass)
}

function AuthAzureAccountWithCredss($creds) {
    Connect-AzAccount -Credential $creds
}

function AccessToken($identityEndpoint, $identityHeader) {
    $headers=@{"secret"=$identityHeader}
    $uri = "$($identityEndpoint)?resource=https://management.azure.com/&api-version=2017-09-01"
    $response = Invoke-WebRequest -UseBasicParsing -Uri $uri -Headers $headers
    $response.RawContent
}

# ============================================================================
# Users

function UsersAll() {
    Get-AzureADUser -All $true
}

function UsersAllApi($accessToken) {
    $uri = 'https://graph.microsoft.com/v1.0/users' 
    $params = @{ 
     Method = 'GET' 
     Uri = $URI 
     Headers = @{ 
     'Authorization' = "Bearer $accessToken" 
     } 
    } 
    (Invoke-RestMethod @params).value      
}

function User($userId) {
    Get-AzureADUser -ObjectId $userId
}

function UsersMatchPwd() {
    Get-AzureADUser -All $true | %{$Properties = $_;$Properties.PSObject.Properties.Name | % {if ($Properties.$_ -match 'password') {"$($Properties.UserPrincipalName) - $_ - $($Properties.$_)"}}}}

function UsersMatchPrincipalName($keyword) {
    Get-AzureADUser -SearchString $keyword
}

function UsersMatchDisplayName() {
    Get-AzureADUser -All $true |?{$_.Displayname -match "admin"}
}

function UserAttributes($userId) {
    Get-AzureADUser -ObjectId $userId | fl *
}

function UsersFromOnPrem() {
    Get-AzureADUser -All $true | ?{$_.OnPremisesSecurityIdentifier -ne $null}
}

function UsersFromAD() {
    Get-AzureADUser -All $true | ?{$_.OnPremisesSecurityIdentifier -eq $null}
}

# ============================================================================
# Groups

function GroupsAll() {
    Get-AzureADGroup -All $true
}

function Group($groupId) {
    Get-AzureADGroup -ObjectId $groupId
}

function GroupsMatchPrefix($keyword) {
    Get-AzureADGroup -SearchString $keyword | fl *
}

function GroupsMatchDisplayName($keyword) {
    Get-AzureADGroup -All $true |?{$_.Displayname -match $keyword }
}

function GroupsDynamic() {
    Get-AzureADMSGroup | ?{$_.GroupTypes -eq 'DynamicMembership'}
}

function GroupsFromOnPrem() {
    Get-AzureADGroup -All $true | ?{$_.OnPremisesSecurityIdentifier -ne $null}
}

function GroupsFromOnAD() {
    Get-AzureADGroup -All $true | ?{$_.OnPremisesSecurityIdentifier -eq $null}
}

function GroupMembers($groupId) {
    Get-AzureADGroupMember -ObjectId $groupId
}

function GroupsMatchMember($keyword) {
    Get-AzureADUser -SearchString $keyword | Get-AzureADUserMembership
}

function GroupsWithMember($userId) {
    Get-AzureADUserMembership -ObjectId $userId
}


# ============================================================================
# Roles

function RoleTemplatesAll() {
    Get-AzureADDirectoryroleTemplate
}

function RolesAll() {
    Get-AzureADDirectoryRole
}

function RoleMembers($roleName) {
    Get-AzureADDirectoryRole -Filter "DisplayName eq '$roleName'" | Get-AzureADDirectoryRoleMember
}

# ============================================================================
# Devices

function DevicesAll() {
    Get-AzureADDevice -All $true | fl *
}

function DeviceConfigs() {
    Get-AzureADDeviceConfiguration | fl *
}

function DeviceOwners() {
    Get-AzureADDevice -All $true | Get-AzureADDeviceRegisteredOwner
}

function DeviceUsers() {
    Get-AzureADDevice -All $true | Get-AzureADDeviceRegisteredUser
}

function DevicesOwnedBy($userId) {
    Get-AzureADUserOwnedDevice -ObjectId $userId
}

function DevicesRegisteredBy($userId) {
    Get-AzureADUserRegisteredDevice -ObjectId $userId
}

function DevicesIntuneManaged($userId) {
    Get-AzureADDevice -All $true | ?{$_.IsCompliant -eq "True"}
}

# ============================================================================
# Apps

function AppsAll() {
    Get-AzureADApplication -All $true
}

function AppDetails($appId) {
    Get-AzureADApplication -ObjectId $appId | fl *
}


function AppsMatchDisplayName($keyword) {
    Get-AzureADApplication -All $true | ?{$_.DisplayName -match $keyword}
}

function AppsWithAppCreds() {
    Get-AzureADApplicationPasswordCredential
}

function AppsWithOwners($appId) {
    Get-AzureADApplication -ObjectId $appId | Get-AzureADApplicationOwner | fl *
}

function AppsWithUser($userId) {
    Get-AzureADUser -ObjectId $userId | Get-AzureADUserAppRoleAssignment | fl *
}

function AppsWithGroup($groupId) {
    Get-AzureADGroup -ObjectId $groupId | Get-AzureADGroupAppRoleAssignment | fl *
}

# ============================================================================
# Service principals

function SpAll() {
    Get-AzureADServicePrincipal -All $true
}
function SpDetails($spId) {
    Get-AzureADServicePrincipal -ObjectId $spId | fl *
}

function SpMatchDisplayName($keyword) {
    Get-AzureADServicePrincipal -All $true | ?{$_.DisplayName -match $keyword}
}

function SpIsOwnedBy($appId) {
    Get-AzureADServicePrincipal -ObjectId $appId | Get-AzureADServicePrincipalOwner |fl *
}


function SpIsOwerOf($appId) {
    Get-AzureADServicePrincipal -ObjectId $appId | Get-AzureADServicePrincipalOwnedObject
}

function SpIsCreatorOf($appId) {
    Get-AzureADServicePrincipal -ObjectId $appId | Get-AzureADServicePrincipalCreatedObject
}

function SpIsMemberOf($appId) {
    Get-AzureADServicePrincipal -ObjectId $appId cdddd16e-2611-4442-8f45-053e7c37a264 | Get-AzureADServicePrincipalMembership |fl *
}