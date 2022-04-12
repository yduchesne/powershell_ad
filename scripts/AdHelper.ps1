
function AdCreds($username, $nonSecurePass) {
    $secure_pass = ConvertTo-SecureString $nonSecurePass -AsPlainText -Force
    $creds = New-Object System.Management.Automation.PSCredential($username, $secure_pass)
     return $creds
}