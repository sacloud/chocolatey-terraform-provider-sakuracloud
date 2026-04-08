$ErrorActionPreference = 'Stop';

$packageName = $env:ChocolateyPackageName;

Uninstall-ChocolateyZipPackage -PackageName $packageName -ZipFileName 'terraform-provider-sakuracloud___VERSION___windows_386.zip'
Uninstall-ChocolateyZipPackage -PackageName $packageName -ZipFileName 'terraform-provider-sakuracloud___VERSION___windows_amd64.zip'
