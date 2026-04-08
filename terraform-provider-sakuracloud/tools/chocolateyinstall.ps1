$ErrorActionPreference = 'Stop';

$packageName  = $env:ChocolateyPackageName;
$toolsDir     = Join-Path $env:APPDATA "terraform.d/plugins/"
$softwareName = 'terraform-provider-sakuracloud*';
$url          = '__URL_32__';
$url64        = '__URL_64__';
$checkSum     = 'sha512';
$hash32       = '__HASH32__';
$hash64       = '__HASH64__';

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url
  url64bit      = $url64
  softwareName  = $softwareName
  checksum      = $hash32
  checksumType  = $checkSum
  checksum64    = $hash64
  checksumType64= $checkSum
}

# 1. Install Package
Install-ChocolateyZipPackage @packageArgs

# 2. Check terraform.rc file
$terraformrcPath = Join-Path $env:APPDATA "terraform.rc";
if (Test-Path -path $terraformrcPath) {
  $hasOtherProvider = $false;
  foreach ($line in (Get-Content -Path $terraformrcPath)) {
    if (($line.Contains(" = ")) -and (-not ($line.Contains("sakuracloud =")))) {
      $hasOtherProvider = $true;
      break;
    }
  }
  if (-not $hasOtherProvider) {
    Remove-Item -Path $terraformrcPath;
  } else {
    Write-Warning -Message '';
    Write-Warning -Message '************ W A R N I N G ************';
    Write-Warning -Message '';
    Write-Warning -Message ' Because "terraform.rc" file exists and file is in use,';
    Write-Warning -Message ' automatic deletion could not be done.';
    Write-Warning -Message '';
    Write-Warning -Message ' It is confirmed that if you do not delete the "terraform.rc" file,';
    Write-Warning -Message ' the plugin will not work properly.';
    Write-Warning -Message '';
    Write-Warning -Message ' "Terraform-provider-sakuracloud" is installed in';
    Write-Warning -Message ' "%APPDATA%\terraform.d\plugins",';
    Write-Warning -Message ' so the "terraform.rc" file is unnecessary.';
    Write-Warning -Message '';
    Write-Warning -Message ' Check the contents of "%APPDATA%\terraform.rc" file and delete it!';
    Write-Warning -Message '';
    Write-Warning -Message ' Please Check GitHub Page!';
    Write-Warning -Message '';
    Write-Warning -Message ' https://github.com/sacloud/chocolatey/wiki/About-terraform.rc-file';
    Write-Warning -Message '';
    Write-Warning -Message '----------------------------------------';
    Write-Warning -Message '';
    Write-Warning -Message ' すでに、 "terraform.rc" ファイルが存在しており使用中のため、自動削除ができませんでした。';
    Write-Warning -Message '';
    Write-Warning -Message ' "terraform.rc" ファイルを削除しないと、プラグインが正しく動作しません。';
    Write-Warning -Message '';
    Write-Warning -Message ' "terraform-provider-sakuracloud" は、';
    Write-Warning -Message ' "%APPDATA%\terraform.d\plugins" にインストールされるため、';
    Write-Warning -Message ' "terraform.rc" ファイルは不要です。';
    Write-Warning -Message '';
    Write-Warning -Message ' "%APPDATA%\terraform.rc" の内容を確認して削除してください。';
    Write-Warning -Message '';
    Write-Warning -Message ' 詳細は、GitHubページを確認してください。';
    Write-Warning -Message '';
    Write-Warning -Message ' https://github.com/sacloud/chocolatey/wiki/About-terraform.rc-file';
    Write-Warning -Message '';
    Write-Warning -Message '***************************************';
    Write-Warning -Message '';
  }
}
