using System;
using System.Runtime.InteropServices;

namespace Indented.SecurityPolicy
{
    [StructLayout(LayoutKind.Sequential)]
    internal struct LSA_ENUMERATION_INFORMATION
    {
        public IntPtr Sid;
    }
}