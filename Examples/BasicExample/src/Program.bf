// Note: This example is only works with DotNet 5 and up

using System;
using NetHostBeef;
using System.Interop;
using System.Diagnostics;
using System.IO;
using BasicExample.BigTest;
using System.Threading;

namespace BasicExample
{
	class Program
	{
		static HostFxr.InitializeForDotnetCommandLineFn HostFxr_Init;
		static HostFxr.GetRuntimeDelegateFn HostFxr_GetDelegate;
		static HostFxr.CloseFn HostFxr_Close;

		static CoreClr.LoadAssemblyAndGetFunctionPointerFn LoadAssemblyAndGetFunctionPointerFn;
		static CoreClr.GetFunctionPointerFn GetFunctionPointerFn;

		[Ordered]
		struct ArgStruct
		{
			public char8* Text;
			public float Number;
		}

		public static int Main(String[] args)
		{
			LoadHostFxr();
			InitAndStartRuntime();

			Console.WriteLine("Test 1: Call function with default entry point...\n");

			// Test calling a function with the default entry point
			CoreClr.DefaultEntryPoint test1;
			GetFunctionPointerDefaultDelegate("DotNetBasicExample.Lib, DotNetBasicExample", "Test1", out test1);

			for (int i = 0; i < 3; i++)
			{
				String message = scope $"Hello {i}";

				ArgStruct arg = .()
				{
					Text = message,
					Number = i
				};

				int rv = test1(&arg, sizeof(ArgStruct));

				Console.WriteLine($"Beef: The return value is {rv}");
			}

			Console.WriteLine("\n\nTest 2: Call function with custom entry point...\n");

			// Test custom function signature
			GetFunctionPointer<function float(float x, float y)>("DotNetBasicExample.Lib, DotNetBasicExample", "Test2",
				"DotNetBasicExample.Lib+Test2Delegate, DotNetBasicExample", let test2);

			float result = test2(13.37f, 42f);

			Debug.Assert(result == (13.37f + 42f));

			Console.WriteLine($"Beef: C# can add numbers!");
			
			Console.WriteLine("\n\nTest 3: Call function with custom entry point and UnmanagedCallersOnlyAttribute...\n");

			// Test function with "UnmanagedCallersOnlyAttribute"
			GetFunctionPointerUnmanagedCallersOnly<function void()>("DotNetBasicExample.Lib, DotNetBasicExample", "Test3",
				let test3);

			test3();
			
			Console.WriteLine("\n\nTest 4: Directly work on unmanaged memory (Pointy stuff in C#)...\n");

			Scene scene = new .();

			while (true)
			{
				scene.Update();
			
				Console.WriteLine("Press enter to continue to the next frame...");
				Console.ReadLine(scope .());
			}

			delete scene;

			Console.Read();

			return 0;
		}

		static void LoadHostFxr()
 		{
			char_t[256] buffer = ?;
			c_size bufferSize = buffer.Count;
			int rc = NetHost.get_hostfxr_path(&buffer, &bufferSize, null);
			
			Debug.Assert(rc == 0);
			
			// Load hostfxr and get desired exports
			void* lib = NetHostHelper.LoadLibrary(&buffer);
			HostFxr_Init = NetHostHelper.GetExport<HostFxr.InitializeForDotnetCommandLineFn>(lib, "hostfxr_initialize_for_dotnet_command_line");
			HostFxr_GetDelegate = NetHostHelper.GetExport<HostFxr.GetRuntimeDelegateFn>(lib, "hostfxr_get_runtime_delegate");
			HostFxr_Close = NetHostHelper.GetExport<HostFxr.CloseFn>(lib, "hostfxr_close");
			
			Debug.Assert(HostFxr_Init != null && HostFxr_GetDelegate != null && HostFxr_Close != null);
		}

		static void InitAndStartRuntime()
		{
			String exePath = scope .();
			Environment.GetExecutableFilePath(exePath);
			String exeDir = scope .();
			Path.GetDirectoryPath(exePath, exeDir);
			Path.InternalCombine(exeDir, "DotNetBasicExample.dll");

			char_t* ptr = NetHostHelper.GetScopedRawPtr!(exeDir);

			char_t*[2] args = char_t*[](
				ptr,
				null
			);

			HostFxr.Handle cxt = null;

			int rc = HostFxr_Init(1, &args, null, &cxt);

			if (rc != 0 || cxt == null)
			{
				Debug.WriteLine($"Init failed: {rc}");
			    HostFxr_Close(cxt);

				Debug.Assert(rc == 0);

			    return;
			}

			Debug.Assert(rc == 0);

			rc = HostFxr_GetDelegate(cxt, .LoadAssemblyAndGetFunctionPointer, (void**)&LoadAssemblyAndGetFunctionPointerFn);

			Debug.Assert(rc == 0, scope $"Get delegate failed: {rc}");

			rc = HostFxr_GetDelegate(cxt, .GetFunctionPointer, (void**)&GetFunctionPointerFn);

			Debug.Assert(rc == 0, scope $"Get delegate failed: {rc}");

			HostFxr_Close(cxt);
		}

		/**
		 * Loads the specified assembly and returns a function pointer to the specified method.
		 * Note: When using "hostfxr_initialize_for_dotnet_command_line" (as we do in this example) don't use this function to get functionpointss
		 * for methods from the main assembly.
		 */
		public static int LoadAssemblyAndGetFunctionPointer<T>(StringView libraryPath, StringView typeName, StringView methodName, StringView delegateName, out T outDelegate) where T: operator explicit void*
		{
			void* funPtr = null;

			int rc = LoadAssemblyAndGetFunctionPointerFn(NetHostHelper.GetScopedRawPtr!(libraryPath),
				NetHostHelper.GetScopedRawPtr!(typeName), NetHostHelper.GetScopedRawPtr!(methodName),
				NetHostHelper.GetScopedRawPtr!(delegateName), null, out funPtr);

			outDelegate = (T)funPtr;

			return rc;
		}

		public static int GetFunctionPointer<T>(StringView typeName, StringView methodName, StringView delegateName, out T outDelegate) where T: operator explicit void*
		{
			void* funPtr = null;

			int rc = GetFunctionPointerFn(NetHostHelper.GetScopedRawPtr!(typeName),
				NetHostHelper.GetScopedRawPtr!(methodName), NetHostHelper.GetScopedRawPtr!(delegateName),
				null, null, out funPtr);

			outDelegate = (T)funPtr;

			return rc;
		}

		public static int GetFunctionPointerDefaultDelegate(StringView typeName, StringView methodName, out CoreClr.DefaultEntryPoint outDelegate)
		{
			void* funPtr = null;

			int rc = GetFunctionPointerFn(NetHostHelper.GetScopedRawPtr!(typeName),
				NetHostHelper.GetScopedRawPtr!(methodName), null, null, null, out funPtr);

			outDelegate = (CoreClr.DefaultEntryPoint)funPtr;

			return rc;
		}

		public static int GetFunctionPointerUnmanagedCallersOnly<T>(StringView typeName, StringView methodName, out T outDelegate) where T: operator explicit void*
		{
			void* funPtr = null;

			int rc = GetFunctionPointerFn(NetHostHelper.GetScopedRawPtr!(typeName),
				NetHostHelper.GetScopedRawPtr!(methodName), CoreClr.UNMANAGEDCALLERSONLY_METHOD, null, null, out funPtr);

			outDelegate = (T)funPtr;

			return rc;
		}
	}
}