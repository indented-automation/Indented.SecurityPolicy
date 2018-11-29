using System;
using System.Runtime.InteropServices;
using System.Text;

namespace Indented.SecurityPolicy
{
    class UnsafeNativeMethods
    {
        private UnsafeNativeMethods() {}

        [DllImport("advapi32")]
        internal static extern int LsaClose(IntPtr PolicyHandle);

        [DllImport("advapi32", CharSet = CharSet.Unicode)]
        internal static extern uint LsaAddAccountRights(
            IntPtr               PolicyHandle,
            IntPtr               AccountSid,
            LSA_UNICODE_STRING[] UserRights,
            int                  CountOfRights
        );

        [DllImport("advapi32", CharSet = CharSet.Unicode)]
        internal static extern uint LsaEnumerateAccountRights(
            IntPtr     PolicyHandle,
            IntPtr     AccountSid,
            out IntPtr UserRights,
            out ulong  CountOfRights
        );

        [DllImport("advapi32", CharSet = CharSet.Unicode)]
        internal static extern uint LsaEnumerateAccountsWithUserRight(
            IntPtr             PolicyHandle,
            LSA_UNICODE_STRING UserRights,
            out IntPtr         EnumerationBuffer,
            out ulong          CountReturned
        );

        [DllImport("advapi32")]
        internal static extern int LsaFreeMemory(IntPtr Buffer);

        [DllImport("advapi32")]
        internal static extern int LsaNtStatusToWinError(int NTSTATUS);

        [DllImport("advapi32", CharSet = CharSet.Unicode)]
        internal static extern uint LsaOpenPolicy(
            LSA_UNICODE_STRING        SystemName,
            ref LSA_OBJECT_ATTRIBUTES ObjectAttributes,
            int                       AccessMask,
            out IntPtr                PolicyHandle
        );

        [DllImport("advapi32", CharSet = CharSet.Unicode)]
        internal static extern uint LsaRemoveAccountRights(
            IntPtr               PolicyHandle,
            IntPtr               AccountSid,
            bool                 AllRights,
            LSA_UNICODE_STRING[] UserRights,
            int                  CountOfRights
        );

        [DllImport("advapi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        internal static extern bool LookupAccountName(
            string           lpSystemName,
            string           lpAccountName,
            byte[]           Sid,
            ref uint         cbSid,
            StringBuilder    ReferencedDomainName,
            ref uint         cchReferencedDomainName,
            out SID_NAME_USE peUse
        );

        [DllImport("netapi32.dll", CharSet = CharSet.Unicode)]
        internal static extern uint NetAddServiceAccount(
            string ServerName,
            string AccountName,
            string Reserved,
            uint   Flags
        );

        [DllImport("netapi32.dll", CharSet = CharSet.Unicode)]
        internal static extern uint NetIsServiceAccount(
            string   ServerName,
            string   AccountName,
            out bool IsService
        );

        [DllImport("netapi32.dll", CharSet = CharSet.Unicode)]
        internal static extern uint NetRemoveServiceAccount(
            string ServerName,
            string AccountName,
            int    Flags
        );
    }
}