# chocolatey-terraform-provider-sakuracloud

[terraform-provider-sakuracloud](https://github.com/sacloud/terraform-provider-sakuracloud)（さくらのクラウド用Terraformプロバイダー）の[Chocolatey](https://community.chocolatey.org/packages/terraform-provider-sakuracloud)パッケージです。

[![Chocolatey Package](https://github.com/sacloud/chocolatey-terraform-provider-sakuracloud/actions/workflows/chocolatey.yml/badge.svg)](https://github.com/sacloud/chocolatey-terraform-provider-sakuracloud/actions/workflows/chocolatey.yml)

## インストール

```powershell
choco install terraform-provider-sakuracloud
```

### アップデート

```powershell
choco upgrade terraform-provider-sakuracloud
```

### アンインストール

```powershell
choco uninstall terraform-provider-sakuracloud
```

## CI/CD

GitHub Actionsによる自動ビルド・配信を行っています。

### 処理の流れ

1. GitHub APIから[sacloud/terraform-provider-sakuracloud](https://github.com/sacloud/terraform-provider-sakuracloud)の最新リリースバージョンを取得
2. Chocolatey上の登録済みバージョン（審査中を含む）と比較し、同一であればスキップ
3. Windows 32bit/64bitのzipをダウンロードしSHA512ハッシュを算出
4. テンプレートファイルのプレースホルダーを実際の値に置換
5. `choco pack`で`.nupkg`を生成
6. ローカルインストールテスト（`choco install` → `choco uninstall`）
7. テスト成功後、Chocolateyへ自動push

### 定時ビルド

GitHub Actionsのスケジュール実行により、毎日UTC 0:00（JST 9:00）にterraform-provider-sakuracloudの新バージョンを確認しています。

新バージョンが検出された場合のみビルド・配信が実行されます。

## ローカルビルド

手動でパッケージをビルド・テストする場合の手順です。

```powershell
# 最新バージョンの取得
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/sacloud/terraform-provider-sakuracloud/releases/latest"
$version = $release.tag_name -replace "^v", ""

# zipのダウンロードとハッシュ算出
$url32 = "https://github.com/sacloud/terraform-provider-sakuracloud/releases/download/v${version}/terraform-provider-sakuracloud_${version}_windows_386.zip"
$url64 = "https://github.com/sacloud/terraform-provider-sakuracloud/releases/download/v${version}/terraform-provider-sakuracloud_${version}_windows_amd64.zip"
Invoke-WebRequest $url32 -OutFile .\x32.zip
Invoke-WebRequest $url64 -OutFile .\x64.zip
$hash32 = (Get-FileHash .\x32.zip -Algorithm SHA512).Hash
$hash64 = (Get-FileHash .\x64.zip -Algorithm SHA512).Hash

# プレースホルダーの置換
cd terraform-provider-sakuracloud
(Get-Content '.\terraform-provider-sakuracloud.nuspec' -Raw).Replace("__VERSION__", $version) | Out-File '.\terraform-provider-sakuracloud.nuspec' -Encoding utf8NoBOM
(Get-Content '.\tools\chocolateyinstall.ps1' -Raw).Replace("__URL_32__", $url32).Replace("__URL_64__", $url64).Replace("__HASH32__", $hash32).Replace("__HASH64__", $hash64) | Out-File '.\tools\chocolateyinstall.ps1' -Encoding utf8

# パッケージ作成とテスト
choco pack
choco install terraform-provider-sakuracloud -s .\ -f
choco uninstall terraform-provider-sakuracloud
```

> **注意**: テンプレートファイルのプレースホルダー（`__VERSION__`, `__URL_32__`, `__URL_64__`, `__HASH32__`, `__HASH64__`）を直接書き換えてコミットしないでください。これらはCI時に動的に置換されます。

## リポジトリ構成

| ファイル                                                                   | 説明                       |
|----------------------------------------------------------------------------|----------------------------|
| `terraform-provider-sakuracloud/terraform-provider-sakuracloud.nuspec`     | Chocolateyパッケージ定義   |
| `terraform-provider-sakuracloud/tools/chocolateyinstall.ps1`               | インストールスクリプト     |
| `terraform-provider-sakuracloud/tools/chocolateyuninstall.ps1`             | アンインストールスクリプト |
| `.github/workflows/chocolatey.yml`                                         | GitHub Actions CI/CD設定   |

## 関連リンク

- [terraform-provider-sakuracloud](https://github.com/sacloud/terraform-provider-sakuracloud) - さくらのクラウド用Terraformプロバイダー本体
- [Terraformドキュメント](https://docs.usacloud.jp/terraform/)
- [Chocolateyパッケージページ](https://community.chocolatey.org/packages/terraform-provider-sakuracloud)

## ライセンス

[MIT License](LICENSE)
