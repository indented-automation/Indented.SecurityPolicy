using System;
using System.Runtime.InteropServices;

namespace Indented.SecurityPolicy
{
    [StructLayout(LayoutKind.Sequential)]
    internal struct LSA_OBJECT_ATTRIBUTES
    {
        public int    Length;
        public IntPtr RootDirectory;
        public IntPtr ObjectName;
        public int    Attributes;
        public IntPtr SecurityDescriptor;
        public IntPtr SecurityQualityOfService;
    }
}