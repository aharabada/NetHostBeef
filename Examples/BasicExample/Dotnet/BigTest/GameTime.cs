namespace DotNetBasicExample.BigTest;

public class GameTime
{
    private ulong _frameCount;

    private TimeSpan _totalTime;
    private TimeSpan _frameTime;

    /// <summary>
    /// Number of frames that passed since the application started.
    /// </summary>
    public ulong FrameCount => _frameCount;
    /// <summary>
    /// Time that passed since the application started.
    /// </summary>
    public TimeSpan TotalTime => _totalTime;
    /// <summary>
    /// Time that passed since the last frame.
    /// </summary>
    public TimeSpan FrameTime => _frameTime;

    public float DeltaTime => (float)_frameTime.TotalSeconds;
    public float TotalSeconds => (float)_totalTime.TotalSeconds;

    internal GameTime(ulong frameCount, TimeSpan totalTime, TimeSpan frameTime)
    {
        _frameCount = frameCount;
        _totalTime = totalTime;
        _frameTime = frameTime;
    }
}
