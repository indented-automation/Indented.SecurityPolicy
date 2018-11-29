using namespace System.Security.Principal

class AccountStatusGuest : AccountStatus {
    [WellKnownSidType]$SidType = 'AccountGuestSid'
}