$tempFile = "./package.zip"

# Download nethost package for 64bit windows
Invoke-WebRequest "https://www.nuget.org/api/v2/package/Microsoft.NETCore.App.Host.win-x64/" -OutFile $tempFile

Expand-Archive $tempFile -DestinationPath "./NetHostBeef/nethost/"

# Remove package
Remove-Item $tempFile