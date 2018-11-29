using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Security.Principal;
using System.Text;

namespace Indented.SecurityPolicy
{
    public static class Account
    {
        public static SecurityIdentifier LookupAccountName(string SystemName, string AccountName)
        {
            const int ERROR_INSUFFICIENT_BUFFER = 122;

            uint cbSid = 0;
            uint cchReferencedDomainName = 0;
            SID_NAME_USE peUse;

            UnsafeNativeMethods.LookupAccountName(
                SystemName,
                AccountName,
                null,
                ref cbSid,
                null,
                ref cchReferencedDomainName,
                out peUse
            );

            if (Marshal.GetLastWin32Error() == ERROR_INSUFFICIENT_BUFFER)
            {
                byte[] Sid = new byte[cbSid];
                StringBuilder ReferencedDomainName = new StringBuilder((int)cchReferencedDomainName);

                if (UnsafeNativeMethods.LookupAccountName(
                        SystemName,
                        AccountName,
                        Sid,
                        ref cbSid,
                        ReferencedDomainName,
                        ref cchReferencedDomainName,
                        out peUse
                    )) {

                    return new SecurityIdentifier(Sid, 0);
                }
            }

            throw new Win32Exception(Marshal.GetLastWin32Error());
        }
    }
}