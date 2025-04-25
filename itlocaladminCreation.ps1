$Username = "itlocaladmin"

$Parameters = @{
    Prompt         = "Enter password for $Username"
    AsSecureString = $true
}
$SecurePassword = Read-Host @Parameters
    

# Check if the account already exists
if (-not (Get-LocalUser -Name $Username -ErrorAction SilentlyContinue)) {
    # Proceed with creating the account and adding it to the Administrators group
    Write-Host "The account '$Username' does not exist. Proceeding with the account creation."

    # Create a new local administrator account
    $Account = New-LocalUser -Name $Username -Password $SecurePassword

    
    # Set the account to never expire
    $Account | Set-LocalUser -PasswordNeverExpires:$true
    

    # Add the account to the Administrators group
    Add-LocalGroupMember -Group "Administrators" -Member $Username

    # Verify the account was created and added to the Administrators group and has a password that never expires
    $AccountExists = Get-LocalUser -Name $Username -ErrorAction SilentlyContinue
    $IsInGroup = Get-LocalGroupMember -Group "Administrators" -Member $Username -ErrorAction SilentlyContinue

    if ($AccountExists -and $IsInGroup -and $Account.PasswordNeverExpires -eq $true) {
        Write-Host "Verification successful: The account '$Username' exists and is a member of the Administrators group and has a password that never expires."
    }
    else {
        Write-Host "Verification failed: The account '$Username' does not exist or is not a member of the Administrators group or does not have a password that never expires."
    }

}
else {
    Write-Host "The account '$Username' already exists. Skipping creation."
    return
}

# wget -uri 'https://raw.githubusercontent.com/IntelliScripts/IntelliScripts/refs/heads/main/Scripts/itlocaladminCreation.ps1' -UseBasicParsing | iex"