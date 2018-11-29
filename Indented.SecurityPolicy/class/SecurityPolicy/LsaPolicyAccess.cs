namespace Indented.SecurityPolicy
{
    internal enum LsaPolicyAccess : int
    {
        POLICY_READ       = 0x20006,
        POLICY_ALL_ACCESS = 0x00F0FFF,
        POLICY_EXECUTE    = 0X20801,
        POLICY_WRITE      = 0X207F8
    }
}