# NetHostBeef

Provides Beef bindings for the nethost/hostfxr libraries which allow you to host the dotnet runtime in a beef-application and invoke managed methods from native code.

**Note:** The bindings are currently only for 64bit Windows but adding support for other platforms should be fairly easy.

## Examples
This repository contains an example project which initalizes the dotnet runtime and invokes managed methods. It is configured to automatically compile the C# project alongside the beef project. In order to start the example you have to have the dotnet-cli installed (i.e. the command `dotnet` has to be available in cmd)

As starting points for more information about using the nethost library refer to the [native hosting design document](https://github.com/dotnet/runtime/blob/main/docs/design/features/native-hosting.md) and how to [write a custom .NET host to control the .NET runtime from your native code](https://docs.microsoft.com/en-us/dotnet/core/tutorials/netcore-hosting).

## Preparing the bindings
Before you can use the bindings you have to download the [Microsoft.NETCore.App.Host](https://www.nuget.org/packages/Microsoft.NETCore.App.Host.win-x64) nuget-package for your target platform. The repository also contains a powershell-script which downloads the x64-win package and unzips it to the correct location.

If you download it manually simply open the nuget-package as a zip-file and extract its contents to `NetHostBeef/nethost`.
