This PowerShell script module currently contains the [Enter-Object](help/Enter-Object.md) and [Invoke-Splat](help/Invoke-Splat.md) functions. It can be installed via the [PowerShell Gallery](https://www.powershellgallery.com/packages/amps/).

## EXAMPLES

Given the following hash table:

```powershell
$loginResult = @{
    Success = $false
    Reason = 'Expired'
    Message = @{
        Object = "Your password has expired, please reset your password."
        BackgroundColor = "Red"
    }
}
```

Splatting the nested $loginResult.Message hash table normally requires an assignment to a new temporary 
variable followed by splatting the hash table variable to the command:

```powershell
$message = $loginResult.Message
Write-Host @message
```

With [Invoke-Splat](help/Invoke-Splat.md), the nested hash table can be splatted directly against the command:

```powershell
Invoke-Splat Write-Host $loginResult.Message
```

With [Enter-Object](help/Enter-Object.md), the nested items in the hashtable are made available as variables within the script block and can be splatted against the command:

```powershell
Enter-Object $loginResult {
    Write-Host @Message
}
```
