using System;
using System.Interop;

using internal NetHostBeef;

namespace NetHostBeef
{
	static class NetHost
	{
		public struct get_hostfxr_parameters
		{
		    public c_size size;
		    public char_t* assembly_path;
		    public char_t* dotnet_root;
		};

		[CallingConvention(.Stdcall), CLink]
		public static extern int get_hostfxr_path(
			char_t* buffer,
			c_size* buffer_size,
			get_hostfxr_parameters* parameters);
	}
}