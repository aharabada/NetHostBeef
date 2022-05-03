using System.Diagnostics;
using System.Runtime.InteropServices;

namespace DotNetBasicExample.BigTest;

public abstract class ScriptBase
{
    protected Entity Entity { get; private set; }

    protected TransformComponent Transform;

    protected virtual void OnCreate() { }
    protected virtual void OnDestroy() { }
    protected virtual void OnUpdate(GameTime gameTime) { }

    /// <summary>
    /// Creates a new instance of a Script with the given typeName.
    /// </summary>
    /// <param name="typeNamePtr">The assembly qualified typename of the script class.</param>
    /// <param name="typeNameLength">Length of <see cref="typeNamePtr"/></param>
    /// <param name="entityId">Id of the entity to which this script belongs.</param>
    /// <param name="scene">Pointer to the native scene object.</param>
    /// <param name="transformPtr">Pointer to the transform Component of the entity</param>
    /// <returns>A pointer to the handle that holds the newly created script instance. Or <see langword="null"/> if the creation failed.</returns>
    [UnmanagedCallersOnly]
    public static IntPtr CreateInstance(IntPtr typeNamePtr, int typeNameLength, EntityId entityId, IntPtr scene, IntPtr transformPtr)
    {
        try
        {
            string typeName = Marshal.PtrToStringUTF8(typeNamePtr, typeNameLength);

            Type? type = Type.GetType(typeName, true);

            Debug.Assert(type != null, "Type not found.");

            object? instance = Activator.CreateInstance(type);

            Debug.Assert(instance != null, "Instance could not be created");

            Debug.Assert(instance is ScriptBase, $"Activated instance doesn't inherit from {nameof(ScriptBase)}");

            if (instance is not ScriptBase script)
                return IntPtr.Zero;

            script.Entity = new Entity(entityId, scene);
            script.Transform = new TransformComponent(transformPtr);
            
            script.OnCreate();

            // Allocate a Handle to the instance so that the garbage collector doesn't think it's unused.
            // Important: Remember to use GCHandle.Free() to release the handle once the instance isn't needed anymore to avoid memory leaks.
            GCHandle handle = GCHandle.Alloc(instance);
            return GCHandle.ToIntPtr(handle);
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }

    /// <summary>
    /// Updated the given script instance.
    /// </summary>
    /// <param name="scriptPtr">Pointer to the native script instance which was created by <see cref="CreateInstance"/>.</param>
    /// <param name="frameCount"></param>
    /// <param name="totalTime"></param>
    /// <param name="frameTime"></param>
    [UnmanagedCallersOnly]
    public static void UpdateInstance(IntPtr scriptPtr, ulong frameCount, TimeSpan totalTime, TimeSpan frameTime)
    {
        GCHandle entityHandle = GCHandle.FromIntPtr(scriptPtr);

        if (entityHandle.Target is ScriptBase script)
        {
            GameTime gameTime = new(frameCount, totalTime, frameTime);

            script.OnUpdate(gameTime);
        }
    }

    /// <summary>
    /// Destroys the given script instance.
    /// </summary>
    /// <param name="scriptPtr">Pointer to the native script instance which was created by <see cref="CreateInstance"/>.</param>
    [UnmanagedCallersOnly]
    public static void DestroyInstance(IntPtr scriptPtr)
    {
        GCHandle entityHandle = GCHandle.FromIntPtr(scriptPtr);

        if (entityHandle.Target is ScriptBase script)
        {
            script.OnDestroy();
        }

        // Free the handle so that the garbage collector can collect our script instance.
        entityHandle.Free();
    }
}
