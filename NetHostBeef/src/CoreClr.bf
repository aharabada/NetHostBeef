using System;
using System.Interop;

namespace NetHostBeef
{
	static
	{
#if BF_PLATFORM_WINDOWS
		public typealias char_t = char16;
#else
		public typealias char_t = char8;
#endif
	}

	static class CoreClr
	{
		public const char_t* UNMANAGEDCALLERSONLY_METHOD = (char_t*)(void*)-1;

		/// Signature of delegate returned by LoadAssemblyAndGetFunctionPointerFn when delegateTypeName is null.
		public typealias DefaultEntryPoint = function [CallingConvention(.Stdcall)] c_int(void* arg, int32 argSizeInBytes);

		public typealias LoadAssemblyAndGetFunctionPointerFn = function [CallingConvention(.Stdcall)] c_int(
			char_t* assemblyPath,
    		char_t* typeName,
    		char_t* methodName,
    		char_t* delegateTypeName,
    		void* reserved,
    		out void* outDelegate);

		public typealias GetFunctionPointerFn = function [CallingConvention(.Stdcall)] c_int(
			char_t* typeName,
			char_t* MethodName,
			char_t* delegateTypeName,
			void* loadContext,
			void* reserved,
			out void* outDelegate);
	}
}