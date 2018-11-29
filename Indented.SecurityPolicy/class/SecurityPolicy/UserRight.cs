namespace Indented.SecurityPolicy
{
    public enum UserRight : int
    {
        SeTrustedCredManAccessPrivilege,           // Access Credential Manager as a trusted caller
        SeNetworkLogonRight,                       // Access this computer from the network
        SeTcbPrivilege,                            // Act as part of the operating system
        SeMachineAccountPrivilege,                 // Add workstations to domain
        SeIncreaseQuotaPrivilege,                  // Adjust memory quotas for a process
        SeInteractiveLogonRight,                   // Allow log on locally
        SeRemoteInteractiveLogonRight,             // Allow log on through Remote Desktop Services
        SeBackupPrivilege,                         // Back up files and directories
        SeChangeNotifyPrivilege,                   // Bypass traverse checking
        SeSystemtimePrivilege,                     // Change the system time
        SeTimeZonePrivilege,                       // Change the time zone
        SeCreatePagefilePrivilege,                 // Create a pagefile
        SeCreateTokenPrivilege,                    // Create a token object
        SeCreateGlobalPrivilege,                   // Create global objects
        SeCreatePermanentPrivilege,                // Create permanent shared objects
        SeCreateSymbolicLinkPrivilege,             // Create symbolic links
        SeDebugPrivilege,                          // Debug programs
        SeDenyNetworkLogonRight,                   // Deny access this computer from the network
        SeDenyBatchLogonRight,                     // Deny log on as a batch job
        SeDenyServiceLogonRight,                   // Deny log on as a service
        SeDenyInteractiveLogonRight,               // Deny log on locally
        SeDenyRemoteInteractiveLogonRight,         // Deny log on through Remote Desktop Services
        SeEnableDelegationPrivilege,               // Enable computer and user accounts to be trusted for delegation
        SeRemoteShutdownPrivilege,                 // Force shutdown from a remote system
        SeAuditPrivilege,                          // Generate security audits
        SeImpersonatePrivilege,                    // Impersonate a client after authentication
        SeIncreaseWorkingSetPrivilege,             // Increase a process working set
        SeIncreaseBasePriorityPrivilege,           // Increase scheduling priority
        SeLoadDriverPrivilege,                     // Load and unload device drivers
        SeLockMemoryPrivilege,                     // Lock pages in memory
        SeBatchLogonRight,                         // Log on as a batch job
        SeServiceLogonRight,                       // Log on as a service
        SeSecurityPrivilege,                       // Manage auditing and security log
        SeRelabelPrivilege,                        // Modify an object label
        SeSystemEnvironmentPrivilege,              // Modify firmware environment values
        SeManageVolumePrivilege,                   // Perform volume maintenance tasks
        SeProfileSingleProcessPrivilege,           // Profile single process
        SeSystemProfilePrivilege,                  // Profile system performance
        SeUndockPrivilege,                         // Remove computer from docking station
        SeAssignPrimaryTokenPrivilege,             // Replace a process level token
        SeRestorePrivilege,                        // Restore files and directories
        SeShutdownPrivilege,                       // Shut down the system
        SeSyncAgentPrivilege,                      // Synchronize directory service data
        SeTakeOwnershipPrivilege,                  // Take ownership of files or other objects
        SeDelegateSessionUserImpersonatePrivilege  // Obtain an impersonation token for another user in the same session
    }
}