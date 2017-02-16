Set-StrictMode -Version Latest

<#
.SYNOPSIS
   Enter-Object destructures an object and makes its properties available as variables in a new scope.
   
.DESCRIPTION
   Enter-Object makes available as variables the properties of an object, or the items of a hashtable,
   within a new scope without needing to refer to the object itself. It has an alias of 'with' to provide 
   a shorthand version that makes it feel like a built-in language construct.

   The most common anticipated use of this function is to perform splatting operations on a nested object's 
   properties or nested hashtable's items without having to perform temporary variable assignments to refer
   to the nested properties/items.

   Enter-Object removes the use of temporary variables and becomes more concise when dealing with complex 
   configuration objects where multiple splatting operations are needed.

.EXAMPLE
   >
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

   This example shows how a nested hashtable can be splatted directly without having to assign it to a new
   temporary variable as would normally be needed as follows:

   $message = $loginResult.Message
   Write-Host @message

.EXAMPLE
   >
   with $loginResult {
       Write-Host @Message
   }

   Building upon the first example, this shows the use of the 'with' alias which makes this feel like a
   built-in keyword. The 'with' alias was chosen because it's a keyword found in the VB.NET language that 
   performs the same purpose.

.OUTPUTS
   Any objects written to the output stream will be returned.
#>
function Enter-Object {
    [CmdletBinding()]
    [Alias("with")]
    param (
        # The object or hashtable to destructure and make available as variables within the script block.
        # When supplying an object the properties will be exposed as the variables.
        # When supplying a hashtable the items will be exposed as the variables.
        # Only the first-level of properties/items from the input object are converted into variables.
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidateNotNull()]
        [Object[]]
        $InputObject,

        # The script block with commands to execute in a new nested scope with access to the variables
        # from the decomposed input object.
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [ScriptBlock]
        $ScriptBlock
    )
    process
    {
        foreach($io in $InputObject) {
            Write-Verbose "InputObject type: $($io.GetType().FullName)"

            $variables = if($io -is [Hashtable]) {
                $io.Keys | ForEach-Object { [PSVariable]::new($_,$io.Item($_)) }
            } else {
                $io.PSObject.Properties | ForEach-Object { [PSVariable]::new($_.Name,$_.Value) }
            }

            Write-Verbose "ScriptBlock variables: $($variables.Name -join ',')"

            # functions, variables, arguments
            $ScriptBlock.InvokeWithContext($null,[PSVariable[]]$variables,$null)
        }
    }
}

<#
.SYNOPSIS
   Invoke-Splat invokes a command by splatting the provided hashtable or array.
      
.DESCRIPTION
   Invoke-Splat invokes a command and splats the provided hashtable or array. It has an alias of 'iat' to
   provide a shorthand version named after the At symbol (@), by 'Invoking At'.

   The anticipated use of this function is to perform splatting operations on a nested object's properties 
   or nested hashtable's items without having to perform temporary variable assignments to refer to the 
   nested properties/items.

   Invoke-Splat removes the need to use of temporary variables and provides a concise syntax when splatting
   items located within nested objects and hash tables.

.EXAMPLE
   >
   This example shows how a nested hashtable can be splatted directly without having to assign it to a new
   temporary variable. Given the following hash table:

   $loginResult = @{
       Success = $false
       Reason = 'Expired'
       Message = @{
           Object = "Your password has expired, please reset your password."
           BackgroundColor = "Red"
       }
   }

   Splatting the nested $loginResult.Message hash table normally requires an assignment to a new temporary 
   variable followed by splatting the hash table variable to the command:

   $message = $loginResult.Message
   Write-Host @message

   With Invoke-Splat, the nested hash table can be splatted directly against the command:

   Invoke-Splat Write-Host $loginResult.Message

.EXAMPLE
   iat Write-Host $loginResult.Message

   Building upon the data structure from the previous example, this example shows the use of the 'iat' alias.

.EXAMPLE
   iat {Write-Host -ForegroundColor Yellow} $loginResult.Message 

   Building upon the data structure from the previous example, this shows how to invoke a command with additional
   parameters to those in the InputObject parameter, by placing the command and its parameters in a script block.

.EXAMPLE
   $loginResult.Message | iat Write-Host

   Building upon the data structure from the previous example, this shows how to pipe a hash table to be splatted.

.OUTPUTS
   Any objects returned by the supplied command will be returned.
#>
function Invoke-Splat {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
    [CmdletBinding()]
    [Alias("iat")]
    param (
        # The command to execute.
        [string]
        $Command,

        # The hash table or array to splat. See about_Splatting for usage.
        [Parameter(Mandatory,ValueFromPipeline)]
        [object]
        $InputObject
    )

    # perform parameter validation here because [ValidateScript] doesn't work with [array]
    if(-not ($InputObject -is [hashtable] -or $InputObject -is [array])) {
        throw "Invoke-Splat: InputObject parameter type must a [hashtable] or [Array]"
    }

    Invoke-Expression -Command "$Command @InputObject" 
}