using System;
using System.Runtime.InteropServices;
using System.Security;
using System.Security.Principal;
using Microsoft.Win32.SafeHandles;

namespace Indented.SecurityPolicy
{
    public class Win32SecurityIdentifier : IDisposable
    {
        private bool disposed = false;
        private GCHandle handle;
        private Byte[] buffer;

        public SecurityIdentifier securityIdentifier;

        public Win32SecurityIdentifier(String principal) : this(new NTAccount(principal)) { }

        public Win32SecurityIdentifier(IdentityReference identityReference) : this((SecurityIdentifier)identityReference.Translate(typeof(SecurityIdentifier))) { }

        public Win32SecurityIdentifier(SecurityIdentifier securityIdentifier)
        {
            this.securityIdentifier = securityIdentifier;

            buffer = new Byte[securityIdentifier.BinaryLength];
            securityIdentifier.GetBinaryForm(buffer, 0);

            handle = GCHandle.Alloc(buffer, GCHandleType.Pinned);
        }

        public IntPtr address
        {
            get {
                if (handle.IsAllocated)
                {
                    return handle.AddrOfPinnedObject();
                }
                else
                {
                    return IntPtr.Zero;
                }
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

            if (disposing && handle.IsAllocated)
                handle.Free();

            disposed = true;
        }
    }
}