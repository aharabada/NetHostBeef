using System.Numerics;

namespace DotNetBasicExample.BigTest;

public class TestScript : ScriptBase
{
    protected override void OnCreate()
    {
        Console.WriteLine($"Initializing Script {Entity.Handle.Index}!");
    }

    protected override void OnUpdate(GameTime gameTime)
    {
        Console.WriteLine($"Updating Script {Entity.Handle.Index}!");
        Console.WriteLine($"My Position is:\n {Transform.Position}");

        // Move entity up and down
        float f = (float)Math.Sin(gameTime.TotalSeconds);

        Vector3 pos = Transform.Position;
        pos.Y = f;

        Transform.Position = pos;
        
        // Change the scale
        float fx = MathF.Sin(gameTime.TotalSeconds * 2) / 2 + 1;
        float fy = MathF.Cos(gameTime.TotalSeconds * 2) / 2 + 1;

        Vector3 scl = Transform.Scale;

        scl.X = fx;
        scl.Y = fy;

        Transform.Scale = scl;

        // Rotate (Note: doesn't do anything because its not implemented on the beef side)
        float fr = MathF.Cos(gameTime.TotalSeconds / 4) * MathF.PI * 10;

        Transform.Rotation = Quaternion.CreateFromYawPitchRoll(0, 0, fr);
    }

    protected override void OnDestroy()
    {
        Console.WriteLine($"Destroying Script {Entity.Handle.Index}!");
    }
}
