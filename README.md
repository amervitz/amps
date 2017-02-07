This PowerShell script module currently contains the Enter-Object function. It can be installed via the [PowerShell Gallery](https://www.powershellgallery.com/packages/amps/).

# Enter-Object
## SYNOPSIS
Enter-Object destructures an object and makes its properties available as variables in a new scope.

## SYNTAX
```powershell
Enter-Object [-InputObject] <Object[]> [-ScriptBlock] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
Enter-Object makes available as variables the properties of an object, or the items of a hashtable,
within a new scope without needing to refer to the object itself. It has an alias of 'with' to provide 
a shorthand version that makes it feel like a built-in language construct.

The most common anticipated use of this function is to perform splatting operations on a nested object's 
properties or nested hashtable's items without having to perform temporary variable assignments to refer
to the nested properties/items.

Enter-Object removes the use of temporary variables and becomes more concise when dealing with complex 
configuration objects where multiple splatting operations are needed.

## PARAMETERS
### -InputObject &lt;Object[]&gt;
The object or hashtable to destructure and make available as variables within the script block.
When supplying an object the properties will be exposed as the variables.
When supplying a hashtable the items will be exposed as the variables.
Only the first-level of properties/items from the input object are converted into variables.
 
### -ScriptBlock &lt;ScriptBlock&gt;
The script block with commands to execute in a new nested scope with access to the variables
from the decomposed input object.

## OUTPUTS
Any objects written to the output stream will be returned.

## EXAMPLES
### EXAMPLE 1
```powershell
$loginResult = @{
    Success = $false
    Reason = 'Expired'
    Message = @{
        Object = "Your password has expired, please reset your password."
        BackgroundColor = "Red"
        ForegroundColor = "Yellow"
    }
}

Enter-Object $loginResult {
    Write-Host @Message
}

```
This example shows how a nested hashtable can be splatted directly without having to assign it to a new
temporary variable as would normally be needed as follows:

```powershell
$message = $loginResult.Message
Write-Host @message
```

### EXAMPLE 2
```powershell
with $loginResult {
    Write-Host @Message
}
```
Building upon the first example, this shows the use of the 'with' alias which makes this feel like a
built-in keyword. The 'with' alias was chosen because it's a keyword found in the VB.NET language that 
performs the same purpose.
