using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Security.Principal;

namespace Indented.SecurityPolicy
{
    public class Lsa : IDisposable
    {
        private bool disposed = false;
        private IntPtr lsaHandle;

        const uint STATUS_ACCESS_DENIED = 0xc0000022;
        const uint STATUS_INSUFFICIENT_RESOURCES = 0xc000009a;
        const uint STATUS_NO_MEMORY = 0xc0000017;
        const uint STATUS_OBJECT_NAME_NOT_FOUND = 0xc0000034;
        const uint STATUS_NO_MORE_ENTRIES = 0x8000001a;

        //
        // Constructors
        //

        ///<summary>Creates an instance of the Lsa class.</summary>
        public Lsa() : this("") { }

        ///<summary>Creates an instance of the Lsa class for the specified computerName.</summary>
        public Lsa(string computerName)
        {
            try
            {
                LSA_OBJECT_ATTRIBUTES lsaAttr = new LSA_OBJECT_ATTRIBUTES();
                lsaAttr.Length = Marshal.SizeOf(typeof(LSA_OBJECT_ATTRIBUTES));

                LSA_UNICODE_STRING computer = ConvertToLsaUnicodeString(computerName);

                uint ntStatus = UnsafeNativeMethods.LsaOpenPolicy(
                    computer,
                    ref lsaAttr,
                    (int)LsaPolicyAccess.POLICY_ALL_ACCESS,
                    out lsaHandle
                );
                TestNtStatus(ntStatus);
            }
            catch
            {
                throw;
            }
        }

        ///<summary>Grants rights to a single principal</summary>
        public void AddAccountRights(IdentityReference principal, UserRight[] userRight)
        {
            try
            {
                uint ntStatus = 0;
                using (Win32SecurityIdentifier securityIdentifier = new Win32SecurityIdentifier(principal))
                {
                    LSA_UNICODE_STRING[] userRights = new LSA_UNICODE_STRING[userRight.Length];
                    for (int i = 0; i < userRight.Length; i++)
                    {
                        userRights[i] = ConvertToLsaUnicodeString(userRight[i].ToString());
                    }

                    ntStatus = UnsafeNativeMethods.LsaAddAccountRights(
                        lsaHandle,
                        securityIdentifier.address,
                        userRights,
                        userRights.Length
                    );
                }
                TestNtStatus(ntStatus);
            }
            catch
            {
                throw;
            }
        }

        public void AddAccountRights(string principal, UserRight[] userRight)
        {
            AddAccountRights(new NTAccount(principal), userRight);
        }

        ///<summary>Remove all rights from a principal.</summary>
        public void RemoveAllAccountRights(IdentityReference principal)
        {
            uint ntStatus = 0;
            using (Win32SecurityIdentifier securityIdentifier = new Win32SecurityIdentifier(principal))
            {
                ntStatus = UnsafeNativeMethods.LsaRemoveAccountRights(
                    lsaHandle,
                    securityIdentifier.address,
                    true,
                    new LSA_UNICODE_STRING[0],
                    0
                );
                TestNtStatus(ntStatus);
            }
        }

        public void RemoveAllAccountRights(String principal)
        {
            RemoveAllAccountRights(new NTAccount(principal));
        }

        ///<summary>Remove specific rights from a principal.</summary>
        public void RemoveAccountRights(IdentityReference principal, UserRight[] userRight)
        {
            try
            {
                uint ntStatus = 0;
                using (Win32SecurityIdentifier securityIdentifier = new Win32SecurityIdentifier(principal))
                {
                    LSA_UNICODE_STRING[] userRights = new LSA_UNICODE_STRING[userRight.Length];
                    for (int i = 0; i < userRight.Length; i++)
                    {
                        userRights[i] = ConvertToLsaUnicodeString(userRight[i].ToString());
                    }

                    ntStatus = UnsafeNativeMethods.LsaRemoveAccountRights(
                        lsaHandle,
                        securityIdentifier.address,
                        false,
                        userRights,
                        userRights.Length
                    );
                }
                TestNtStatus(ntStatus);
            }
            catch
            {
                throw;
            }
        }

        public void RemoveAccountRights(String principal, UserRight[] userRight)
        {
            RemoveAccountRights(new NTAccount(principal), userRight);
        }

        ///<summary>Get all rights for a specific principal</summary>
        public UserRight[] EnumerateAccountRights(IdentityReference principal)
        {
            IntPtr userRights = IntPtr.Zero;
            ulong count = 0;
            List<UserRight> assignedUserRights = new List<UserRight>();

            try
            {
                uint ntStatus = 0;

                using (Win32SecurityIdentifier securityIdentifier = new Win32SecurityIdentifier(principal))
                {
                    ntStatus = UnsafeNativeMethods.LsaEnumerateAccountRights(
                        lsaHandle,
                        securityIdentifier.address,
                        out userRights,
                        out count
                    );
                }
                if (ntStatus == STATUS_OBJECT_NAME_NOT_FOUND)
                    return assignedUserRights.ToArray();
                TestNtStatus(ntStatus);
            }
            catch
            {
                throw;
            }


            for (int i = 0; i < (int)count; i++)
            {
                LSA_UNICODE_STRING userRight = (LSA_UNICODE_STRING)Marshal.PtrToStructure(
                    IntPtr.Add(userRights, i * Marshal.SizeOf(typeof(LSA_UNICODE_STRING))),
                    typeof(LSA_UNICODE_STRING)
                );

                assignedUserRights.Add((UserRight)Enum.Parse(typeof(UserRight), userRight.Buffer));
            }

            UnsafeNativeMethods.LsaFreeMemory(userRights);

            return assignedUserRights.ToArray();
        }

        ///<summary>Get all accounts with a specific right</summary>
        public IdentityReference[] EnumerateAccountsWithUserRight(UserRight userRight)
        {
            ulong count = 0;
            IntPtr buffer = IntPtr.Zero;
            List<IdentityReference> principals = new List<IdentityReference>();

            try
            {
                uint ntStatus = 0;
                ntStatus = UnsafeNativeMethods.LsaEnumerateAccountsWithUserRight(
                    lsaHandle,
                    ConvertToLsaUnicodeString(userRight.ToString()),
                    out buffer,
                    out count
                );
                if (ntStatus == STATUS_OBJECT_NAME_NOT_FOUND)
                    return principals.ToArray();
                TestNtStatus(ntStatus);
            }
            catch
            {
                throw;
            }

            for (int i = 0; i < (int)count; i++)
            {
                LSA_ENUMERATION_INFORMATION LsaInfo = (LSA_ENUMERATION_INFORMATION)Marshal.PtrToStructure(
                    IntPtr.Add(buffer, i * Marshal.SizeOf(typeof(LSA_ENUMERATION_INFORMATION))),
                    typeof(LSA_ENUMERATION_INFORMATION));

                SecurityIdentifier securityIdentifier = new SecurityIdentifier(LsaInfo.Sid);
                try
                {
                    principals.Add((IdentityReference)securityIdentifier.Translate(typeof(NTAccount)));
                }
                catch
                {
                    principals.Add((IdentityReference)securityIdentifier);
                }
            }

            UnsafeNativeMethods.LsaFreeMemory(buffer);

            return principals.ToArray();
        }

        ///<summary>Creates an instance of LSA_UNICODE_STRING</summary>
        private static LSA_UNICODE_STRING ConvertToLsaUnicodeString(string value)
        {
            // Unicode strings max. 32KB
            if (value.Length > 0x7ffe) throw new ArgumentException("String value must not exceed 32KB");

            LSA_UNICODE_STRING unicodeString = new LSA_UNICODE_STRING();
            if (String.IsNullOrWhiteSpace(value)) return unicodeString;

            unicodeString.Buffer = value;
            unicodeString.Length = (ushort)(value.Length * sizeof(char));
            unicodeString.MaximumLength = (ushort)(unicodeString.Length + sizeof(char));

            return unicodeString;
        }

        ///<summay>Raises an exception from a non-zero NTSTATUS.</summary>
        private static void TestNtStatus(uint ntStatus)
        {
            switch (ntStatus)
            {
                case 0:
                    return;
                case STATUS_NO_MORE_ENTRIES:
                    return;
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

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposed) return;

            if (disposing)
            {
                UnsafeNativeMethods.LsaClose(lsaHandle);
                lsaHandle = IntPtr.Zero;
            }

            disposed = true;
        }
    }
}