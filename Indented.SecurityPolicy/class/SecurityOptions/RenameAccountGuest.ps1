using namespace System.Security.Principal

class RenameAccountGuest : RenameAccount {
    [WellKnownSidType]$SidType = 'AccountGuestSid'
}