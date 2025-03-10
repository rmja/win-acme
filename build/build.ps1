﻿param (
	[Parameter(Mandatory=$true)]
	[ValidatePattern("^\d+\.\d+.\d+.\d+")]
	[string]
	$ReleaseVersionNumber
)

$PSScriptFilePath = Get-Item $MyInvocation.MyCommand.Path
$RepoRoot = $PSScriptFilePath.Directory.Parent.FullName
$BuildFolder = Join-Path -Path $RepoRoot "build"

# Restore NuGet packages
& dotnet restore $RepoRoot\src\main\wacs.csproj

# Clean solution
& dotnet clean $RepoRoot\src\main\wacs.csproj -c "Release" -r win-x64 --self-contained
& dotnet clean $RepoRoot\src\main\wacs.csproj -c "Release" -r win-x86 --self-contained
& dotnet clean $RepoRoot\src\main\wacs.csproj -c "Release" -r win-arm64 --self-contained
& dotnet clean $RepoRoot\src\main\wacs.csproj -c "ReleasePluggable" -r win-x64 --self-contained
& dotnet clean $RepoRoot\src\main\wacs.csproj -c "ReleasePluggable" -r win-x86 --self-contained 
& dotnet clean $RepoRoot\src\main\wacs.csproj -c "ReleasePluggable" -r win-arm64 --self-contained 

# Build main
& dotnet pack $RepoRoot\src\main\wacs.csproj -c "ReleasePluggable"
& dotnet publish $RepoRoot\src\main\wacs.csproj -c "Release" -r win-x64 --self-contained /p:PublishSingleFile=true /p:PublishTrimmed=true /p:IncludeNativeLibrariesForSelfExtract=true /p:BuiltInComInteropSupport=true
& dotnet publish $RepoRoot\src\main\wacs.csproj -c "Release" -r win-x86 --self-contained /p:PublishSingleFile=true /p:PublishTrimmed=true /p:IncludeNativeLibrariesForSelfExtract=true /p:BuiltInComInteropSupport=true
& dotnet publish $RepoRoot\src\main\wacs.csproj -c "Release" -r win-arm64 --self-contained /p:PublishSingleFile=true /p:PublishTrimmed=true /p:IncludeNativeLibrariesForSelfExtract=true /p:BuiltInComInteropSupport=true
& dotnet publish $RepoRoot\src\main\wacs.csproj -c "ReleasePluggable" -r win-x64 --self-contained /p:PublishSingleFile=true /p:IncludeNativeLibrariesForSelfExtract=true
& dotnet publish $RepoRoot\src\main\wacs.csproj -c "ReleasePluggable" -r win-x86 --self-contained /p:PublishSingleFile=true /p:IncludeNativeLibrariesForSelfExtract=true
& dotnet publish $RepoRoot\src\main\wacs.csproj -c "ReleasePluggable" -r win-arm64 --self-contained /p:PublishSingleFile=true /p:IncludeNativeLibrariesForSelfExtract=true

& dotnet publish $RepoRoot\src\plugin.store.keyvault\wacs.store.keyvault.csproj -c "Release"
& dotnet publish $RepoRoot\src\plugin.validation.dns.azure\wacs.validation.dns.azure.csproj -c "Release"
& dotnet publish $RepoRoot\src\plugin.validation.dns.cloudflare\wacs.validation.dns.cloudflare.csproj -c "Release"
& dotnet publish $RepoRoot\src\plugin.validation.dns.digitalocean\wacs.validation.dns.digitalocean.csproj -c "Release"
& dotnet publish $RepoRoot\src\plugin.validation.dns.domeneshop\wacs.validation.dns.domeneshop.csproj -c "Release"
& dotnet publish $RepoRoot\src\plugin.validation.dns.dreamhost\wacs.validation.dns.dreamhost.csproj -c "Release"
& dotnet publish $RepoRoot\src\plugin.validation.dns.godaddy\wacs.validation.dns.godaddy.csproj -c "Release"
& dotnet publish $RepoRoot\src\plugin.validation.dns.googledns\wacs.validation.dns.googledns.csproj -c "Release"
& dotnet publish $RepoRoot\src\plugin.validation.dns.luadns\wacs.validation.dns.luadns.csproj -c "Release"
& dotnet publish $RepoRoot\src\plugin.validation.dns.ns1\wacs.validation.dns.ns1.csproj -c "Release"
& dotnet publish $RepoRoot\src\plugin.validation.dns.route53\wacs.validation.dns.route53.csproj -c "Release"
& dotnet publish $RepoRoot\src\plugin.validation.dns.transip\wacs.validation.dns.transip.csproj -c "Release"
& dotnet publish $RepoRoot\src\plugin.validation.http.rest\wacs.validation.http.rest.csproj -c "Release"

if (-not $?)
{
	throw "The dotnet publish process returned an error code."
}

./create-artifacts.ps1 $RepoRoot $ReleaseVersionNumber