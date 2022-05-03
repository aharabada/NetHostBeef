namespace BasicExample.BigTest
{
	struct EntityId : uint64
	{
	    public static readonly EntityId InvalidEntity = EntityId(uint32.MaxValue, 0);

	    public uint32 Version => (uint32)this;

	    public uint32 Index => (uint32)(this >> 32);

	    public bool IsValid => Index != InvalidEntity.Index;

	    public this(uint32 index, uint32 version)
	    {
	        this = ((uint64)index << 32) | version;
	    }
	}
}