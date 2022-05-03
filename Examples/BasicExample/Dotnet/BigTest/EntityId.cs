namespace DotNetBasicExample.BigTest;

public struct EntityId
{
    public static readonly EntityId InvalidEntity = new(uint.MaxValue, 0);

    private readonly ulong _id;

    public uint Version => (uint)_id;

    public uint Index => (uint)(_id >> 32);

    public bool IsValid => Index != InvalidEntity.Index;

    public EntityId(uint index, uint version)
    {
        _id = ((ulong)index << 32) | version;
    }

    public static bool operator ==(EntityId left, EntityId right)
    {
        return left._id == right._id;
    }

    public static bool operator !=(EntityId left, EntityId right)
    {
        return left._id != right._id;
    }
}
