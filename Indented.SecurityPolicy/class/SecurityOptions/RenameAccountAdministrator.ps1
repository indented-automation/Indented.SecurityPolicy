using namespace System.Security.Principal

class RenameAccountAdministrator : RenameAccount {
    [WellKnownSidType]$SidType = 'AccountAdministratorSid'
}