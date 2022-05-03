namespace DotNetBasicExample.BigTest;

public struct Entity
{
    public EntityId Handle { get; }
    public IntPtr Scene { get; }
    
    public Entity(EntityId handle, IntPtr scene)
    {
        Handle = handle;
        Scene = scene;
    }
}
