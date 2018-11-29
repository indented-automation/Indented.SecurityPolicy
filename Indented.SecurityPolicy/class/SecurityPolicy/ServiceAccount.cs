using System;
using System.ComponentModel;

namespace Indented.SecurityPolicy
{
    public class ServiceAccount
    {
        const uint STATUS_ACCESS_DENIED = 0xc0000022;
        const uint STATUS_INSUFFICIENT_RESOURCES = 0xc000009a;
        const uint STATUS_NO_MEMORY = 0xc0000017;
        const uint STATUS_OBJECT_NAME_NOT_FOUND = 0xc0000034;
        const uint STATUS_NO_MORE_ENTRIES = 0x8000001a;

        public static void AddServiceAccount(string AccountName)
        {
            try
            {
                uint ntStatus = UnsafeNativeMethods.NetAddServiceAccount(
                    null,
                    AccountName,
                    null,
                    0
                );
                TestNtStatus(ntStatus);
            }
            catch
            {
                throw;
            }
        }

        public static bool IsServiceAccount(string AccountName)
        {
            try
            {
                bool isService;
                uint ntStatus = UnsafeNativeMethods.NetIsServiceAccount(
                    null,
                    AccountName,
                    out isService
                );
                TestNtStatus(ntStatus);

                return isService;
            }
            catch
            {
                throw;
            }
        }

        public static void RemoveServiceAccount(string AccountName)
        {
            try
            {
                uint ntStatus = UnsafeNativeMethods.NetAddServiceAccount(
                    null,
                    AccountName,
                    null,
                    0
                );
                TestNtStatus(ntStatus);
            }
            catch
            {
                throw;
            }
        }

        private static bool TestNtStatus(uint ntStatus)
        {
            switch (ntStatus)
            {
                case 0:
                    return true;
                case STATUS_NO_MORE_ENTRIES:
                    return true;
                case STATUS_ACCESS_DENIED:
                    throw new UnauthorizedAccessException();
                case STATUS_INSUFFICIENT_RESOURCES:
                    throw new OutOfMemoryException();
                case STATUS_NO_MEMORY:
                    throw new OutOfMemoryException();
                default:
                    throw new Win32Exception(UnsafeNativeMethods.LsaNtStatusToWinError((int)ntStatus));
            }
        }
    }
}