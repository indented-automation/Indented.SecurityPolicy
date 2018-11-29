function CloseLsaPolicy {
    <#
    .SYNOPSIS
        Close the LSA policy handle if it is open.
    .DESCRIPTION
        Close the LSA policy handle if it is open.
    #>

    param (
        [AllowNull()]
        [Object]$lsa
    )

    if ($lsa) {
        $lsa.Dispose()
    }
}