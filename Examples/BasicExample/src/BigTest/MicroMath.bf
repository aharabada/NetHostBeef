namespace BasicExample.BigTest
{
	struct Vector3 : this(float X, float Y, float Z)
	{
	}

	struct Vector4 : this(float X, float Y, float Z, float W)
	{
	}
	
	struct Quaternion : Vector4
	{
		public this(float X, float Y, float Z, float W) : base(X, Y, Z, W)
		{

		}
	}
	
	struct Matrix4x4
	{
		public Vector4[4] Columns;

		public this(Vector3 position, Vector3 scale)
		{
			Columns = default;
			
			Columns[0] = .(scale.X, 0, 0, 0);
			Columns[1] = .(0, scale.Y, 0, 0);
			Columns[2] = .(0, 0, scale.Z, 0);
			Columns[3] = .(position.X, position.Y, position.Z, 1);
		}
	}
}