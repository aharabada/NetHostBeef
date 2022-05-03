using System.Numerics;
using System.Runtime.InteropServices;

namespace DotNetBasicExample.BigTest;

/// <summary>
/// A convenience wrapper providing simple access to the native TransformComponent.
/// This struct is marked as "unsafe" so that we can do unholy pointer stuff inside it.
/// </summary>
public unsafe struct TransformComponent
{
    /// <summary>
    /// A struct that matches the memory layout of the native struct.
    /// Fixed the order of the Fields and tightly pack them so that the memory layout is identical to the layout in beef.
    /// </summary>
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    private struct TransformComponentData
    {
        internal Vector3 _position;
        internal Quaternion _rotation;
        internal Vector3 _scale;
        
        internal Matrix4x4 _transform;

        internal bool _isDirty;
    }

    /// <summary>
    /// Pointer to the native struct.
    /// </summary>
    private TransformComponentData* _component;

    /// <summary>
    /// Creates a new wrapper around the native transform component.
    /// </summary>
    /// <param name="component">Pointer to the native component.</param>
    internal TransformComponent(IntPtr component)
    {
        _component = (TransformComponentData*)component;
    }

    public Vector3 Position
    {
        get => _component->_position;
        set
        {
            if (_component->_position == value)
                return;

            _component->_position = value;
            _component->_isDirty = true;
        }
    }

    public Quaternion Rotation
    {
        get => _component->_rotation;
        set
        {
            if (_component->_rotation == value)
                return;

            _component->_rotation = value;
            _component->_isDirty = true;
        }
    }

    public Vector3 Scale
    {
        get => _component->_scale;
        set
        {
            if (_component->_scale == value)
                return;

            _component->_scale = value;
            _component->_isDirty = true;
        }
    }

    public Matrix4x4 Transform
    {
        get => _component->_transform;
        set
        {
            if (_component->_transform == value)
                return;
            
            _component->_transform = value;
            _component->_isDirty = false;

            Matrix4x4.Decompose(_component->_transform, out _component->_scale, out _component->_rotation, out _component->_position);
        }
    }
}
