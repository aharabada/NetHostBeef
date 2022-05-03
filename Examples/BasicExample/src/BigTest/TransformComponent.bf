using System;

namespace BasicExample.BigTest
{
	// Ordered to make sure that the Fields wont be reordered thus ensuring that our struct layout
	// matches the layout in DotNet
	[Ordered]
	struct TransformComponent
	{
		private Vector3 _position = .(0, 0, 0);
		private Quaternion _rotation = .(0, 0, 0, 1);
		private Vector3 _scale = .(1, 1, 1);

		private Matrix4x4 _transform = .(_position, _scale);

		private bool _isDirty;

		public Vector3 Position
		{
		    get => _position;
		    set mut
		    {
		        if (_position == value)
		            return;

		        _position = value;
		        _isDirty = true;
		    }
		}

		public Quaternion Rotation
		{
		    get => _rotation;
		    set mut
		    {
		        if (_rotation == value)
		            return;

		        _rotation = value;
		        _isDirty = true;
		    }
		}

		public Vector3 Scale
		{
		    get => _scale;
		    set mut
		    {
		        if (_scale == value)
		            return;

		        _scale = value;
		        _isDirty = true;
		    }
		}

		public Matrix4x4 Transform
		{
		    get => _transform;
		    set mut
		    {
		        if (_transform == value)
		            return;
		        
		        _transform = value;
		        _isDirty = false;

				// Decomposition not implemented
		        //Matrix4x4.Decompose(_transform, out _scale, out _rotation, out _position);
		    }
		}

		public bool IsDirty => _isDirty;
	}
}