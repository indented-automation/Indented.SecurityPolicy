using namespace System.Security.Principal

class AccountStatusAdministrator : AccountStatus {
    [WellKnownSidType]$SidType = 'AccountAdministratorSid'
}