# Due to my limited time and energy, this project is no longer maintained. Feel free to fork it.
# 由于本人精力有限, 此项目已停止维护, 欢迎fork

---

## 🌐 本仓库（hea784/venera_0）：Venera 的维护 fork

这是 [venera-app/venera](https://github.com/venera-app/venera) 的一个持续维护分支，针对**移动端（Android）使用体验**做了优化，并提供开箱即用的 Android 安装包。

### 相对上游的改动

**网络**
- **弱网自动重试**：对所有漫画源透明地重试瞬时网络错误（连接超时、连接重置、服务器 5xx），采用指数退避（~300ms / ~600ms）。上游仅对实现了 `onLoadFailed` JS 钩子的源有重试，弱网下其他源容易一碰就失败。
- **图片加载性能**：大图缓冲改用 `BytesBuilder`，减少 `List<int>` 反复扩容与复制带来的开销（缩略图与内页均覆盖）。
- **断点续传校验**：分块下载现在校验 `206 Partial Content`，服务端返回整文件时不再把内容写坏到错误偏移。
- **更友好的错误提示**：网络错误由原始的 Dio 多行堆栈改为一行简洁的人话描述，保留 Cloudflare 验证与日志导出功能。

**稳定性（崩溃 / 数据正确性）**
- 修复阅读器在**图片加载完成前**点击、双击或收藏时的空指针崩溃；章节末评论页双击/长按同样不再崩溃。
- 修复**快速切章 / 退出阅读器**时多处 `setState after dispose` 崩溃（阅读器、章评、加载态共用组件）。
- 修复**抓取章节目录途中暂停**会静默保存缺章漫画的数据损坏问题。
- 修复**取消下载后目录不删除、进度永久卡死**的协程死锁。
- 修复下载取消时文件句柄泄漏、进度定时器泄漏与未捕获异常。
- 修复图片收藏本地回退传错 id、取消收藏后缓存永不清理的问题。

**汉化**
- 界面文案**全量简体中文 / 繁体中文**（各 487 条，零缺失）：补齐了上游遗留的 47 条未翻译字符串（网络错误、归档、文件夹已存在等）。
- **非中文系统下也显示中文**：本 fork 只内置中文翻译，系统语言为非中文时自动回退简体中文（上游会退化成英文原文）。
- 修正繁体判定：台湾 / 香港 / 澳门设备（`zh-TW`/`zh-HK`/`zh-MO`，无 scriptCode）现在正确显示繁体。
- 语言选项移除无对应翻译的 `en-US`；新增 zh-CN / zh-TW 应用商店文案。

**构建**
- 独立 Android 构建流水线：`build-android.yml` 可手动触发或打 `v*` tag 触发，自动产出已签名的 release APK 并上传产物 / 发布 Release。
- 保留 Flutter 迁移器写入的 AGP 兼容开关，新版 Flutter 也能本地构建；签名密钥文件已加入 `.gitignore`。
- 安装包同时启用 **v1 / v2 / v3 签名方案**，兼容 Android 6 及以上、以及签名校验较严格的国产 ROM。
- 使用本 fork 独立版本号（`1.6.3-fork.x`），与官方 `1.6.3` 区分；本 fork 各版本之间签名一致，可直接覆盖升级。

> 上游的 `feat/cdn`、`feat/button-layout` 等实验分支均已落后 master（无独有改动），本 fork 直接基于最新的 master。

### ⚠️ 从官方版迁移到本 fork（重要）

本 fork 使用**自己的签名密钥**，与官方 venera / F-Droid 版不同。Android 禁止用不同签名覆盖安装，因此**从官方版升级时必须先卸载旧版**：

1. （可选但推荐）先在旧版 **设置 → Data Sync** 备份数据，或手动记下已配置的漫画源
2. 卸载旧版 venera
3. 安装本 fork 的 APK

> 如果你之前装过本仓库发布的 `v1.6.3-fork.1` / `fork.2`，签名一致，**可以直接覆盖升级，无需卸载**。

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

