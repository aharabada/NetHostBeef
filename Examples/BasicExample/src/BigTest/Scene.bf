using System;
using NetHostBeef;
namespace BasicExample.BigTest
{
	class Scene
	{
		const int c_Instances = 2;

		TransformComponent[] Component = new .[c_Instances] ~ delete _;

		void*[] Scripts = new .[c_Instances] ~ delete _;

		typealias CreateInstanceFn = function [CallingConvention(.Stdcall)] void*(
			char8* typeNamePtr,
			int32 typeNameLength,
			EntityId entityId,
			void* scenePtr,
			TransformComponent* transformPtr);

		typealias UpdateInstanceFn = function [CallingConvention(.Stdcall)] void(
			void* scriptInstance,
			uint64 frameCount,
			TimeSpan totalTime,
			TimeSpan frameTime);
		
		typealias DestroyInstanceFn = function [CallingConvention(.Stdcall)] void(void* scriptInstance);

		CreateInstanceFn CreateManagedInstance;
		UpdateInstanceFn UpdateManagedInstance;
		DestroyInstanceFn DestroyManagedInstance;

		public this()
		{
			// Get function to create managed script
			Program.GetFunctionPointerUnmanagedCallersOnly<CreateInstanceFn>(
				"DotNetBasicExample.BigTest.ScriptBase, DotNetBasicExample",
				"CreateInstance",
				out CreateManagedInstance);

			// Get function to update managed script
			Program.GetFunctionPointerUnmanagedCallersOnly<UpdateInstanceFn>(
				"DotNetBasicExample.BigTest.ScriptBase, DotNetBasicExample",
				"UpdateInstance",
				out UpdateManagedInstance);

			// Get function to destroy managed script
			Program.GetFunctionPointerUnmanagedCallersOnly<DestroyInstanceFn>(
				"DotNetBasicExample.BigTest.ScriptBase, DotNetBasicExample",
				"DestroyInstance",
				out DestroyManagedInstance);

			// Initialize transforms
			for (int i < c_Instances)
			{
				Component[i] = .();
				Component[i].Position = .(i, 0, 0);
			}

			String typeName = "DotNetBasicExample.BigTest.TestScript, DotNetBasicExample";

			// Initialize Scripts on C# side
			for (int i < c_Instances)
			{
				Scripts[i] = CreateManagedInstance(typeName, (int32)typeName.Length,
					EntityId((uint32)i, 420),
					Internal.UnsafeCastToPtr(this),
					&Component[0]);
			}
		}

		public ~this()
		{
			// Destroy managed instances
			for (int i < c_Instances)
			{
				DestroyManagedInstance(Scripts[i]);
				Scripts[i] = null;
			}
		}

		GameTime _gameTime = new GameTime()..Start() ~ delete _;

		public void Update()
		{
			_gameTime.NewFrame();

			// Update scripts
			for (int i < c_Instances)
			{
				UpdateManagedInstance(Scripts[i], _gameTime.FrameCount, _gameTime.TotalTime, _gameTime.FrameTime);
			}

			// Update transforms
			for (int i < c_Instances)
			{
				if (Component[i].IsDirty)
				{
					Component[i].[Friend]_transform = Matrix4x4(Component[i].Position, Component[i].Scale);
					Component[i].[Friend]_isDirty = false;
				}
			}
		}
	}
}