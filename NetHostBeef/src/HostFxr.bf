using System;
using System.Interop;

namespace NetHostBeef
{
	static class HostFxr
	{
		public enum DelegateType : c_int
		{
		    ComActivation,
		    LoadInMemoryAssembly,
		    WinrtActivation,
		    ComRegister,
		    ComUnregister,
		    LoadAssemblyAndGetFunctionPointer,
		    GetFunctionPointer,
		}
		
		public typealias MainFn = function [CallingConvention(.Cdecl)] int32(c_int argc, char_t** argv);
		public typealias MainStartupinfoFn = function [CallingConvention(.Cdecl)] int32(
			c_int argc,
			char_t** argv,
			char_t* hostPath,
			char_t dotnetRoot,
			char_t appPath);

		public typealias ErrorWriterFn = function [CallingConvention(.Cdecl)] void(char_t* message);

		public typealias SetErrorWriterFn = function [CallingConvention(.Cdecl)] ErrorWriterFn(ErrorWriterFn errorWriter);
		
		public typealias Handle = void*;
		
		[CRepr]
		public struct InitializeParameters
		{
		    public c_size Size = sizeof(InitializeParameters);
		    public char_t* HostPath;
		    public char_t* DotnetRoot;
		};

		public typealias InitializeForDotnetCommandLineFn = function [CallingConvention(.Cdecl)] int32(
			c_int argc,
			char_t** argv,
			InitializeParameters* parameters,
			Handle* hostContextHandle);

		public typealias InitializeForRuntimeConfigFn = function [CallingConvention(.Cdecl)] int32(
			char_t* runtimeConfigPath,
			InitializeParameters* parameters,
			Handle* hostContextHandle);
		
		public typealias GetRuntimePropertyValueFn = function [CallingConvention(.Cdecl)] int32(
			Handle hostContextHandle,
			char_t* name,
			char_t** value);

		public typealias SetRuntimePropertyValueFn = function [CallingConvention(.Cdecl)] int32(
			Handle hostContextHandle,
			char_t* name,
			char_t* value);

		public typealias GetRuntimePropertiesFn = function [CallingConvention(.Cdecl)] int32(
			Handle hostContextHandle,
			c_size* count,
			char_t** keys,
			char_t** values);
		
		public typealias RunAppFn = function [CallingConvention(.Cdecl)] int32(Handle hostContextHandle);

		public typealias GetRuntimeDelegateFn = function [CallingConvention(.Cdecl)] int32(Handle host_context_handle, DelegateType type, void** outDelegate);

		public typealias CloseFn = function [CallingConvention(.Cdecl)] int32(Handle hostContextHandle);

		[CRepr]
		public struct DotnetEnvironmentSdkInfo
		{
		    public c_size Size = sizeof(Self);
		    public char_t* Version;
		    public char_t* Path;
		};

		public typealias GetDotnetEnvironmentInfoResultFn = function [CallingConvention(.Cdecl)] void(DotnetEnvironmentInfo* info, void* resultContext);
		
		[CRepr]
		public struct DotnetEnvironmentFrameworkInfo
		{
		    public c_size Size = sizeof(Self);
		    public char_t* Name;
		    public char_t* Version;
		    public char_t* Path;
		};
		
		[CRepr]
		public struct DotnetEnvironmentInfo
		{
		    public c_size Size = sizeof(Self);

		    public char_t* HostfxrVersion;
		    public char_t* HostfxrCommitHash;

		    public c_size SdkCount;
		    public DotnetEnvironmentSdkInfo* Sdks;

		    public c_size FrameworkCount;
		    public DotnetEnvironmentFrameworkInfo* Frameworks;
		};
	}
}