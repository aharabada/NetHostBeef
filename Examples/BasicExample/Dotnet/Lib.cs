using System.Diagnostics;
using System.Runtime.InteropServices;

namespace DotNetBasicExample;

public class Lib
{
    [StructLayout(LayoutKind.Sequential, Pack=1)]
    public struct ArgStruct
    {
        public IntPtr Text;
        public float Number;
    }
    
    // Test Default entry point.
    public static int Test1(IntPtr arg, int sizeofArg)
    {
        Debug.Assert(Marshal.SizeOf<ArgStruct>() == sizeofArg, $"Provided argument has wrong size. (Expected: {Marshal.SizeOf<ArgStruct>()}, Actual: {sizeofArg})");
        
        ArgStruct args = Marshal.PtrToStructure<ArgStruct>(arg);

        string? message = Marshal.PtrToStringUTF8(args.Text);

        Console.WriteLine($"C#: The message is \"{message}\".");
        Console.WriteLine($"C#: The number is {args.Number}.");

        return 7;
    }

    // Entry point delegate for Test2
    public delegate float Test2Delegate(float x, float y);

    // Test custom entry point.
    public static float Test2(float x, float y)
    {
        Console.WriteLine($"C#: Adding {x} and {y}...");

        return x + y;
    }

    // Test unmanaged callers only. (DotNet 5 and above)
    [UnmanagedCallersOnly]
    public static void Test3()
    {
        Console.WriteLine($"Hello from C#! Runtime version: {Environment.Version}");
        Debug.WriteLine("Hi debugger!");

        Console.WriteLine("Managed code cannot call me. But Beef can!");
    }
}
