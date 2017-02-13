@{

# Script module or binary module file associated with this manifest.
RootModule = 'amps.psm1'

# Version number of this module.
ModuleVersion = '0.2.1'

# ID used to uniquely identify this module
GUID = '11844c8e-40ec-41eb-8c05-9b7e494bf6ea'

# Author of this module
Author = 'Alan Mervitz'

# Copyright statement for this module
Copyright = '(c) 2017 Alan Mervitz. All rights reserved.'

# Description of the functionality provided by this module
Description = 'A PowerShell script module with advanced functions that extend PowerShell.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Functions to export from this module
FunctionsToExport = 'Enter-Object','Invoke-Splat'

# Aliases to export from this module
AliasesToExport = 'with','iat'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('splat')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/amervitz/amps/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/amervitz/amps'

        # ReleaseNotes of this module
        ReleaseNotes = @"
Version 0.2.1:

Add the Invoke-Splat function to directly splat a hash table or array located within a nested object. It has
the alias of 'iat' to provide a shorthand version named after the At symbol (@), by 'Invoking At'.

Example:

Invoke-Splat Write-Host `$loginResult.Message

---

Version 0.1.0:

Add the Enter-Object function for accessing the properties of an object or items of a hashtable as variables
within a new scope without needing to refer to the containing object. This makes it easy to splat a nested 
object without temporary variable assignments. It has an alias of 'with' to provide a shorthand version that 
makes it feel like a built-in language construct.

Example:

with `$loginResult {
    Write-Host @Message
}

"@
    } # End of PSData hashtable

} # End of PrivateData hashtable

}
