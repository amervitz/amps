# Invoke-Splat
## SYNOPSIS
Invoke-Splat invokes a command by splatting the provided hashtable or array.

## SYNTAX
```powershell
Invoke-Splat [[-Command] <String>] [-InputObject] <Object> [<CommonParameters>]
```

## DESCRIPTION
Invoke-Splat invokes a command and splats the provided hashtable or array. It has an alias of 'iat' to
provide a shorthand version named after the At symbol (@), by 'Invoking At'.

The anticipated use of this function is to perform splatting operations on a nested object's properties 
or nested hashtable's items without having to perform temporary variable assignments to refer to the 
nested properties/items.

Invoke-Splat removes the need to use of temporary variables and provides a concise syntax when splatting
items located within nested objects and hash tables.

## PARAMETERS
### -Command &lt;String&gt;
The command to execute.
 
### -InputObject &lt;Object&gt;
The hash table or array to splat. See about_Splatting for usage.

## OUTPUTS
Any objects returned by the supplied command will be returned.

## EXAMPLES
### EXAMPLE 1

This example shows how a nested hashtable can be splatted directly without having to assign it to a new
temporary variable. Given the following hash table:

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

With Invoke-Splat, the nested hash table can be splatted directly against the command:

```powershell
Invoke-Splat Write-Host $loginResult.Message
```

### EXAMPLE 2
```powershell
iat Write-Host $loginResult.Message
```
Building upon the data structure from the previous example, this example shows the use of the 'iat' alias.

### EXAMPLE 3
```powershell
iat {Write-Host -ForegroundColor Yellow} $loginResult.Message
```

Building upon the data structure from the previous example, this shows how to invoke a command with additional
parameters to those in the InputObject parameter, by placing the command and its parameters in a script block.

### EXAMPLE 4
```powershell
$loginResult.Message | iat Write-Host
```

Building upon the data structure from the previous example, this shows how to pipe a hash table to be splatted.
