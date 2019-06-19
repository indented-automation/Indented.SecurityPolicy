using namespace System.Management.Automation

function OpenLsaPolicy {
    <#
    .SYNOPSIS
        Open the LSA policy handle.
    .DESCRIPTION
        Open the LSA policy handle.
    #>

    [CmdletBinding()]
    [OutputType([Indented.SecurityPolicy.Lsa])]
    param ( )

    try {
        return [Indented.SecurityPolicy.Lsa]::new()
    } catch {
        $innerException = $_.Exception.GetBaseException()
        if ($innerException -is [UnauthorizedAccessException]) {
            $exception = [UnauthorizedAccessException]::new('Cannot open LSA: Access denied', $innerException)
            $category = 'PermissionDenied'
        } else {
            $exception = [InvalidOperationException]::new('An error occurred when opening the LSA', $innerException)
            $category = 'OperationStopped'
        }
        $errorRecord = [ErrorRecord]::new(
            $exception,
            'CannotOpenLSA',
            $category,
            $null
        )
        throw $errorRecord
    }
}