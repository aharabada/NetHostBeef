using System;
using System.Diagnostics;
using System.Interop;

namespace NetHostBeef
{
	class NetHostHelper
	{
		/// Finds and loads the HostFxr library
		public static void* LoadHostFxrLibrary()
		{
			char_t[256] hostFxrPath = ?;
			c_size bufferSize = hostFxrPath.Count;
			int rc = NetHost.get_hostfxr_path(&hostFxrPath, &bufferSize, null);

			Debug.Assert(rc == 0);

			// Load hostfxr
			return LoadLibrary(&hostFxrPath);
		}

		/// Returns a scoped string that can be passed to the nethost/hostfxr/coreclr libraries
		public static mixin GetScopedRawPtr(StringView str)
		{
#if BF_PLATFORM_WINDOWS
			str.ToScopedNativeWChar!:mixin()
#else
			str.ToScopeCStr!:mixin()
#endif
		}

#if BF_PLATFORM_WINDOWS
		public static void* LoadLibrary(char_t* path)
		{
			Windows.HInstance handle = Windows.LoadLibraryW(path);

			Debug.Assert(handle != 0);

			return (void*)(int)handle;
		}

	    public static T GetExport<T>(void* handle, char8* name) where T : operator explicit void*
	    {
	        void* f = Windows.GetProcAddress((Windows.HModule)(int)handle, name);
			
			Debug.Assert(f != null);

	        return (T)f;
	    }
#else

#endif
	}
}