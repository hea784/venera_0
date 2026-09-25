# Due to my limited time and energy, this project is no longer maintained. Feel free to fork it.
# 由于本人精力有限, 此项目已停止维护, 欢迎fork

---

## 🌐 本仓库（hea784/venera_0）：Venera 的维护 fork

这是 [venera-app/venera](https://github.com/venera-app/venera) 的一个持续维护分支，针对**移动端（Android）使用体验**做了优化，并提供开箱即用的 Android 安装包。

### 相对上游的改动

- **网络稳定性**：对所有漫画源透明地自动重试瞬时网络错误（连接超时、连接重置、服务器 5xx），采用指数退避（~300ms / ~600ms）。上游仅对实现了 `onLoadFailed` JS 钩子的源有重试，弱网下其他源容易一碰就失败。
- **图片加载性能**：大图缓冲改用 `BytesBuilder`，减少 `List<int>` 反复扩容与复制带来的开销（缩略图与内页均覆盖）。
- **更友好的错误提示**：网络错误由原始的 Dio 多行堆栈改为一行简洁的人话描述，保留 Cloudflare 验证与日志导出功能。
- **独立 Android 构建流水线**：`build-android.yml` 可手动触发或打 `v*` tag 触发，自动产出已签名的 release APK 并上传产物 / 发布 Release。

> 上游的 `feat/cdn`、`feat/button-layout` 等实验分支均已落后 master（无独有改动），本 fork 直接基于最新的 master。

### 获取 Android 安装包

前往 [Releases](https://github.com/hea784/venera_0/releases) 下载 `venera-*.apk`；或在 Actions 中手动运行 **Build Android APK** 工作流，构建完成后下载 `venera-apk` 产物。APK 使用仓库内配置的签名密钥签名，同签名的新版本可直接覆盖升级。

### 本地构建

```bash
flutter pub get
flutter build apk --release   # 需要 JDK 17 与 Android SDK
```

---

# venera
[![flutter](https://img.shields.io/badge/flutter-3.41.4-blue)](https://flutter.dev/)
[![License](https://img.shields.io/github/license/venera-app/venera)](https://github.com/venera-app/venera/blob/master/LICENSE)
[![stars](https://img.shields.io/github/stars/venera-app/venera?style=flat)](https://github.com/venera-app/venera/stargazers)

[![Download](https://img.shields.io/github/v/release/venera-app/venera)](https://github.com/venera-app/venera/releases)
[![AUR Version](https://img.shields.io/aur/version/venera-bin)](https://aur.archlinux.org/packages/venera-bin)
[![F-Droid Version](https://img.shields.io/f-droid/v/com.github.wgh136.venera)](https://f-droid.org/packages/com.github.wgh136.venera/)

A comic reader that support reading local and network comics.

## Features
- Read local comics
- Use javascript to create comic sources
- Read comics from network sources
- Manage favorite comics
- Download comics
- View comments, tags, and other information of comics if the source supports
- Login to comment, rate, and other operations if the source supports

## Build from source
1. Clone the repository
2. Install flutter, see [flutter.dev](https://flutter.dev/docs/get-started/install)
3. Install rust, see [rustup.rs](https://rustup.rs/)
4. Build for your platform: e.g. `flutter build apk`

## Create a new comic source
See [Comic Source](doc/comic_source.md)

## Thanks

### Tags Translation
[EhTagTranslation](https://github.com/EhTagTranslation/Database)

The Chinese translation of the manga tags is from this project.

## Headless Mode
See [Headless Doc](doc/headless_doc.md)

